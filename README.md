# ymlr - A YAML Encoder for Elixir

ymlr - A YAML encoder for Elixir.

[![Build Status](https://github.com/ufirstgroup/ymlr/workflows/CI/badge.svg)](https://github.com/ufirstgroup/ymlr/actions?query=workflow%3ACI)
[![codecov](https://codecov.io/gh/ufirstgroup/ymlr/branch/master/graph/badge.svg?token=DSLGDW6KS9)](https://codecov.io/gh/ufirstgroup/ymlr)

[![Hex.pm](http://img.shields.io/hexpm/v/ymlr.svg?style=flat)](https://hex.pm/packages/ymlr)
[![Total Download](https://img.shields.io/hexpm/dt/ymlr.svg)](https://hex.pm/packages/ymlr)

[![Documentation](https://img.shields.io/badge/documentation-on%20hexdocs-green.svg)](https://hexdocs.pm/ymlr/)
![Hex.pm](https://img.shields.io/hexpm/l/ymlr.svg?style=flat)


## Installation

The package can be installed by adding `ymlr` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ymlr, "~> 2.0"}
  ]
end
```

## Versions and Support

Version 2.0 does not support Elixir 1.10 anymore. However, for now all functionality is backported to version 1.x.

| Ymlr Version | Supported Elixir Version |
|:-------------:|:-------------:|
| ~> 2.0 | ~> 1.11 |
| ~> 1.0 | ~> 1.10 |

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
