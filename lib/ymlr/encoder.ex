defmodule Ymlr.Encoder do
  @moduledoc """
  Encodes data into YAML strings.
  """

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @type data :: map() | [data] | atom() | binary() | number()

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

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.Encoder.to_s!(%{})
      "{}"

      iex> Ymlr.Encoder.to_s!(%{a: 1, b: 2})
      "a: 1\\nb: 2"

      iex> Ymlr.Encoder.to_s!(%{a: 1, b: :c}, atoms: true)
      ":a: 1\\n:b: :c"

      iex> Ymlr.Encoder.to_s!(%{"a" => "a", "b" => :b, "c" => "true", "d" => "100"})
      "a: a\\nb: b\\nc: 'true'\\nd: '100'"

      iex> Ymlr.Encoder.to_s!({"a", "b"})
      ** (ArgumentError) The given data {\"a\", \"b\"} cannot be converted to YAML.
  """
  @spec to_s!(data, keyword()) :: binary()
  def to_s!(data, opts \\ []) do
    data
    |> encode_as_io_list(0, Enum.into(opts, %{atoms: false}))
    |> IO.iodata_to_binary()
  end

  @doc """
  Encodes the given data as YAML string.

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.Encoder.to_s(%{a: 1, b: 2})
      {:ok, "a: 1\\nb: 2"}

      iex> Ymlr.Encoder.to_s(%{a: 1, b: :c}, atoms: true)
      {:ok, ":a: 1\\n:b: :c"}

      iex> Ymlr.Encoder.to_s({"a", "b"})
      {:error, "The given data {\\"a\\", \\"b\\"} cannot be converted to YAML."}
  """
  @spec to_s(data, keyword()) :: {:ok, binary()} | {:error, binary()}
  def to_s(data, opts \\ []) do
    yml = to_s!(data, opts)
    {:ok, yml}
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  defp encode_as_io_list(data, _level, _opts) when data == %{} do
    "{}"
  end

  defp encode_as_io_list(%Date{} = data, _, _), do: Date.to_iso8601(data)

  defp encode_as_io_list(%DateTime{} = data, _, _) do
    data |> DateTime.shift_zone!("Etc/UTC") |> DateTime.to_iso8601()
  end

  defp encode_as_io_list(data, level, opts) when is_map(data) do
    indentation = indent(level)
    data
    |> Map.to_list() # necessary for maps
    |> Keyword.delete(:__struct__) # if it actually was a map
    |> Enum.map(fn
      {key, nil} -> encode_map_key(key, opts)
      {key, value} when value == [] -> [encode_map_key(key, opts), " []"]
      {key, value} when value == %{} -> [encode_map_key(key, opts), " {}"]
      {key, value} when is_map(value) ->
        [encode_map_key(key, opts), indentation, "  " | encode_as_io_list(value, level + 1, opts)]
      {key, value} when is_list(value) ->
        [encode_map_key(key, opts), indentation, "  " | encode_as_io_list(value, level + 1, opts)]
      {key, value} -> [encode_map_key(key, opts), " " | encode_as_io_list(value, level + 1, opts)]
    end)
    |> Enum.intersperse(indentation)
  end

  defp encode_as_io_list(data, level, opts) when is_list(data) do
    indentation = indent(level)
    data
    |> Enum.map(fn
      nil -> "-"
      "" -> ~s(- "")
      value -> ["- " | encode_as_io_list(value, level + 1, opts)]
    end)
    |> Enum.intersperse(indentation)
  end

  defp encode_as_io_list(data, _, %{atoms: true}) when is_atom(data), do: [":", Atom.to_string(data)]
  defp encode_as_io_list(data, _, _) when is_atom(data), do: Atom.to_string(data)
  defp encode_as_io_list(data, level, opts) when is_binary(data), do: encode_binary(data, level, opts)

  defp encode_as_io_list(data, _, _) when is_number(data), do: "#{data}"

  defp encode_as_io_list(data, _, _), do: raise(ArgumentError, message: "The given data #{inspect(data)} cannot be converted to YAML.")

  defp encode_map_key(data, %{atoms: true}) when is_atom(data), do: [":", Atom.to_string(data), ":"]
  defp encode_map_key(data, _opts) when is_atom(data), do: [Atom.to_string(data), ":"]
  defp encode_map_key(data, opts) when is_binary(data), do: [encode_binary(data, nil, opts), ":"]
  defp encode_map_key(data, _opts) when is_number(data), do: "#{data}:"
  defp encode_map_key(data, _opts), do: raise(ArgumentError, message: "The given data #{inspect(data)} cannot be converted to YAML (map key).")

  defp encode_binary(data, level, _opts) do
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
