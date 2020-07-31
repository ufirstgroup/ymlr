# ymlr - A YAML Encoder for Elixir

ymlr is an elixir library to encode data into YAML documents.

## Examples

### Encode a single document - optionally with comments:

```elixir
    iex> Ymlr.document!(%{a: 1})
    """
    ---
    a: 1
    """

    iex> Ymlr.document!({"comment", %{a: 1}})
    """
    ---
    # comment
    a: 1
    """

    iex> Ymlr.document!({["comment 1", "comment 2"], %{"a" => "a", "b" => :b, "c" => "true", "d" => "100"}})
    """
    ---
    # comment 1
    # comment 2
    a: a
    b: b
    c: 'true'
    d: '100'
    """
```


### Encode a multiple documents

```elixir
    iex> Ymlr.documents!([%{a: 1}, %{b: 2}])
    """
    ---
    a: 1

    ---
    b: 2
    """
```
