defmodule Ymlr.EncodeTestHelper do
  defmacro assert_identity(input, opts \\ []) do
    quote do: unquote(do_assert_identity(input, opts))
  end

  defmacro assert_output(input, exptected_output, opts \\ []) do
    quote do: unquote(do_assert_output(input, exptected_output, opts))
  end

  defmacro assert_identity_and_output(input, exptected_output, opts \\ []) do
    quote do
      unquote(do_assert_output(input, exptected_output, opts))
      unquote(do_assert_identity(input, opts))
    end
  end

  defp do_assert_identity(input, opts) do
    quote do
      assert unquote(input)
             |> Ymlr.document!(atoms: unquote(opts)[:atoms])
             |> YamlElixir.read_from_string!(atoms: unquote(opts)[:atoms]) ==
               unquote(input)
    end
  end

  defp do_assert_output(input, exptected_output, opts) do
    quote do
      assert Ymlr.Encode.to_s!(unquote(input), atoms: unquote(opts)[:atoms])
==
               unquote(exptected_output)
    end
  end
end
