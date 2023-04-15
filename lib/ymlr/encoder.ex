defprotocol Ymlr.Encoder do
  @fallback_to_any true

  @type t :: term

  @spec encode(value::t(), idnent_level :: integer()) :: iodata()
  def encode(value, idnent_level \\ 0)

  # @spec encode_map_key(key::t()) :: iodata()
  # def encode_map_key(key)
end

defimpl Ymlr.Encoder, for: Any do
  defmacro __deriving__(module, struct, opts) do
    fields = fields_to_encode(struct, opts)

    quote do
      defimpl Ymlr.Encoder, for: unquote(module) do
        def encode(data, level) do
          data
          |> Map.from_struct()
          |> Map.take(unquote(fields))
          |> Ymlr.Encoder.encode(level)
        end
      end
    end
  end

  def encode(%_{} = struct, _level) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: struct,
      description: """
      Ymlr.Encoder protocol must always be explicitly implemented.
      If you own the struct, you can derive the implementation specifying \
      which fields should be encoded to YAML:
          @derive {Ymlr.Encoder, only: [....]}
          defstruct ...
      It is also possible to encode all fields, although this should be \
      used carefully to avoid accidentally leaking private information \
      when new fields are added:
          @derive Ymlr.Encoder
          defstruct ...
      Finally, if you don't own the struct you want to encode to YAML, \
      you may use Protocol.derive/3 placed outside of any module:
          Protocol.derive(Ymlr.Encoder, NameOfTheStruct, only: [...])
          Protocol.derive(Ymlr.Encoder, NameOfTheStruct)
      """
  end

  def encode(value, _level) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: value,
      description: "Ymlr.Encoder protocol must always be explicitly implemented"
  end

  defp fields_to_encode(struct, opts) do
    fields = Map.keys(struct)

    cond do
      only = Keyword.get(opts, :only) ->
        case only -- fields do
          [] ->
            only

          error_keys ->
            raise ArgumentError,
              "`:only` specified keys (#{inspect(error_keys)}) that are not defined in defstruct: " <>
                "#{inspect(fields -- [:__struct__])}"

        end

      except = Keyword.get(opts, :except) ->
        case except -- fields do
          [] ->
            fields -- [:__struct__ | except]

          error_keys ->
            raise ArgumentError,
              "`:except` specified keys (#{inspect(error_keys)}) that are not defined in defstruct: " <>
                "#{inspect(fields -- [:__struct__])}"

        end

      true ->
        fields -- [:__struct__]
    end
  end
end

defimpl Ymlr.Encoder, for: Map  do
  def encode(data, level), do: Ymlr.Encode.map(data, level)
end

defimpl Ymlr.Encoder, for: [Date, Time, NaiveDateTime]  do
  def encode(data, _level), do: @for.to_iso8601(data)
end

defimpl Ymlr.Encoder, for: DateTime  do
  def encode(data, _level) do
    data |> DateTime.shift_zone!("Etc/UTC") |> DateTime.to_iso8601()
  end
end

defimpl Ymlr.Encoder, for: List  do
  def encode(data, level), do: Ymlr.Encode.list(data, level)
end

defimpl Ymlr.Encoder, for: Atom  do
  def encode(data, level), do: Ymlr.Encode.atom(data, level)
end

defimpl Ymlr.Encoder, for: BitString do
  def encode(binary, opts) when is_binary(binary) do
    Ymlr.Encode.string(binary, opts)
  end

  def encode(bitstring, _opts) do
    raise Protocol.UndefinedError,
      protocol: @protocol,
      value: bitstring,
      description: "cannot encode a bitstring to YAML"
  end
end

defimpl Ymlr.Encoder, for: Integer do
  def encode(data, level), do: Ymlr.Encode.number(data, level)
end

defimpl Ymlr.Encoder, for: Float do
  def encode(data, level), do: Ymlr.Encode.number(data, level)
end

defimpl Ymlr.Encoder, for: Decimal do
  def encode(data, _opts) do
    # silence the xref warning
    decimal = Decimal
    decimal.to_string(data)
  end
end
