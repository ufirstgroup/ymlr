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

  ## Examples

      iex> Ymlr.Encoder.to_s!(%{})
      "{}"

      iex> Ymlr.Encoder.to_s!(%{a: 1, b: 2})
      "a: 1\\nb: 2"

      iex> Ymlr.Encoder.to_s!(%{"a" => "a", "b" => :b, "c" => "true", "d" => "100"})
      "a: a\\nb: b\\nc: 'true'\\nd: '100'"

      iex> Ymlr.Encoder.to_s!({"a", "b"})
      ** (ArgumentError) The given data {\"a\", \"b\"} cannot be converted to YAML.
  """
  @spec to_s!(data, binary()) :: binary()
  def to_s!(data, nl \\ "\n")

  def to_s!(data, _nl) when data == %{} do
    "{}"
  end

  def to_s!(data, nl) when is_map(data) do
    data
    |> Enum.map(fn
      {key, nil} -> "#{key}:"
      {key, value} when value == [] -> "#{key}: []"
      {key, value} when value == %{} -> "#{key}: {}"
      {key, value} when is_map(value)  -> "#{key}:" <> nl <> "  " <> to_s!(value, nl <> "  ")
      {key, value} when is_list(value) -> "#{key}:" <> nl <> "  " <> to_s!(value, nl <> "  ")
      {key, value} -> "#{key}: " <> to_s!(value, nl <> "  ")
    end)
    |> Enum.join(nl)
  end

  def to_s!(data, nl) when is_list(data) do
    data
    |> Enum.map(fn
      nil -> "-"
      "" -> ~s(- "")
      value -> "- " <> to_s!(value, nl <> "  ")
    end)
    |> Enum.join(nl)
  end

  def to_s!(data, _) when is_atom(data), do: Atom.to_string(data)
  def to_s!(data, nl) when is_binary(data) do
    cond do
      data == "" -> ~S('')
      data == "null" -> ~S('null')
      data == "yes" -> ~S('yes')
      data == "no" -> ~S('no')
      data == "true" -> ~S('true')
      data == "false" -> ~S('false')
      data == "True" -> ~S('True')
      data == "False" -> ~S('False')
      String.contains?(data, "\n") -> multiline(data, nl)
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

  def to_s!(data, _) when is_number(data), do: "#{data}"

  def to_s!(data, _), do: raise(ArgumentError, message: "The given data #{inspect(data)} cannot be converted to YAML.")

  @doc """
  Encodes the given data as YAML string.

  ## Examples

      iex> Ymlr.Encoder.to_s(%{a: 1, b: 2})
      {:ok, "a: 1\\nb: 2"}

      iex> Ymlr.Encoder.to_s({"a", "b"})
      {:error, "The given data {\\"a\\", \\"b\\"} cannot be converted to YAML."}
  """
  @spec to_s(data, binary()) :: {:ok, binary()} | {:error, binary()}
  def to_s(data, nl \\ "\n") do
    yml = to_s!(data, nl)
    {:ok, yml}
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  defp is_numeric(string) do
    case Float.parse(string) do
      {_, ""} -> true
      _ -> false
    end
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

  # see https://yaml-multiline.info/
  defp multiline(data, nl) do
    block = data |> String.trim_trailing("\n") |> String.replace("\n", nl)
    block_chomping_indicator(data) <> nl <> block
  end
  defp block_chomping_indicator(data) do
    if String.ends_with?(data, "\n"), do: "|", else: "|-"
  end

end
