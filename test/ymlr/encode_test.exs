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

    test "plain strings" do
      assert_identity_and_output("hello world", "hello world")
      assert_identity_and_output("that's it", "that's it")

      # Strings where the ":", "?", or "-" indicator character is used as the
      # first character may be encoded in Plain Style (without being quoted)
      # if followed by a non-space “safe” character.
      # https://yaml.org/spec/1.2.2/#733-plain-style
      assert_identity_and_output("?x", ~S(?x))
      assert_identity_and_output(":x", ~S(:x))
      assert_identity_and_output("-x", ~S(-x))
    end

    # see http://blogs.perl.org/users/tinita/2018/03/strings-in-yaml---to-quote-or-not-to-quote.html

    test "quoted strings - whitespace(s)" do
      # only whitespace(s)
      assert_identity_and_output(" ", ~S(' '))
      assert_identity("  ")
      # leading whitespace(s)
      assert_identity(" leading")
      assert_identity("  leading")
      assert_identity_and_output(" '", ~S(" '"))
      # trailing whitespace(s)
      assert_identity("trailing ")
      assert_identity("trailing  ")
      assert_identity_and_output("' ", ~S("' "))
    end

    test "quoted strings - avoid type confusion" do
      assert_identity_and_output("yes", ~S('yes'))
      assert_identity_and_output("no", ~S('no'))
      assert_identity_and_output("~", "'~'")
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
      assert_identity_and_output(".inf", ~S('.inf'))
      assert_identity_and_output(".Inf", ~S('.Inf'))
      assert_identity_and_output(".INF", ~S('.INF'))
      assert_identity_and_output("-.inf", ~S('-.inf'))
      assert_identity_and_output("-.Inf", ~S('-.Inf'))
      assert_identity_and_output("-.INF", ~S('-.INF'))
      assert_identity_and_output("+.inf", ~S('+.inf'))
      assert_identity_and_output("+.Inf", ~S('+.Inf'))
      assert_identity_and_output("+.INF", ~S('+.INF'))
      assert_identity_and_output(".nan", ~S('.nan'))
      assert_identity_and_output(".Nan", ~S('.Nan'))
      assert_identity_and_output(".NAN", ~S('.NAN'))
    end

    test "quoted strings - avoid mapping confusion" do
      assert_identity_and_output("hello: world", ~S('hello: world'))
    end

    test "quoted strings - avoid comment confusion" do
      assert_identity_and_output("hello #world", ~S('hello #world'))
    end

    test "quoted strings - indicator characters on their own" do
      assert_identity_and_output("-", ~S('-'))
      assert_identity_and_output("?", ~S('?'))
      assert_identity_and_output(":", ~S(':'))
      assert_identity_and_output("[", ~S('['))
      assert_identity_and_output("]", ~S(']'))
      assert_identity_and_output("{", ~S('{'))
      assert_identity_and_output("}", ~S('}'))
      assert_identity_and_output("#", ~S('#'))
      assert_identity_and_output("&", ~S('&'))
      assert_identity_and_output("&", ~S('&'))
      assert_identity_and_output("*", ~S('*'))
      assert_identity_and_output("*", ~S('*'))
      assert_identity_and_output("!", ~S('!'))
      assert_identity_and_output("!", ~S('!'))
      assert_identity_and_output("|", ~S('|'))
      assert_identity_and_output("|", ~S('|'))
      assert_identity_and_output(">", ~S('>'))
      assert_identity_and_output(">", ~S('>'))
      assert_identity_and_output("%", ~S(%))
      assert_identity_and_output("@", ~S('@'))
      assert_identity_and_output("`", ~S('`'))
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
      # see https://github.com/ufirstgroup/ymlr/issues/179
      assert_identity_and_output("a'b:", ~S("a'b:"))
    end

    test "quoted strings - specialties inside the string" do
      assert_identity_and_output("some: entry", ~S('some: entry'))
      assert_identity_and_output("some #entry", ~S('some #entry'))
      assert_identity_and_output("s'ome: entry", ~S("s'ome: entry"))
      assert_identity_and_output("s'ome #entry", ~S("s'ome #entry"))
    end

    # see https://github.com/ufirstgroup/ymlr/issues/179
    test "quoted strings - issue 179" do
      assert_identity(~S{a'b': })
      assert_identity(~S{'': })
    end

    test "quoted strings - tab char with and without quotes" do
      assert_identity_and_output("a\tb", ~s(a\tb))
      assert_identity_and_output("!a\tb", ~s('!a\tb'))
      # Not for explicit backslash:
      assert_identity_and_output(~S(!a\tb), ~S('!a\tb'))
    end

    test "quoted strings - listy and mappy things" do
      # ... (prefer single quotes)
      assert_identity_and_output("[]", ~S('[]'))
      assert_identity_and_output(~S(["hello"]), ~S('["hello"]'))
      assert_identity_and_output(~S(["he|\o"]), ~s('["he|\\o"]'))
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

    # https://yaml.org/spec/1.2.2/#example-escaped-characters
    test "quoted strings - example-escaped-characters from 1.2.2 spec" do
      assert_identity_and_output(~S(Fun with \\), ~S(Fun with \\))
      assert_identity_and_output("\" \u0007 \b \u001b \f", ~S("\" \a \b \e \f"))
      # Line breaks inside scalar content must be normalized by the YAML processor.
      # Each such line break must be parsed into a single line feed character.
      # The original line break format is a presentation detail and must not be
      # used to convey content information.
      # I.e. the following cannot be tested for identity as \r will be parsed as \n.
      assert_output("\n\r \t \u000b \u0000", "|-\n\n  \r \t \v \0")
      assert_identity_and_output("\r \t \u000b \u0000", ~s("\\r \t \\v \\0"))

      assert_identity_and_output(
        "\u0020 \u00a0 \u0085 \u2028 \u2029",
        ~S("  \_ \N \L \P")
      )

      # Possible formats: \x13 \u0013 \U00000013.
      assert_identity_and_output(
        # last character is "\u{20046}"
        "\u0013\uFFFD\uFFFE𠁆",
        "\"\\x13\uFFFD\\uFFFE𠁆\""
      )
    end

    test "quoted strings - in map key (requires escape char)" do
      assert_identity_and_output(%{"a\tb" => "value"}, ~s(a\tb: value))
      assert_identity_and_output(%{"a\rb" => "value"}, ~s("a\\rb": value))
    end

    test "newline in map key" do
      assert_identity_and_output(%{"a\nb" => "value"}, ~S("a\nb": value))
    end

    test "backslash" do
      # in plain string
      assert assert_identity_and_output(~S(a\b), ~S(a\b))
      # in single quote string
      assert assert_identity_and_output(~S(!a\b), ~S('!a\b'))
      # double quotes because of single quote
      assert assert_identity_and_output(~s(!a'b\\c), ~S("!a'b\\c"))
      # double quotes because of tab
      assert assert_identity_and_output(~s(a\tb\\c), ~s(a\tb\\c))
    end

    test "backslash in map key" do
      # in plain string
      assert assert_identity_and_output(%{~S(a\b) => "value"}, ~S(a\b: value))
      # in single quote string
      assert assert_identity_and_output(%{~S(!a\b) => "value"}, ~S('!a\b': value))
      # double quotes because of single quote
      assert assert_identity_and_output(%{~s(a'b\\c) => "value"}, ~s(a'b\\c: value))
      # double quotes because of tab
      assert assert_identity_and_output(%{~s(a\tb\\c) => "value"}, ~s(a\tb\\c: value))
    end

    test "tab" do
      # would be plain string without the tab
      assert assert_identity_and_output("a\tb", ~s(a\tb))
      # would be single quoted string without the tab
      assert assert_identity_and_output("!a\tb", ~s('!a\tb'))
    end

    test "tab in map key" do
      # would be plain string without the tab
      assert assert_identity_and_output(%{"a\tb" => "value"}, ~s(a\tb: value))
      # would be single quoted string without the tab
      assert assert_identity_and_output(%{"!a\tb" => "value"}, ~s('!a\tb': value))
    end

    test "integers" do
      assert_identity_and_output(1, "1")
    end

    test "floats" do
      assert_identity_and_output(1.2, "1.2")
      assert_identity_and_output(:nan, ".nan")
      assert_output(:inf, ".inf")
      assert_identity_and_output(:"+inf", ".inf")
      assert_identity_and_output(:"-inf", "-.inf")
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
      assert_identity_and_output(%{"a" => 1, "b" => 2}, "a: 1\nb: 2")
      assert_identity_and_output(%{"a b" => 1, "c d" => 2}, "a b: 1\nc d: 2")
      assert_identity_and_output(%{1 => 1, 2 => 2}, "1: 1\n2: 2")
      assert_identity_and_output(%{"a" => nil}, "a:")
    end

    test "maps with atoms: true" do
      assert_identity_and_output(%{a: 1}, ":a: 1", atoms: true)
      assert_identity_and_output(%{a: 1, b: 2}, ":a: 1\n:b: 2", atoms: true)
      assert_identity_and_output(%{a: nil}, ":a:", atoms: true)
      assert_identity_and_output(%{"a" => 1}, "a: 1", atoms: true)
    end

    test "maps with sort_maps: true" do
      assert MUT.to_s!(Map.new(1..33, &{&1, &1}), sort_maps: true) |> String.starts_with?("1: 1")
    end

    test "invalid map key (map as map key)" do
      assert_raise ArgumentError, fn ->
        MUT.to_s!(%{%{a: 1} => 2})
      end
    end

    test "maps - string values" do
      assert_identity_and_output(%{"a" => "a"}, "a: a")
      assert_identity_and_output(%{"a" => "true"}, "a: 'true'")
      assert_identity_and_output(%{"a" => "1"}, "a: '1'")
    end

    test "maps - atom value (lossy, convert to string)" do
      # cannot assert identity
      assert_output(%{"a" => :b}, "a: b")
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
      assert_identity_and_output([%{"a" => 1}, %{"b" => 2}], "- a: 1\n- b: 2")
      assert_identity_and_output([%{"a" => 1, "b" => 2}], "- a: 1\n  b: 2")
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

      assert_identity_and_output(%{"a" => [1, 2], "b" => [3, 4]}, expected)
    end

    test "nested: map / empty list" do
      assert_identity_and_output(%{"a" => []}, "a: []")
    end

    test "nested: map / empty map" do
      assert_identity_and_output(%{"a" => %{}}, "a: {}")
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
    @tag skip: "still buggy"
    test "multiline strings - starting with spaces" do
      assert_identity_and_output("\n   abc", "|-\n\n     abc")
      assert_identity_and_output("   abc\nabc", "|-\n     abc\n  abc")
    end

    test "multiline strings - base cases" do
      assert_identity_and_output("a\n b\nc", "|-\n  a\n   b\n  c")
      assert_identity_and_output("a\n b\nc\n ", "|-\n  a\n   b\n  c\n   ")
      assert_identity_and_output("a\n b\nc\n", "|\n  a\n   b\n  c")
    end

    test "multiline strings - with multiple consecutive newlines" do
      assert_identity_and_output("a\n\nb", "|-\n  a\n\n  b")
    end

    test "multiline strings - with multiple terminal newlines" do
      assert_identity_and_output("a\n\n", "|+\n  a\n")
      assert_identity_and_output("a\n b\nc\n\n", "|+\n  a\n   b\n  c\n")
      # just to be sure ... also check with 3 newlines
      assert_identity_and_output("a\n\n\n", "|+\n  a\n\n")
    end

    test "multiline strings - indented - base cases" do
      assert_identity_and_output(["a\n b\nc"], "- |-\n  a\n   b\n  c")
      assert_identity_and_output(["a\n b\nc\n "], "- |-\n  a\n   b\n  c\n   ")
      assert_identity_and_output(["a\n b\nc\n"], "- |\n  a\n   b\n  c")
    end

    test "multiline strings - indented - with multiple consecutive newlines" do
      assert_identity_and_output(["a\n\nb"], "- |-\n  a\n\n  b")
    end

    test "multiline strings - indented - with multiple trailing newlines" do
      assert_identity_and_output(["a\n\n"], "- |+\n  a\n")
      assert_identity_and_output(["a\n b\nc\n\n"], "- |+\n  a\n   b\n  c\n")
    end

    test "multiline strings - nested - inside vs last" do
      assert_identity_and_output(["a\n\n", "b\n\n"], "- |+\n  a\n\n- |+\n  b\n")

      # same with maps
      assert_identity_and_output(
        %{"k1" => "a\n\n", "k2" => "b\n\n"},
        "k1: |+\n  a\n\nk2: |+\n  b\n"
      )

      # just to be sure ... also check with 3 newlines
      assert_identity_and_output(["a\n\n\n"], "- |+\n  a\n\n")
      assert_identity_and_output(["a\n\n\n", "b"], "- |+\n  a\n\n\n- b")
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
        block: |
          void main() {
          \tprintf("Hello, world!\\n");
          }\
        """

      assert_identity_and_output(given, expected)
    end

    test "nested: list / multiline string" do
      assert_identity_and_output(["a\nb\n", "c"], "- |\n  a\n  b\n- c")

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

    test "tab(s) and newline(s) in the same string" do
      assert_identity_and_output("a\tb\nc", "|-\n  a\tb\n  c")
      # with extra whitespaces around the newline
      assert_identity_and_output("a\tb \n c", "|-\n  a\tb \n   c")
      # with backslash
      assert_identity_and_output(~s(a\tb\nc\\w), "|-\n  a\tb\n  c\\w")
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
