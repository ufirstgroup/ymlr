defmodule Ymlr.Encode do
  @moduledoc false

  alias Ymlr.Encoder

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @quote_when_first [
    "!", # tag
    "&", # anchor
    "*", # alias
    "{", "}", # flow mapping
    "[", "]", # flow sequence
    ",", # flow collection entry separator
    "#", # comment
    "|", ">", # block scalar
    "@", "`", # reserved characters
    "\"", "'", # double and single quotes
  ]

  @quote_when_last [
    ":", # colon
  ]

  @doc """
  Encodes the given data as YAML string. Raises if it cannot be encoded.

  ## Examples

      iex> Ymlr.Encode.to_s!(%{})
      "{}"

      iex> Ymlr.Encode.to_s!(%{a: 1, b: 2})
      "a: 1\\nb: 2"

      iex> Ymlr.Encode.to_s!(%{"a" => "a", "b" => :b, "c" => "true", "d" => "100"})
      "a: a\\nb: b\\nc: 'true'\\nd: '100'"
  """
  @spec to_s!(term()) :: binary()
  def to_s!(data) do
    data
    |> Ymlr.Encoder.encode()
    |> IO.iodata_to_binary()
  end

  @doc ~S"""
  Encodes the given data as YAML string.

  ## Examples

      iex> Ymlr.Encode.to_s(%{a: 1, b: 2})
      {:ok, "a: 1\nb: 2"}
  """
  @spec to_s(term()) :: {:ok, binary()} | {:error, binary()}
  def to_s(data) do
    yml = to_s!(data)
    {:ok, yml}
  rescue
    e in Protocol.UndefinedError -> {:error, Exception.message(e)}
  end

  @spec map(map(), integer) :: iodata()
  def map(data, _level) when data == %{}, do: "{}"

  def map(data, level) when is_map(data) do
    indentation = indent(level)
    data
    |> Map.to_list() # necessary for maps
    |> Enum.map(fn
      {key, nil} -> encode_map_key(key)
      {key, value} when value == [] -> [encode_map_key(key), " []"]
      {key, value} when value == %{} -> [encode_map_key(key), " {}"]
      {key, value} when is_map(value)  -> [encode_map_key(key), indentation, "  " | Encoder.encode(value, level + 1)]
      {key, value} when is_list(value) -> [encode_map_key(key), indentation, "  " | Encoder.encode(value, level + 1)]
      {key, value} -> [encode_map_key(key), " " | Encoder.encode(value, level + 1)]
    end)
    |> Enum.intersperse(indentation)
  end

  @spec list(list(), integer) :: iodata()
  def list(data, level) do
    indentation = indent(level)
    data
    |> Enum.map(fn
      nil -> "-"
      "" -> ~s(- "")
      value -> ["- " | Encoder.encode(value, level + 1)]
    end)
    |> Enum.intersperse(indentation)
  end

  @spec atom(atom(), integer) :: iodata()
  def atom(data, _), do: Atom.to_string(data)

  @spec string(binary(), integer) :: iodata()
  def string(data, level), do: encode_binary(data, level)

  @spec number(number(), integer) :: iodata()
  def number(data, _), do: "#{data}"

  defp encode_map_key(data) when is_atom(data), do: [Atom.to_string(data), ":"]
  defp encode_map_key(data) when is_binary(data), do: [encode_binary(data, nil), ":"]
  defp encode_map_key(data) when is_number(data), do: "#{data}:"
  defp encode_map_key(data), do: raise(ArgumentError, message: "The given data #{inspect(data)} cannot be converted to YAML (map key).")

  defp encode_binary(data, level) do
    cond do
      data == "" -> ~S('')
      data == "null" -> ~S('null')
      data == "yes" -> ~S('yes')
      data == "no" -> ~S('no')
      data == "true" -> ~S('true')
      data == "false" -> ~S('false')
      data == "True" -> ~S('True')
      data == "False" -> ~S('False')
      String.contains?(data, "\n") -> multiline(data, level)
      String.contains?(data, "\t") -> ~s("#{data}")
      String.at(data, 0) in @quote_when_first -> with_quotes(data)
      String.at(data, -1) in @quote_when_last -> with_quotes(data)
      String.starts_with?(data, "- ") -> with_quotes(data)
      String.starts_with?(data, ": ") -> with_quotes(data)
      String.starts_with?(data, "? ") -> with_quotes(data)
      String.contains?(data, " #") -> with_quotes(data)
      String.contains?(data, ": ") -> with_quotes(data)
      String.starts_with?(data, "0b") -> with_quotes(data)
      String.starts_with?(data, "0o") -> with_quotes(data)
      String.starts_with?(data, "0x") -> with_quotes(data)
      is_numeric(data) -> with_quotes(data)
      true -> data
    end
  end

  defp is_numeric(string) do
    case Float.parse(string) do
      {_, ""} -> true
      _ -> false
    end
  rescue
    # Apparently not needed anymore since Elixir 1.14. Left in for bc but stop covering.
    # coveralls-ignore-start
    _ -> false
    # coveralls-ignore-stop
  end

  defp with_quotes(data) do
    if String.contains?(data, "'") do
      ~s("#{escape(data)}")
    else
      ~s('#{data}')
    end
  end

  defp escape(data) do
    data |> String.replace("\\", "\\\\") |> String.replace(~s("), ~s(\\"))
  end

  # for example for map keys
  defp multiline(data, nil), do: inspect(data)
  # see https://yaml-multiline.info/
  defp multiline(data, level) do
    indentation = indent(level)
    block = data |> String.trim_trailing("\n") |> String.replace("\n", IO.iodata_to_binary(indentation))
    [block_chomping_indicator(data) | [indentation | block]]
  end

  defp block_chomping_indicator(data) do
    if String.ends_with?(data, "\n"), do: "|", else: "|-"
  end

  defp indent(level) do
    ["\n" | List.duplicate("  ", level)]
  end

end
