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
  @spec to_s!(data) :: binary()
  def to_s!(data) do
    data
    |> encode_as_io_list()
    |> IO.iodata_to_binary()
  end

  @doc """
  Encodes the given data as YAML string.

  ## Examples

      iex> Ymlr.Encoder.to_s(%{a: 1, b: 2})
      {:ok, "a: 1\\nb: 2"}

      iex> Ymlr.Encoder.to_s({"a", "b"})
      {:error, "The given data {\\"a\\", \\"b\\"} cannot be converted to YAML."}
  """
  @spec to_s(data) :: {:ok, binary()} | {:error, binary()}
  def to_s(data) do
    yml = to_s!(data)
    {:ok, yml}
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  defp encode_as_io_list(data, level \\ 0)

  defp encode_as_io_list(data, _level) when data == %{} do
    "{}"
  end

  defp encode_as_io_list(%Date{} = data, _), do: Calendar.ISO.date_to_string(data.year, data.month, data.day)

  defp encode_as_io_list(%DateTime{} = data, _) do
    utc_data = data |> DateTime.shift_zone!("Etc/UTC")

    Calendar.ISO.datetime_to_string(
      utc_data.year,
      utc_data.month,
      utc_data.day,
      utc_data.hour,
      utc_data.minute,
      utc_data.second,
      utc_data.microsecond,
      utc_data.time_zone,
      "UTC",
      0,
      0
    )
  end

  defp encode_as_io_list(data, level) when is_map(data) do
    indentation = indent(level)
    data
    |> Enum.map(fn
      {key, nil} -> "#{key}:"
      {key, value} when value == [] -> "#{key}: []"
      {key, value} when value == %{} -> "#{key}: {}"
      {key, value} when is_map(value)  -> ["#{key}:" | [indentation | ["  " | encode_as_io_list(value, level + 1)]]]
      {key, value} when is_list(value) -> ["#{key}:" | [indentation | ["  " | encode_as_io_list(value, level + 1)]]]
      {key, value} -> ["#{key}: " | encode_as_io_list(value, level + 1)]
    end)
    |> Enum.intersperse(indentation)
  end

  defp encode_as_io_list(data, level) when is_list(data) do
    indentation = indent(level)
    data
    |> Enum.map(fn
      nil -> "-"
      "" -> ~s(- "")
      value -> ["- " | encode_as_io_list(value, level + 1)]
    end)
    |> Enum.intersperse(indentation)
  end

  defp encode_as_io_list(data, _) when is_atom(data), do: Atom.to_string(data)
  defp encode_as_io_list(data, level) when is_binary(data) do
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

  defp encode_as_io_list(data, _) when is_number(data), do: "#{data}"

  defp encode_as_io_list(data, _), do: raise(ArgumentError, message: "The given data #{inspect(data)} cannot be converted to YAML.")

  defp is_numeric(string) do
    case Float.parse(string) do
      {_, ""} -> true
      _ -> false
    end
  rescue
    _ -> false
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
