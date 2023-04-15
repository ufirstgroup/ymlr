# ymlr - A YAML Encoder for Elixir

ymlr - A YAML encoder for Elixir.

[![Module Version](https://img.shields.io/hexpm/v/ymlr.svg)](https://hex.pm/packages/ymlr)
[![Coverage Status](https://coveralls.io/repos/github/ufirstgroup/ymlr/badge.svg?branch=main)](https://coveralls.io/github/ufirstgroup/ymlr?branch=main)
[![Last Updated](https://img.shields.io/github/last-commit/ufirstgroup/ymlr.svg)](https://github.com/ufirstgroup/ymlr/commits/main)

[![Build Status Code Qualits](https://github.com/ufirstgroup/ymlr/actions/workflows/code_quality.yaml/badge.svg)](https://github.com/ufirstgroup/ymlr/actions/workflows/code_quality.yaml)
[![Build Status Elixir](https://github.com/ufirstgroup/ymlr/actions/workflows/elixir_matrix.yaml/badge.svg)](https://github.com/ufirstgroup/ymlr/actions/workflows/elixir_matrix.yaml)

[![Hex Docs](https://img.shields.io/badge/hex-docs-lightgreen.svg)](https://hexdocs.pm/ymlr/)
[![Total Download](https://img.shields.io/hexpm/dt/ymlr.svg)](https://hex.pm/packages/ymlr)
[![License](https://img.shields.io/hexpm/l/ymlr.svg)](https://github.com/ufirstgroup/ymlr/blob/main/LICENSE)

## Installation

The package can be installed by adding `ymlr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ymlr, "~> 3.0"}
  ]
end
```

## Examples

See The usage livebook `usage.livemd` for more detailed examples.

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
