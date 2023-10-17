defmodule Ymlr.EncodeTest do
  use ExUnit.Case
  doctest Ymlr.Encode

  alias Ymlr.Encode, as: MUT

  defmacro assert_encode(input) do
    quote do
      assert unquote(input) |> MUT.to_s!() |> YamlElixir.read_from_string!() == unquote(input)
    end
  end

  defmacro assert_encode(input, exptected_output, opts \\ []) do
    quote do
      assert unquote(input) |> MUT.to_s!() |> YamlElixir.read_from_string!() == unquote(input)
      assert MUT.to_s!(unquote(input), unquote(opts)) == unquote(exptected_output)
    end
  end

  describe "to_s!/1" do
    test "atoms" do
      assert MUT.to_s!(:a) == "a"
    end

    test "empty string" do
      assert_encode("", "''")
    end

    test "simple string" do
      assert_encode("hello world", "hello world")
    end

    # see http://blogs.perl.org/users/tinita/2018/03/strings-in-yaml---to-quote-or-not-to-quote.html

    test "quoted strings - avoid type confusion" do
      assert_encode("yes", ~S('yes'))
      assert_encode("no", ~S('no'))
      assert_encode("true", ~S('true'))
      assert_encode("false", ~S('false'))
      assert_encode("True", ~S('True'))
      assert_encode("False", ~S('False'))
      assert_encode("1", ~S('1'))
      assert_encode("1.2", ~S('1.2'))
      assert_encode("-1", ~S('-1'))
      assert_encode("1e3", ~S('1e3'))
      assert_encode("0b1010", ~S('0b1010'))
      assert_encode("0o777", ~S('0o777'))
      assert_encode("0x1F", ~S('0x1F'))
      assert_encode("null", ~S('null'))
    end

    test "quoted strings - avoid mapping confusion" do
      assert_encode("hello: world", ~S('hello: world'))
    end

    test "quoted strings - avoid comment confusion" do
      assert_encode("hello #world", ~S('hello #world'))
    end

    test "quoted strings - starts with special char" do
      assert_encode("!tag", ~S('!tag'))
      assert_encode("&anchor", ~S('&anchor'))
      assert_encode("*alias", ~S('*alias'))
      assert_encode("- block sequence enty", ~S('- block sequence enty'))
      assert_encode(": block mapping entry", ~S(': block mapping entry'))
      assert_encode("? explicit mapping key", ~S('? explicit mapping key'))
      assert_encode("{flow_mapping", ~S('{flow_mapping'))
      assert_encode("}flow_mapping", ~S('}flow_mapping'))
      assert_encode(":{ block flow", ~S(':{ block flow'))
      assert_encode("[sequence_mapping", ~S('[sequence_mapping'))
      assert_encode("]sequence_mapping", ~S(']sequence_mapping'))

      assert MUT.to_s!(",flow_collection_entry_separator") ==
               ~S(',flow_collection_entry_separator')

      assert_encode("#comment", ~S('#comment'))
      assert_encode("|block_scalar", ~S('|block_scalar'))
      assert_encode(">block_scalar", ~S('>block_scalar'))
      assert_encode(~S("double_quote), ~S('"double_quote'))
      assert_encode(~S('single_quote), ~S("'single_quote"))
      # see https://yaml.org/spec/1.2.2/#rule-c-reserved
      assert_encode("@reserved", ~S('@reserved'))
      assert_encode("`reserved", ~S('`reserved'))
    end

    test "quoted strings - ends with colon" do
      assert_encode("some:entry:", ~S('some:entry:'))
    end

    test "quoted strings - escape seq forces double quotes (tab char)" do
      assert_encode("a\tb", ~s("a\tb"))
      assert_encode("!a\tb", ~s("!a\tb"))
      assert_encode(~S(@a\nb), ~s('@a\\nb'))
    end

    test "quoted strings - listy and mappy things" do
      # ... (prefer single quotes)
      assert_encode("[]", ~S('[]'))
      assert_encode(~S(["hello"]), ~S('["hello"]'))
      assert_encode(~S(["he|\o"]), ~S('["he|\o"]'))
      assert_encode("{}", ~S('{}'))
      assert_encode("[{}]", ~S('[{}]'))
      # ... (use double quotes if string contains single quotes)
      assert_encode(~S(["I don't know!\nRea|\y?"]), ~S("[\"I don't know!\\nRea|\\y?\"]"))
    end

    test "quoted strings - in map key" do
      assert_encode(%{"!key" => "value"}, ~S('!key': value))
      assert_encode(%{"@key" => "value"}, ~S('@key': value))
      assert_encode(%{"true" => "value"}, ~S('true': value))
    end

    test "bitstrings" do
      assert_raise Protocol.UndefinedError, ~r/cannot encode a bitstring to YAML/, fn ->
        assert MUT.to_s!(<<3::4>>)
      end
    end

    @tag skip: "not sure about those => to be reviewed"
    # https://yaml.org/spec/1.2.2/#example-escaped-characters
    test "quoted strings - example-escaped-characters from 1.2.2 spec" do
      assert_encode("Fun with \\", ~S("Fun with \\"))
      assert_encode("\" \u0007 \b \u001b \f", ~S("\" \a \b \e \f"))
      # assert_encode("\n \r \t \u000b \u0000", ~S("\n \r \t \v \0"))
      # or we use | when string contains newlines => rewrite the example to:
      assert_encode("\r \t \u000b \u0000", ~S("\r \t \v \0"))
      assert_encode("\u0020 \u00a0 \u0085 \u2028 \u2029", ~S("\  \_ \N \L \P"))
    end

    @tag skip: "not sure about those => review the spec"
    test "quoted strings - in map key (requires escape char)" do
      assert_encode(%{"a\tb" => "value"}, ~s("a\tb": value))
      assert_encode(%{"a\rb" => "value"}, ~s("a\rb": value))
    end

    test "newline in map key" do
      assert_encode(%{"a\nb" => "value"}, ~S("a\nb": value))
    end

    test "integers" do
      assert_encode(1, "1")
    end

    test "floats" do
      assert_encode(1.2, "1.2")
    end

    test "decimals" do
      assert MUT.to_s!(Decimal.new("1.2")) == "1.2"
    end

    test "hex and oversize float" do
      assert MUT.to_s!("7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718") ==
               "7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718"

      assert_encode("1.7976931348623157e+309", "1.7976931348623157e+309")
    end

    test "lists" do
      assert_encode([], "")
      assert_encode([1], "- 1")
      assert_encode([""], ~s(- ""))
      assert_encode([1, nil, 2], "- 1\n-\n- 2")
    end

    test "empty map" do
      assert_encode(%{}, "{}")
    end

    test "maps" do
      assert MUT.to_s!(%{a: 1}) == "a: 1"
      assert MUT.to_s!(%{a: 1, b: 2}) == "a: 1\nb: 2"
      assert_encode(%{"a" => 1, "b" => 2}, "a: 1\nb: 2")
      assert_encode(%{"a b" => 1, "c d" => 2}, "a b: 1\nc d: 2")
      assert_encode(%{1 => 1, 2 => 2}, "1: 1\n2: 2")
      assert MUT.to_s!(%{a: nil}) == "a:"
    end

    test "maps with atoms: true" do
      assert MUT.to_s!(%{a: 1}, atoms: true) == ":a: 1"
      assert MUT.to_s!(%{a: 1, b: 2}, atoms: true) == ":a: 1\n:b: 2"
      assert_encode(%{"a" => 1, "b" => 2}, "a: 1\nb: 2", atoms: true)
      assert_encode(%{"a b" => 1, "c d" => 2}, "a b: 1\nc d: 2", atoms: true)
      assert_encode(%{1 => 1, 2 => 2}, "1: 1\n2: 2", atoms: true)
      assert MUT.to_s!(%{a: nil}, atoms: true) == ":a:"
    end

    test "maps with sort_maps: true" do
      assert MUT.to_s!(Map.new(1..33, &{&1, &1}), sort_maps: true) |> String.starts_with?("1: 1")
    end

    test "invalid map key" do
      assert_raise ArgumentError, fn ->
        assert MUT.to_s!(%{%{a: 1} => 2})
      end
    end

    test "maps - string values" do
      assert MUT.to_s!(%{a: "a"}) == "a: a"
      assert MUT.to_s!(%{a: :b}) == "a: b"
      assert MUT.to_s!(%{a: "true"}) == "a: 'true'"
      assert MUT.to_s!(%{a: "1"}) == "a: '1'"
    end

    test "structs" do
      assert_raise Protocol.UndefinedError,
                   ~r/protocol Ymlr.Encoder not implemented/,
                   fn -> MUT.to_s!(%TestStruct{foo: 1, bar: 2}) end

      result = MUT.to_s!(%TestStructDerivedAll{foo: 1, bar: 2}) |> YamlElixir.read_from_string!()
      assert 1 == result["foo"]
      assert 2 == result["bar"]
      assert "foo: 1" == MUT.to_s!(%TestStructDerivedOnlyFoo{foo: 1, bar: 2})
      assert "bar: 2" == MUT.to_s!(%TestStructDerivedExceptFoo{foo: 1, bar: 2})

      result =
        assert MUT.to_s!(%TestStructDerivedExceptDefaults{foo: 1, bar: 1, baz: :error})
               |> YamlElixir.read_from_string!()

      assert 1 == result["foo"]
      assert "error" == result["baz"]
    end

    test "pids - not supported" do
      assert {:error, error} = MUT.to_s(self())
      assert is_binary(error)
    end

    test "tuples" do
      assert {:ok, "- a\n- b"} = MUT.to_s({"a", "b"})
    end

    test "tuples (nested) - not supported" do
      assert {:ok, "- - a\n  - b"} = MUT.to_s([{"a", "b"}])
    end

    test "nested: list / list" do
      assert_encode([[1, 2], [3, 4]], "- - 1\n  - 2\n- - 3\n  - 4")
    end

    test "nested: list / map" do
      assert MUT.to_s!([%{a: 1}, %{b: 2}]) == "- a: 1\n- b: 2"
      assert MUT.to_s!([%{a: 1, b: 2}]) == "- a: 1\n  b: 2"
    end

    test "nested: map / list" do
      expected =
        """
        a:
          - 1
          - 2
        b:
          - 3
          - 4
        """
        |> String.trim()

      assert MUT.to_s!(%{a: [1, 2], b: [3, 4]}) == expected
    end

    test "nested: map / empty list" do
      expected =
        """
        a: []
        """
        |> String.trim()

      assert MUT.to_s!(%{a: []}) == expected
    end

    test "nested: map / empty map" do
      expected =
        """
        a: {}
        """
        |> String.trim()

      assert MUT.to_s!(%{a: %{}}) == expected
    end

    test "nested: map / map" do
      result =
        assert MUT.to_s!(%{a: %{b: 1, c: %{d: 2}}, e: %{f: 3, g: 4}})
               |> YamlElixir.read_from_string!()

      assert 2 == result["a"]["c"]["d"]
      assert 1 == result["a"]["b"]
      assert 3 == result["e"]["f"]
      assert 4 == result["e"]["g"]
    end

    # see https://yaml-multiline.info/
    test "multiline strings" do
      assert_encode("hello\nworld", "|-\nhello\nworld")
      assert_encode("hello\nworld\n", "|\nhello\nworld")
    end

    test "newline only string - encoding" do
      given = "\n"
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)
      assert encoded == ~S("\n")
    end

    test "newline only string - in list" do
      given = ["\n"]
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)
      assert encoded == ~S(- "\n")

      given = [1, "\n"]
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)

      given = ["\n", 2]
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)

      given = [1, "\n", 3]
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)
      assert encoded == ~s(- 1\n- "\\n"\n- 3)
    end

    test "newline only string - in map" do
      given = %{"a" => "\n"}
      encoded = MUT.to_s!(given)
      assert given == YamlElixir.read_from_string!(encoded)
      assert encoded == ~S(a: "\n")
    end

    # see https://yaml.org/spec/1.2.2/#example-tabs-and-spaces
    test "multiline strings - mix spaces and tabs" do
      given = %{"block" => "void main() {\n\tprintf(\"Hello, world!\\n\");\n}\n"}
      encoded = MUT.to_s!(given)

      expected =
        """
        block: |
          void main() {
          \tprintf("Hello, world!\\n");
          }
        """

      # not working yet => TODO better handling of terminal newlines
      # assert YamlElixir.read_from_string!(encoded) == given
      # assert encoded == expected
      assert encoded == String.trim(expected)
    end

    test "nested: list / multiline string" do
      given = ["a\nb\n", "c"]
      encoded = MUT.to_s!(given)

      assert encoded == "- |\n  a\n  b\n- c"
    end

    test "nested: map / multiline string" do
      given = %{"a" => "a1\na2", "b" => "b1", "c" => "c1\nc2\n", "d" => "d1", "nl" => "\n"}
      encoded = MUT.to_s!(given)

      assert YamlElixir.read_from_string!(encoded) == given
    end

    test "date" do
      assert MUT.to_s!(~D[2016-05-24]) == "2016-05-24"
    end

    test "datetime" do
      assert MUT.to_s!(~U[2016-05-24 13:26:08Z]) == "2016-05-24T13:26:08Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.1Z]) == "2016-05-24T13:26:08.1Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.02Z]) == "2016-05-24T13:26:08.02Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.003Z]) == "2016-05-24T13:26:08.003Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.0004Z]) == "2016-05-24T13:26:08.0004Z"
    end
  end
end
