defmodule Ymlr.EncoderTest do
  use ExUnit.Case

  test "No errors for correct struct definitions" do
    defmodule TestStruct do
      defstruct [:foo, :bar]
    end

    defmodule TestStructDerivedAll do
      @derive Ymlr.Encoder
      defstruct [:foo, :bar]
    end

    defmodule TestStructDerivedOnlyFoo do
      @derive {Ymlr.Encoder, only: [:foo]}
      defstruct [:foo, :bar]
    end

    defmodule TestStructDerivedExceptFoo do
      @derive {Ymlr.Encoder, except: [:foo]}
      defstruct [:foo, :bar]
    end

    defmodule TestStructDerivedExceptDefaults do
      @derive {Ymlr.Encoder, except: :defaults}
      defstruct [:foo, bar: 1, baz: :ok]
    end
  end

  test "Raises if fields don't exist" do
    assert_raise ArgumentError, ~r/not defined in defstruct/, fn ->
      defmodule TestStructDerivedExceptRaises do
        @derive {Ymlr.Encoder, except: [:inexistent]}
        defstruct [:foo, :bar]
      end
    end

    assert_raise ArgumentError, ~r/not defined in defstruct/, fn ->
      defmodule TestStructDerivedOnlyRaises do
        @derive {Ymlr.Encoder, only: [:inexistent]}
        defstruct [:foo, :bar]
      end
    end
  end
end
