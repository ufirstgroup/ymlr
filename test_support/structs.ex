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
