# ymlr - A YAML Encoder for Elixir

ymlr - A YAML encoder for Elixir.

[![Build Status](https://github.com/ufirstgroup/ymlr/workflows/CI/badge.svg)](https://github.com/ufirstgroup/ymlr/actions?query=workflow%3ACI)
[![Coverage Status](https://coveralls.io/repos/github/ufirstgroup/ymlr/badge.svg?branch=master)](https://coveralls.io/github/ufirstgroup/ymlr?branch=master)
[![Hex.pm](http://img.shields.io/hexpm/v/ymlr.svg?style=flat)](https://hex.pm/packages/ymlr)
[![Documentation](https://img.shields.io/badge/documentation-on%20hexdocs-green.svg)](https://hexdocs.pm/ymlr/)
![Hex.pm](https://img.shields.io/hexpm/l/ymlr.svg?style=flat)


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

## A Word on Stability

This library is still in beta and should not be used in production. While it encodes most of the given data correctly,
there might still be some edge cases we haven't come across yet. Please help us find and fix those, preferably by
creating a pull request.
