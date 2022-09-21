defmodule Ymlr do
  @moduledoc """
  Encodes data into YAML documents using the `Ymlr.Encoder`.
  Every document starts with a separator ("---") and can be enhanced with comments.
  """

  alias Ymlr.Encoder

  @type document :: Encoder.data | {binary(), Encoder.data} | {[binary()], Encoder.data}

  @doc """
  Encodes a given data as YAML document with a separator ("---") at the beginning. Raises if it cannot be encoded.

  Optinally you can pass a tuple with comment(s) and data as first argument.

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.document!(%{a: 1})
      "---\\na: 1\\n"

      iex> Ymlr.document!(%{a: 1, b: :c}, atoms: true)
      "---\\n:a: 1\\n:b: :c\\n"

      iex> Ymlr.document!({"comment", %{a: 1}})
      "---\\n# comment\\na: 1\\n"

      iex> Ymlr.document!({["comment 1", "comment 2"], %{a: 1}})
      "---\\n# comment 1\\n# comment 2\\na: 1\\n"

      iex> Ymlr.document!({[], {"a", "b"}})
      ** (ArgumentError) The given data {\"a\", \"b\"} cannot be converted to YAML.
  """
  @spec document!(document, keyword()) :: binary()
  def document!(document, opts \\ [])
  def document!({lines, data}, opts) when is_list(lines) do
    comments = Enum.map_join(lines, "", &("# #{&1}\n"))
    "---\n" <> comments <> Encoder.to_s!(data, opts) <> "\n"
  end
  def document!({comment, data}, opts), do: document!({[comment], data}, opts)

  def document!(data, opts) do
    document!({[], data}, opts)
  end

  @doc """
  Encodes a given data as YAML document with a separator ("---") at the beginning.

  Optinally you can pass a tuple with comment(s) and data as first argument.

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.document(%{a: 1})
      {:ok, "---\\na: 1\\n"}

      iex> Ymlr.document({"comment", %{a: 1}})
      {:ok, "---\\n# comment\\na: 1\\n"}

      iex> Ymlr.document(%{a: 1, b: :c}, atoms: true)
      {:ok, "---\\n:a: 1\\n:b: :c\\n"}

      iex> Ymlr.document({["comment 1", "comment 2"], %{a: 1}})
      {:ok, "---\\n# comment 1\\n# comment 2\\na: 1\\n"}

      iex> Ymlr.document({[], {"a", "b"}})
      {:error, "The given data {\\"a\\", \\"b\\"} cannot be converted to YAML."}
  """
  @spec document(document, keyword()) :: {:ok, binary()} | {:error, binary()}
  def document(document, opts \\ []) do
    yml = document!(document, opts)
    {:ok, yml}
  rescue
    e in ArgumentError -> {:error, e.message}
  end

  @doc """
  Encodes a given list of data as "---" separated YAML documents. Raises if it cannot be encoded.

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.documents!([%{a: 1}])
      "---\\na: 1\\n"

      iex> Ymlr.documents!([%{a: 1}, %{b: 2}])
      "---\\na: 1\\n\\n---\\nb: 2\\n"

      iex> Ymlr.documents!([%{a: 1, b: :c}, %{d: 2}], atoms: true)
      "---\\n:a: 1\\n:b: :c\\n\\n---\\n:d: 2\\n"

      iex> Ymlr.documents!([{[], {"a", "b"}}])
      ** (ArgumentError) The given data {\"a\", \"b\"} cannot be converted to YAML.

      iex> Ymlr.documents!(%{a: "a"})
      ** (ArgumentError) The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document.
  """
  @spec documents!([document], keyword()) :: binary()
  def documents!(documents, opts \\ [])
  def documents!(documents, opts) when is_list(documents), do: Enum.map_join(documents, "\n", &document!(&1, opts))
  def documents!(_documents, _opts), do:
    raise(ArgumentError, "The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document.")

  @doc """
  Encodes a given list of data as "---" separated YAML documents.

  ## Options

  - `:atoms` - If `true` will encode values and keys.

  ## Examples

      iex> Ymlr.documents([%{a: 1}])
      {:ok, "---\\na: 1\\n"}

      iex> Ymlr.documents([%{a: 1}, %{b: 2}])
      {:ok, "---\\na: 1\\n\\n---\\nb: 2\\n"}

      iex> Ymlr.documents([%{a: 1, b: :c}, %{d: 2}], atoms: true)
      {:ok, "---\\n:a: 1\\n:b: :c\\n\\n---\\n:d: 2\\n"}

      iex> Ymlr.documents([{[], {"a", "b"}}])
      {:error, "The given data {\\"a\\", \\"b\\"} cannot be converted to YAML."}

      iex> Ymlr.documents(%{a: "a"})
      {:error, "The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document."}
  """
  @spec documents([document], keyword()) :: {:ok, binary()} | {:error, binary()}
  def documents(documents, opts \\ []) do
    yml = documents!(documents, opts)
    {:ok, yml}
  rescue
    e in ArgumentError ->
      {:error, e.message}
  end
end
