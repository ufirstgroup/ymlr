defmodule Ymlr.EncodeTest do
  use ExUnit.Case
  doctest Ymlr.Encode

  alias Ymlr.Encode, as: MUT

  describe "to_s!/1" do
    test "atoms" do
      assert MUT.to_s!(:a) == "a"
    end

    test "empty string" do
      assert MUT.to_s!("") == "''"
    end

    test "simple string" do
      assert MUT.to_s!("hello world") == "hello world"
    end

    # see http://blogs.perl.org/users/tinita/2018/03/strings-in-yaml---to-quote-or-not-to-quote.html

    test "quoted strings - avoid type confusion" do
      assert MUT.to_s!("yes") == ~S('yes')
      assert MUT.to_s!("no") == ~S('no')
      assert MUT.to_s!("true") == ~S('true')
      assert MUT.to_s!("false") == ~S('false')
      assert MUT.to_s!("True") == ~S('True')
      assert MUT.to_s!("False") == ~S('False')
      assert MUT.to_s!("1") == ~S('1')
      assert MUT.to_s!("1.2") == ~S('1.2')
      assert MUT.to_s!("-1") == ~S('-1')
      assert MUT.to_s!("1e3") == ~S('1e3')
      assert MUT.to_s!("0b1010") == ~S('0b1010')
      assert MUT.to_s!("0o777") == ~S('0o777')
      assert MUT.to_s!("0x1F") == ~S('0x1F')
      assert MUT.to_s!("null") == ~S('null')
    end

    test "quoted strings - avoid mapping confusion" do
      assert MUT.to_s!("hello: world") == ~S('hello: world')
    end

    test "quoted strings - avoid comment confusion" do
      assert MUT.to_s!("hello #world") == ~S('hello #world')
    end

    test "quoted strings - starts with special char" do
      assert MUT.to_s!("!tag") == ~S('!tag')
      assert MUT.to_s!("&anchor") == ~S('&anchor')
      assert MUT.to_s!("*alias") == ~S('*alias')
      assert MUT.to_s!("- block sequence enty") == ~S('- block sequence enty')
      assert MUT.to_s!(": block mapping entry") == ~S(': block mapping entry')
      assert MUT.to_s!("? explicit mapping key") == ~S('? explicit mapping key')
      assert MUT.to_s!("{flow_mapping") == ~S('{flow_mapping')
      assert MUT.to_s!("}flow_mapping") == ~S('}flow_mapping')
      assert MUT.to_s!(":{ block flow") == ~S(':{ block flow')
      assert MUT.to_s!("[sequence_mapping") == ~S('[sequence_mapping')
      assert MUT.to_s!("]sequence_mapping") == ~S(']sequence_mapping')

      assert MUT.to_s!(",flow_collection_entry_separator") ==
               ~S(',flow_collection_entry_separator')

      assert MUT.to_s!("#comment") == ~S('#comment')
      assert MUT.to_s!("|block_scalar") == ~S('|block_scalar')
      assert MUT.to_s!(">block_scalar") == ~S('>block_scalar')
      assert MUT.to_s!(~S("double_quote)) == ~S('"double_quote')
      assert MUT.to_s!(~S('single_quote)) == ~S("'single_quote")
      # see https://yaml.org/spec/1.2.2/#rule-c-reserved
      assert MUT.to_s!("@reserved") == ~S('@reserved')
      assert MUT.to_s!("`reserved") == ~S('`reserved')
    end

    test "quoted strings - ends with colon" do
      assert MUT.to_s!("some:entry:") == ~S('some:entry:')
    end

    test "quoted strings - escape seq forces double quotes (tab char)" do
      assert MUT.to_s!("a\tb") == ~s("a\tb")
      assert MUT.to_s!("!a\tb") == ~s("!a\tb")
    end

    test "quoted strings - listy and mappy things" do
      # ... (prefer single quotes)
      assert MUT.to_s!("[]") == ~S('[]')
      assert MUT.to_s!(~S(["hello"])) == ~S('["hello"]')
      assert MUT.to_s!(~S(["he|\o"])) == ~S('["he|\o"]')
      assert MUT.to_s!("{}") == ~S('{}')
      assert MUT.to_s!("[{}]") == ~S('[{}]')
      # ... (use double quotes if string contains single quotes)
      input = ~S(["I don't know!\nRea|\y?"])
      assert input |> MUT.to_s!() |> YamlElixir.read_from_string!() == input
    end

    test "quoted strings - in map key" do
      assert MUT.to_s!(%{"!key" => "value"}) == ~S('!key': value)
      assert MUT.to_s!(%{"@key" => "value"}) == ~S('@key': value)
      assert MUT.to_s!(%{"true" => "value"}) == ~S('true': value)
    end

    test "bitstrings" do
      assert_raise Protocol.UndefinedError, ~r/cannot encode a bitstring to YAML/, fn ->
        MUT.to_s!(<<3::4>>)
      end
    end

    @tag skip: "not sure about those => to be reviewed"
    # https://yaml.org/spec/1.2.2/#example-escaped-characters
    test "quoted strings - example-escaped-characters from 1.2.2 spec" do
      assert MUT.to_s!("Fun with \\") == ~S("Fun with \\")
      assert MUT.to_s!("\" \u0007 \b \u001b \f") == ~S("\" \a \b \e \f")
      # assert MUT.to_s!("\n \r \t \u000b \u0000") == ~S("\n \r \t \v \0")
      # or we use | when string contains newlines => rewrite the example to:
      assert MUT.to_s!("\r \t \u000b \u0000") == ~S("\r \t \v \0")
      assert MUT.to_s!("\u0020 \u00a0 \u0085 \u2028 \u2029") == ~S("\  \_ \N \L \P")
    end

    @tag skip: "not sure about those => review the spec"
    test "quoted strings - in map key (requires escape char)" do
      assert MUT.to_s!(%{"a\tb" => "value"}) == ~s("a\tb": value)
      assert MUT.to_s!(%{"a\rb" => "value"}) == ~s("a\rb": value)
    end

    test "newline in map key" do
      assert MUT.to_s!(%{"a\nb" => "value"}) == ~S("a\nb": value)
    end

    test "integers" do
      assert MUT.to_s!(1) == "1"
    end

    test "floats" do
      assert MUT.to_s!(1.2) == "1.2"
    end

    test "decimals" do
      assert MUT.to_s!(Decimal.new("1.2")) == "1.2"
    end

    test "hex and oversize float" do
      assert MUT.to_s!("7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718") ==
               "7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718"

      assert MUT.to_s!("1.7976931348623157e+309") == "1.7976931348623157e+309"
    end

    test "lists" do
      assert MUT.to_s!([]) == ""
      assert MUT.to_s!([1]) == "- 1"
      assert MUT.to_s!([""]) == ~s(- "")
      assert MUT.to_s!([1, nil, 2]) == "- 1\n-\n- 2"
    end

    test "empty map" do
      assert MUT.to_s!(%{}) == "{}"
    end

    test "maps" do
      assert MUT.to_s!(%{a: 1}) == "a: 1"
      assert MUT.to_s!(%{a: 1, b: 2}) == "a: 1\nb: 2"
      assert MUT.to_s!(%{"a" => 1, "b" => 2}) == "a: 1\nb: 2"
      assert MUT.to_s!(%{"a b" => 1, "c d" => 2}) == "a b: 1\nc d: 2"
      assert MUT.to_s!(%{1 => 1, 2 => 2}) == "1: 1\n2: 2"
      assert MUT.to_s!(%{a: nil}) == "a:"
    end

    test "maps with atoms: true" do
      assert MUT.to_s!(%{a: 1}, atoms: true) == ":a: 1"
      assert MUT.to_s!(%{a: 1, b: 2}, atoms: true) == ":a: 1\n:b: 2"
      assert MUT.to_s!(%{"a" => 1, "b" => 2}, atoms: true) == "a: 1\nb: 2"
      assert MUT.to_s!(%{"a b" => 1, "c d" => 2}, atoms: true) == "a b: 1\nc d: 2"
      assert MUT.to_s!(%{1 => 1, 2 => 2}, atoms: true) == "1: 1\n2: 2"
      assert MUT.to_s!(%{a: nil}, atoms: true) == ":a:"
    end

    test "maps with sort_maps: true" do
      assert MUT.to_s!(Map.new(1..33, &{&1, &1}), sort_maps: true) |> String.starts_with?("1: 1")
    end

    test "invalid map key" do
      assert_raise ArgumentError, fn ->
        MUT.to_s!(%{%{a: 1} => 2})
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
      assert MUT.to_s!([[1, 2], [3, 4]]) == "- - 1\n  - 2\n- - 3\n  - 4"
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
        MUT.to_s!(%{a: %{b: 1, c: %{d: 2}}, e: %{f: 3, g: 4}}) |> YamlElixir.read_from_string!()

      assert 2 == result["a"]["c"]["d"]
      assert 1 == result["a"]["b"]
      assert 3 == result["e"]["f"]
      assert 4 == result["e"]["g"]
    end

    # see https://yaml-multiline.info/
    test "multiline strings - level 0" do
      assert MUT.to_s!("a\n\nb")       == "|-\n  a\n\n  b"
      assert MUT.to_s!("a\n b\nc")     == "|-\n  a\n   b\n  c"      # "|..." would also work
      assert MUT.to_s!("a\n b\nc\n ")  == "|-\n  a\n   b\n  c\n   " # "|..." would also work
      assert MUT.to_s!("a\n b\nc\n")   == "|\n  a\n   b\n  c\n"
      assert MUT.to_s!("a\n b\nc\n\n") == "|+\n  a\n   b\n  c\n\n"
    end

    test "multiline strings - level 1" do
      assert MUT.to_s!(["a\n\nb"])       == "- |-\n  a\n\n  b"
      assert MUT.to_s!(["a\n b\nc"])     == "- |-\n  a\n   b\n  c"      # "|..." would only work if it was the last element in the document
      assert MUT.to_s!(["a\n b\nc\n "])  == "- |-\n  a\n   b\n  c\n   " # "|..." would only work if it was the last element in the document
      assert MUT.to_s!(["a\n b\nc\n"])   == "- |\n  a\n   b\n  c\n"
      assert MUT.to_s!(["a\n b\nc\n\n"]) == "- |+\n  a\n   b\n  c\n\n"


      assert MUT.to_s!(["a\n b\nc"]) == "- |-\n  a\n   b\n  c"

      # "- |\n  a\n   b\n  c" would only work if it was the last element in the document
      assert MUT.to_s!(["a\n b\nc\n"]) == "- |\n  a\n   b\n  c\n"
      assert MUT.to_s!(["a\n b\nc\n\n"]) == "- |+\n  a\n   b\n  c\n\n"
    end

    @tag skip: "not implemented yet"
    test "multiline strings - mutliple terminal newlines" do
      # if we join the strings in the list with \n we end up with an extra newline in between
      # i.e.                                  "- |+\n  a\n\n\n- |+\n  b\n\n"
      assert MUT.to_s!(["a\n\n", "b\n\n"]) == "- |+\n  a\n\n- |+\n  b\n\n"
      assert MUT.to_s!(%{k1: "a\n\n", k2: "b\n\n"}) == "k1: |+\n  a\n\nk2: |+\n  b\n\n"

      # just to be sure ... also check with 3 newlines
      assert MUT.to_s!(["a", "b\n\n\n", "c"]) == "- a\n- |+\n  b\n\n\n- c"

      # and what about nested lists?
      given = [
        ["a\n\n", "b\n\n"],
        ["c\n\n", "d\n\n"],
      ]
      expected = """
      - - |+
          a

        - |+
          b

      - - |+
          c

        - |+
          d

      """
      assert MUT.to_s!(given) == expected
    end

    test "newline only string - encoding" do
      given = "\n"
      encoded = MUT.to_s!(given)

      assert given == YamlElixir.read_from_string!(encoded)
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

      assert encoded == expected
      assert YamlElixir.read_from_string!(encoded) == given
    end

    @tag skip: "not working yet"
    test "nested: list / multiline string" do
      given = [
        "a",
        "b\nc",   "d\ne\n",   "f\ng\n\n",
        "h\n\ni", "j\n\nk\n", "l\n\nm\n\n",
        "bo\np ", "q\nr\n ",  "s\nt\n\n ",
        "u",
      ]
      encoded = MUT.to_s!(given)

      assert YamlElixir.read_from_string!(encoded) == given
    end

    @tag skip: "not working yet"
    test "nested: map / multiline string" do
      given = %{
        "a" => "a1",
        "b" => "b1\nb2",
        "c" => "c1\nc2\n",
        "d" => "d1\nd2\n\n",
        "e" => "e1\n\ne2",
        "f" => "f1\n\nf2\n",
        "g" => "g1\n\ng2\n\n",
        "h" => "",
        "i" => "\n",
        "j" => "\n\n",
      }
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
