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
  @enforce_keys [:foo]
  defstruct [:foo, bar: 1, baz: :ok]
end
