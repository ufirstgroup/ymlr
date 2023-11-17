defmodule Ymlr.Encode do
  @moduledoc false

  alias Ymlr.Encoder

  # credo:disable-for-this-file Credo.Check.Refactor.CyclomaticComplexity

  @quote_when_first [
    # tag
    "!",
    # anchor
    "&",
    # alias
    "*",
    # flow mapping
    "{",
    "}",
    # flow sequence
    "[",
    "]",
    # flow collection entry separator
    ",",
    # comment
    "#",
    # block scalar
    "|",
    ">",
    # reserved characters
    "@",
    "`",
    # double and single quotes
    "\"",
    "'"
  ]

  @quote_when_last [
    # colon
    ":"
  ]

  @printable_chars List.flatten([
                     # Tab (\t)
                     0x09,
                     # Line feed (LF \n)
                     0x0A,
                     # Carriage Return (CR \r)
                     # 0x0D, theoretically printable, seems to require double quotes.
                     # Next Line (NEL)
                     0x85,
                     # Printable ASCII
                     Enum.to_list(0x20..0x7E),
                     # Basic Multilingual Plane (BMP)
                     Enum.to_list(0xA0..0xFF)
                   ])

  @non_printable_chars Enum.to_list(0x00..0xA0) -- @printable_chars
  @quoted_when_special @non_printable_chars ++ ~c"\a\b\e\f\v\0\u00a0\u0085\u2028\u2029"
  @quoted_when_special_strings Enum.map(@quoted_when_special, &<<&1::utf8>>)

  # see https://yaml.org/spec/1.2.2/#57-escaped-characters
  @escape_chars ~c"\a\b\e\f\r\v\0\u00a0\u0085\u2028\u2029\"\\"
  @escape_char_mapping Enum.zip(@escape_chars, ~c"abefrv0_NLP\"\\")
  @non_printable_special_chars @non_printable_chars -- @escape_chars

  @doc ~S"""
  Encodes the given data as YAML string. Raises if it cannot be encoded.

  ## Examples

      iex> Ymlr.Encode.to_s!(%{})
      "{}"

      iex> Ymlr.Encode.to_s!(%{a: 1, b: 2})
      "a: 1\nb: 2"

      iex> Ymlr.Encode.to_s!(%{"a" => "a", "b" => :b, "c" => "true", "d" => "100"})
      "a: a\nb: b\nc: 'true'\nd: '100'"
  """
  @spec to_s!(data :: term(), opts :: Encoder.opts()) :: binary()
  def to_s!(data, opts \\ []) do
    data
    |> Ymlr.Encoder.encode(0, opts)
    |> IO.iodata_to_binary()
  end

  @doc ~S"""
  Encodes the given data as YAML string.

  ## Examples

      iex> Ymlr.Encode.to_s(%{a: 1, b: 2})
      {:ok, "a: 1\nb: 2"}
  """
  @spec to_s(data :: term(), opts :: Encoder.opts()) :: {:ok, binary()} | {:error, binary()}
  def to_s(data, opts \\ []) do
    yml = to_s!(data, opts)
    {:ok, yml}
  rescue
    e in Protocol.UndefinedError -> {:error, Exception.message(e)}
  end

  @spec map(data :: map(), indent_level :: integer, opts :: Encoder.opts()) :: iodata()
  def map(data, _indent_level, _opts) when data == %{}, do: "{}"

  def map(data, indent_level, opts) when is_map(data) do
    indentation = indent(indent_level)
    key_encoder = if opts[:atoms], do: &encode_map_key_atoms/1, else: &encode_map_key/1
    data = if opts[:sort_maps], do: Enum.sort(data), else: data

    data
    |> Enum.map(fn
      {key, nil} ->
        key_encoder.(key)

      {key, value} when value == [] ->
        [key_encoder.(key), " []"]

      {key, value} when value == %{} ->
        [key_encoder.(key), " {}"]

      {key, value} when is_map(value) ->
        [key_encoder.(key), indentation, "  " | Encoder.encode(value, indent_level + 1, opts)]

      {key, value} when is_list(value) ->
        [key_encoder.(key), indentation, "  " | Encoder.encode(value, indent_level + 1, opts)]

      {key, value} ->
        [key_encoder.(key), " " | Encoder.encode(value, indent_level + 1, opts)]
    end)
    |> Enum.intersperse(indentation)
  end

  @spec list(data :: list(), indent_level :: integer, opts :: Encoder.opts()) :: iodata()
  def list([], _, _), do: "[]"

  def list(data, indent_level, opts) do
    indentation = indent(indent_level)

    data
    |> Enum.map(fn
      nil -> "-"
      "" -> ~s(- "")
      value -> ["- " | Encoder.encode(value, indent_level + 1, opts)]
    end)
    |> Enum.intersperse(indentation)
  end

  @spec atom(atom()) :: iodata()
  def atom(data), do: Atom.to_string(data)

  @spec string(binary(), integer) :: iodata()
  def string(data, indent_level), do: encode_binary(data, indent_level)

  @spec number(number()) :: iodata()
  def number(data), do: "#{data}"

  defp encode_map_key_atoms(data) when is_atom(data), do: [":", Atom.to_string(data), ":"]
  defp encode_map_key_atoms(data), do: encode_map_key(data)

  defp encode_map_key(data) when is_atom(data), do: [Atom.to_string(data), ":"]
  defp encode_map_key(data) when is_binary(data), do: [encode_binary(data, nil), ":"]
  defp encode_map_key(data) when is_number(data), do: "#{data}:"

  defp encode_map_key(data),
    do:
      raise(ArgumentError,
        message: "The given data #{inspect(data)} cannot be converted to YAML (map key)."
      )

  defp encode_binary(data, indent_level) do
    cond do
      data == "" -> ~S('')
      data == "~" -> ~S('~')
      data == "\n" -> ~S("\n")
      data == "null" -> ~S('null')
      data == "yes" -> ~S('yes')
      data == "no" -> ~S('no')
      data == "true" -> ~S('true')
      data == "false" -> ~S('false')
      data == "True" -> ~S('True')
      data == "False" -> ~S('False')
      String.contains?(data, "\n") -> multiline(data, indent_level)
      String.contains?(data, @quoted_when_special_strings) -> with_double_quotes(data)
      String.at(data, 0) in @quote_when_first -> with_quotes(data)
      String.at(data, -1) in @quote_when_last -> with_quotes(data)
      String.starts_with?(data, "- ") -> with_quotes(data)
      String.starts_with?(data, ": ") -> with_quotes(data)
      String.starts_with?(data, ":{") -> with_quotes(data)
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
    #  Apparently not needed anymore since Elixir 1.14. Left in for bc but stop covering.
    # coveralls-ignore-start
    _ ->
      false
      # coveralls-ignore-stop
  end

  defp with_quotes(data) do
    if String.contains?(data, "'") do
      with_double_quotes(data)
    else
      with_single_quotes(data)
    end
  end

  defp with_double_quotes(data) do
    ~s("#{escape(data)}")
  end

  defp with_single_quotes(data), do: ~s('#{data}')

  defp escape(data) do
    for <<char::utf8 <- data>> do
      escape_char(char)
    end
  end

  for {char, escaped} <- @escape_char_mapping do
    defp escape_char(unquote(char)), do: <<?\\, unquote(escaped)>>
  end

  for uchar <- @non_printable_special_chars do
    unicode_sequence = List.to_string(:io_lib.format("\\x~2.16.0B", [uchar]))
    defp escape_char(unquote(uchar)), do: unquote(unicode_sequence)
  end

  defp escape_char(char), do: char

  # for example for map keys
  defp multiline(data, nil), do: inspect(data)
  # see https://yaml-multiline.info/
  defp multiline(data, level) do
    # This is pure aesthetics: If we are on level 0 (no indentation), we add one
    # level of indentation to make it look a bit nicer.
    indentation = indent(if level == 0, do: 1, else: level)

    block =
      data
      |> String.replace_suffix("\n", "")
      |> String.split("\n")
      |> Enum.map(fn
        "" ->
          "\n"

        line ->
          [indentation, line]
      end)

    [block_chomping_indicator(data) | [block]]
  end

  defp block_chomping_indicator(data) do
    cond do
      String.ends_with?(data, "\n\n") -> "|+"
      String.ends_with?(data, "\n") -> "|"
      :otherwise -> "|-"
    end
  end

  defp indent(level) do
    ["\n" | List.duplicate("  ", level)]
  end
end
