defmodule Ymlr do
  @moduledoc """
  Encodes data into YAML documents using the `Ymlr.Encoder` protocol.
  Every document starts with a separator ("---") and can be enhanced with comments.
  """

  alias Ymlr.Encode

  @type document :: term() | {binary(), term()} | {[binary()], term()}

  @doc ~S"""
  Encodes a given data as YAML document with a separator ("---") at the beginning. Raises if it cannot be encoded.

  Optinally you can pass a tuple with comment(s) and data as first argument.

  ## Examples

      iex> Ymlr.document!(%{a: 1})
      "---\na: 1\n"

      iex> Ymlr.document!({"comment", %{a: 1}})
      "---\n# comment\na: 1\n"

      iex> Ymlr.document!({["comment 1", "comment 2"], %{a: 1}})
      "---\n# comment 1\n# comment 2\na: 1\n"
  """
  @spec document!(document) :: binary()
  def document!(document)
  def document!({lines, data}) when is_list(lines) do
    comments = Enum.map_join(lines, "", &("# #{&1}\n"))
    "---\n" <> comments <> Encode.to_s!(data) <> "\n"
  end
  def document!({comment, data}), do: document!({[comment], data})

  def document!(data) do
    document!({[], data})
  end

  @doc ~S"""
  Encodes a given data as YAML document with a separator ("---") at the beginning.

  Optinally you can pass a tuple with comment(s) and data as first argument.

  ## Examples

      iex> Ymlr.document(%{a: 1})
      {:ok, "---\na: 1\n"}

      iex> Ymlr.document({"comment", %{a: 1}})
      {:ok, "---\n# comment\na: 1\n"}

      iex> Ymlr.document({["comment 1", "comment 2"], %{a: 1}})
      {:ok, "---\n# comment 1\n# comment 2\na: 1\n"}
  """
  @spec document(document) :: {:ok, binary()} | {:error, binary()}
  def document(document) do
    yml = document!(document)
    {:ok, yml}
  rescue
    e in Protocol.UndefinedError -> {:error, Exception.message(e)}
  end

  @doc ~S"""
  Encodes a given list of data as "---" separated YAML documents. Raises if it cannot be encoded.

  ## Examples

      iex> Ymlr.documents!([%{a: 1}])
      "---\na: 1\n"

      iex> Ymlr.documents!([%{a: 1}, %{b: 2}])
      "---\na: 1\n\n---\nb: 2\n"

      iex> Ymlr.documents!(%{a: "a"})
      ** (ArgumentError) The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document.
  """
  def documents!(documents) when is_list(documents), do: Enum.map_join(documents, "\n", &document!/1)
  def documents!(_documents), do:
    raise(ArgumentError, "The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document.")

  @doc ~S"""
  Encodes a given list of data as "---" separated YAML documents.

  ## Examples

      iex> Ymlr.documents([%{a: 1}])
      {:ok, "---\na: 1\n"}

      iex> Ymlr.documents([%{a: 1}, %{b: 2}])
      {:ok, "---\na: 1\n\n---\nb: 2\n"}

      iex> Ymlr.documents(%{a: "a"})
      {:error, "The given argument is not a list of documents. Use document/1, document/2, document!/1 or document!/2 for a single document."}
  """
  @spec documents([document]) :: {:ok, binary()} | {:error, binary()}
  def documents(documents) do
    yml = documents!(documents)
    {:ok, yml}
  rescue
    e in Protocol.UndefinedError ->
      {:error, Exception.message(e)}
    e in ArgumentError ->
      {:error, Exception.message(e)}
  end
end
