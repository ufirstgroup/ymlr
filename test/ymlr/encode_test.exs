defmodule Ymlr.EncodeTest do
  use ExUnit.Case
  doctest Ymlr.Encode

  import Ymlr.EncodeTestHelper

  alias Ymlr.Encode, as: MUT

  describe "to_s!/1" do
    test "atoms" do
      assert_output(:a, "a")
    end

    test "empty string" do
      assert_identity_and_output("", "''")
    end

    test "simple string" do
      assert_identity_and_output("hello world", "hello world")
    end

    # see http://blogs.perl.org/users/tinita/2018/03/strings-in-yaml---to-quote-or-not-to-quote.html

    test "quoted strings - avoid type confusion" do
      assert_identity_and_output("yes", ~S('yes'))
      assert_identity_and_output("no", ~S('no'))
      assert_identity_and_output("true", ~S('true'))
      assert_identity_and_output("false", ~S('false'))
      assert_identity_and_output("True", ~S('True'))
      assert_identity_and_output("False", ~S('False'))
      assert_identity_and_output("1", ~S('1'))
      assert_identity_and_output("1.2", ~S('1.2'))
      assert_identity_and_output("-1", ~S('-1'))
      assert_identity_and_output("1e3", ~S('1e3'))
      assert_identity_and_output("0b1010", ~S('0b1010'))
      assert_identity_and_output("0o777", ~S('0o777'))
      assert_identity_and_output("0x1F", ~S('0x1F'))
      assert_identity_and_output("null", ~S('null'))
    end

    test "quoted strings - avoid mapping confusion" do
      assert_identity_and_output("hello: world", ~S('hello: world'))
    end

    test "quoted strings - avoid comment confusion" do
      assert_identity_and_output("hello #world", ~S('hello #world'))
    end

    test "quoted strings - starts with special char" do
      assert_identity_and_output("!tag", ~S('!tag'))
      assert_identity_and_output("&anchor", ~S('&anchor'))
      assert_identity_and_output("*alias", ~S('*alias'))
      assert_identity_and_output("- block sequence enty", ~S('- block sequence enty'))
      assert_identity_and_output(": block mapping entry", ~S(': block mapping entry'))
      assert_identity_and_output("? explicit mapping key", ~S('? explicit mapping key'))
      assert_identity_and_output("{flow_mapping", ~S('{flow_mapping'))
      assert_identity_and_output("}flow_mapping", ~S('}flow_mapping'))
      assert_identity_and_output(":{ block flow", ~S(':{ block flow'))
      assert_identity_and_output("[sequence_mapping", ~S('[sequence_mapping'))
      assert_identity_and_output("]sequence_mapping", ~S(']sequence_mapping'))

      assert_identity_and_output(
        ",flow_collection_entry_separator",
        ~S(',flow_collection_entry_separator')
      )

      assert_identity_and_output("#comment", ~S('#comment'))
      assert_identity_and_output("|block_scalar", ~S('|block_scalar'))
      assert_identity_and_output(">block_scalar", ~S('>block_scalar'))
      assert_identity_and_output(~S("double_quote), ~S('"double_quote'))
      assert_identity_and_output(~S('single_quote), ~S("'single_quote"))
      # see https://yaml.org/spec/1.2.2/#rule-c-reserved
      assert_identity_and_output("@reserved", ~S('@reserved'))
      assert_identity_and_output("`reserved", ~S('`reserved'))
    end

    test "quoted strings - ends with colon" do
      assert_identity_and_output("some:entry:", ~S('some:entry:'))
    end

    test "quoted strings - escape seq forces double quotes (tab char)" do
      assert_identity_and_output("a\tb", ~s("a\tb"))
      assert_identity_and_output("!a\tb", ~s("!a\tb"))
      # Not for explicit backslash:
      assert_identity_and_output(~S(!a\tb), ~S('!a\tb'))
    end

    test "quoted strings - listy and mappy things" do
      # ... (prefer single quotes)
      assert_identity_and_output("[]", ~S('[]'))
      assert_identity_and_output(~S(["hello"]), ~S('["hello"]'))
      assert_identity_and_output(~S(["he|\o"]), ~S('["he|\o"]'))
      assert_identity_and_output("{}", ~S('{}'))
      assert_identity_and_output("[{}]", ~S('[{}]'))
      # ... (use double quotes if string contains single quotes)
      assert_identity_and_output(
        ~S(["I don't know!\nRea|\y?"]),
        ~S("[\"I don't know!\\nRea|\\y?\"]")
      )
    end

    test "quoted strings - in map key" do
      assert_identity_and_output(%{"!key" => "value"}, ~S('!key': value))
      assert_identity_and_output(%{"@key" => "value"}, ~S('@key': value))
      assert_identity_and_output(%{"true" => "value"}, ~S('true': value))
    end

    test "bitstrings" do
      assert_raise Protocol.UndefinedError, ~r/cannot encode a bitstring to YAML/, fn ->
        MUT.to_s!(<<3::4>>)
      end
    end

    @tag skip: "not sure about those => to be reviewed"
    # https://yaml.org/spec/1.2.2/#example-escaped-characters
    test "quoted strings - example-escaped-characters from 1.2.2 spec" do
      assert_identity_and_output("Fun with \\", ~S("Fun with \\"))
      assert_identity_and_output("\" \u0007 \b \u001b \f", ~S("\" \a \b \e \f"))
      # assert_identity_and_output("\n \r \t \u000b \u0000", ~S("\n \r \t \v \0"))
      # or we use | when string contains newlines => rewrite the example to:
      assert_identity_and_output("\r \t \u000b \u0000", ~S("\r \t \v \0"))
      assert_identity_and_output("\u0020 \u00a0 \u0085 \u2028 \u2029", ~S("\  \_ \N \L \P"))
    end

    @tag skip: "not sure about those => review the spec"
    test "quoted strings - in map key (requires escape char)" do
      assert_identity_and_output(%{"a\tb" => "value"}, ~s("a\tb": value))
      assert_identity_and_output(%{"a\rb" => "value"}, ~s("a\rb": value))
    end

    test "newline in map key" do
      assert_identity_and_output(%{"a\nb" => "value"}, ~S("a\nb": value))
    end

    test "integers" do
      assert_identity_and_output(1, "1")
    end

    test "floats" do
      assert_identity_and_output(1.2, "1.2")
    end

    test "decimals" do
      assert_output(Decimal.new("1.2"), "1.2")
    end

    test "hex and oversize float" do
      assert_identity_and_output(
        "7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718",
        "7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718"
      )

      assert_identity_and_output("1.7976931348623157e+309", "1.7976931348623157e+309")
    end

    test "lists" do
      assert_identity_and_output([], "[]")
      assert_identity_and_output([1], "- 1")
      assert_identity_and_output([""], ~s(- ""))
      assert_identity_and_output([1, nil, 2], "- 1\n-\n- 2")
    end

    test "empty map" do
      assert_identity_and_output(%{}, "{}")
    end

    test "maps" do
      assert_identity_and_output(%{a: 1}, ":a: 1", atoms: true)
      assert_identity_and_output(%{a: 1, b: 2}, ":a: 1\n:b: 2", atoms: true)
      assert_identity_and_output(%{"a" => 1, "b" => 2}, "a: 1\nb: 2")
      assert_identity_and_output(%{"a b" => 1, "c d" => 2}, "a b: 1\nc d: 2")
      assert_identity_and_output(%{1 => 1, 2 => 2}, "1: 1\n2: 2")
      assert_identity_and_output(%{a: nil}, ":a:", atoms: true)
    end

    test "maps with atoms: true" do
      assert_identity_and_output(%{a: 1}, ":a: 1", atoms: true)
      assert_identity_and_output(%{a: 1, b: 2}, ":a: 1\n:b: 2", atoms: true)
      assert_identity_and_output(%{"a" => 1, "b" => 2}, "a: 1\nb: 2")
      assert_identity_and_output(%{"a b" => 1, "c d" => 2}, "a b: 1\nc d: 2")
      assert_identity_and_output(%{1 => 1, 2 => 2}, "1: 1\n2: 2")
      assert_identity_and_output(%{a: nil}, ":a:", atoms: true)
    end

    test "maps with sort_maps: true" do
      assert MUT.to_s!(Map.new(1..33, &{&1, &1}), sort_maps: true) |> String.starts_with?("1: 1")
    end

    test "invalid map key" do
      assert_raise ArgumentError, fn ->
        MUT.to_s!(%{%{a: 1} => 2}, atoms: true)
      end
    end

    test "maps - string values" do
      assert_identity_and_output(%{a: "a"}, ":a: a", atoms: true)
      assert_output(%{a: :b}, ":a: b", atoms: true)
      assert_identity_and_output(%{a: "true"}, ":a: 'true'", atoms: true)
      assert_identity_and_output(%{a: "1"}, ":a: '1'", atoms: true)
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
        MUT.to_s!(%TestStructDerivedExceptDefaults{foo: 1, bar: 1, baz: :error})
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
      assert_identity_and_output([[1, 2], [3, 4]], "- - 1\n  - 2\n- - 3\n  - 4")
    end

    test "nested: list / map" do
      assert_identity_and_output([%{a: 1}, %{b: 2}], "- :a: 1\n- :b: 2", atoms: true)
      assert_identity_and_output([%{a: 1, b: 2}], "- :a: 1\n  :b: 2", atoms: true)
    end

    test "nested: map / list" do
      expected =
        """
        :a:
          - 1
          - 2
        :b:
          - 3
          - 4
        """
        |> String.trim()

      assert_identity_and_output(%{a: [1, 2], b: [3, 4]}, expected, atoms: true)
    end

    test "nested: map / empty list" do
      expected =
        """
        :a: []
        """
        |> String.trim()

      assert_identity_and_output(%{a: []}, expected, atoms: true)
    end

    test "nested: map / empty map" do
      expected =
        """
        :a: {}
        """
        |> String.trim()

      assert_identity_and_output(%{a: %{}}, expected, atoms: true)
    end

    test "nested: map / map" do
      result =
        MUT.to_s!(%{a: %{b: 1, c: %{d: 2}}, e: %{f: 3, g: 4}})
        |> YamlElixir.read_from_string!()

      assert 2 == result["a"]["c"]["d"]
      assert 1 == result["a"]["b"]
      assert 3 == result["e"]["f"]
      assert 4 == result["e"]["g"]
    end

    # see https://yaml-multiline.info/

    test "multiline strings - base cases" do
      assert_identity_and_output("a\n b\nc", "|-\n  a\n   b\n  c")
      assert_identity_and_output("a\n b\nc\n ", "|-\n  a\n   b\n  c\n   ")
      assert_identity_and_output("a\n b\nc\n", "|+\n  a\n   b\n  c")
    end

    @tag :wip
    test "multiline strings - with multiple consecutive newlines" do
      # to be discussed (same as above: indentation)
      assert_identity_and_output("a\n\nb", "|-\n  a\n\n  b")
    end

    test "multiline strings - with multiple terminal newlines" do
      # to be discussed (same as above: indentation)
      assert_identity_and_output("a\n\n", "|+\n  a\n")
      assert_identity_and_output("a\n b\nc\n\n", "|+\n  a\n   b\n  c\n")
      # just to be sure ... also check with 3 newlines
      assert_identity_and_output("a\n\n\n", "|+\n  a\n\n")
    end

    test "multiline strings - indented - base cases" do
      assert_identity_and_output(["a\n b\nc"], "- |-\n  a\n   b\n  c")
      assert_identity_and_output(["a\n b\nc\n "], "- |-\n  a\n   b\n  c\n   ")
      assert_identity_and_output(["a\n b\nc\n"], "- |+\n  a\n   b\n  c")
    end

    test "multiline strings - indented - with multiple consecutive newlines" do
      assert_identity_and_output(["a\n\nb"], "- |-\n  a\n\n  b")
      # also possible:          "- |-\n  a\n  \n  b"
    end

    test "multiline strings - indented - with multiple trailing newlines" do
      assert_identity_and_output(["a\n\n"], "- |+\n  a\n")
      assert_identity_and_output(["a\n b\nc\n\n"], "- |+\n  a\n   b\n  c\n")
    end

    test "multiline strings - nested - inside vs last" do
      # if we join the strings in the list with \n we end up with an extra newline in between
      # i.e.                            "- |+\n  a\n\n\n- |+\n  b\n\n"
      assert_identity_and_output(["a\n\n", "b\n\n"], "- |+\n  a\n\n- |+\n  b\n")

      # same with maps
      assert_identity_and_output(%{k1: "a\n\n", k2: "b\n\n"}, ":k1: |+\n  a\n\n:k2: |+\n  b\n",
        atoms: true
      )

      assert_identity_and_output(%{k1: "a\n\n", k2: "b\n\n"}, ":k1: |+\n  a\n\n:k2: |+\n  b\n",
        atoms: true
      )

      # just to be sure ... also check with 3 newlines
      assert_identity_and_output(["a\n\n\n"], "- |+\n  a\n\n")
      assert_identity_and_output(["a\n\n\n", "b"], "- |+\n  a\n\n\n- b")

      # and what about nested lists? => see test "nested: list / list / multiline string"
    end

    test "newline only string - encoding" do
      assert_identity_and_output("\n", ~S("\n"))
    end

    test "newline only string - in list" do
      assert_identity_and_output(["\n"], ~S(- "\n"))
      assert_identity([1, "\n"])
      assert_identity(["\n", 2])
      assert_identity_and_output([1, "\n", 3], ~s(- 1\n- "\\n"\n- 3))
    end

    test "newline only string - in map" do
      assert_identity_and_output(%{"a" => "\n"}, ~S(a: "\n"))
    end

    # see https://yaml.org/spec/1.2.2/#example-tabs-and-spaces
    test "multiline strings - mix spaces and tabs" do
      given = %{"block" => "void main() {\n\tprintf(\"Hello, world!\\n\");\n}\n"}

      expected =
        """
        block: |+
          void main() {
          \tprintf("Hello, world!\\n");
          }\
        """

      assert_identity_and_output(given, expected)
    end

    test "nested: list / multiline string" do
      assert_identity_and_output(["a\nb\n", "c"], "- |+\n  a\n  b\n- c")

      assert_identity([
        "a",
        "b\nc",
        "f\ng\n\n",
        "j\n\nk\n",
        "l\n\nm\n\n",
        "bo\np ",
        "q\nr\n ",
        "s\nt\n\n ",
        "u"
      ])
    end

    test "nested: list / list / multiline string - multiple trailing newlines" do
      given = [
        ["a\n\n", "b\n\n"],
        ["c\n\n", "d\n\n"]
      ]

      expected =
        """
        - - |+
            a

          - |+
            b

        - - |+
            c

          - |+
            d
        """

      assert_identity_and_output(given, expected)
    end

    test "nested: map / multiline string" do
      assert_identity(%{
        "a" => "a1",
        "c" => "c1\nc2\n",
        "d" => "d1\nd2\n\n",
        "e" => "e1\n\ne2",
        "f" => "f1\n\nf2\n",
        "g" => "g1\n\ng2\n\n",
        "h" => "",
        "i" => "\n",
        "j" => "\n"
      })
    end

    test "date" do
      assert_output(~D[2016-05-24], "2016-05-24")
    end

    test "datetime" do
      assert_output(~U[2016-05-24 13:26:08Z], "2016-05-24T13:26:08Z")
      assert_output(~U[2016-05-24 13:26:08.1Z], "2016-05-24T13:26:08.1Z")
      assert_output(~U[2016-05-24 13:26:08.02Z], "2016-05-24T13:26:08.02Z")
      assert_output(~U[2016-05-24 13:26:08.003Z], "2016-05-24T13:26:08.003Z")
      assert_output(~U[2016-05-24 13:26:08.0004Z], "2016-05-24T13:26:08.0004Z")
    end
  end
end
