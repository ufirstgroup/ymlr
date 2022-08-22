defmodule Ymlr.EncoderTest do
  use ExUnit.Case
  doctest Ymlr.Encoder

  alias Ymlr.Encoder, as: MUT

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
      assert MUT.to_s!("[sequence_mapping") == ~S('[sequence_mapping')
      assert MUT.to_s!("]sequence_mapping") == ~S(']sequence_mapping')
      assert MUT.to_s!(",flow_collection_entry_separator") == ~S(',flow_collection_entry_separator')
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

    test "quoted strings - listy and mappy things" do
      # ... (prefer single quotes)
      assert MUT.to_s!("[]") == ~S('[]')
      assert MUT.to_s!(~S(["hello"])) == ~S('["hello"]')
      assert MUT.to_s!(~S(["he|\o"])) == ~S('["he|\o"]')
      assert MUT.to_s!("{}") == ~S('{}')
      assert MUT.to_s!("[{}]") == ~S('[{}]')
      # ... (use double quotes if string contains single quotes)
      assert MUT.to_s!(~S(["I don't know!\nRea|\y?"])) == ~S("[\"I don't know!\\nRea|\\y?\"]")
    end

    test "quoted strings - in map key" do
      assert MUT.to_s!(%{"!key" => "value"}) == ~s('!key': value)
      assert MUT.to_s!(%{"@key" => "value"}) == ~s('@key': value)
      assert MUT.to_s!(%{"true" => "value"}) == ~s('true': value)
      assert MUT.to_s!(%{"a\nb" => "value"}) == ~s("a\nb": value)
    end

    test "integers" do
      assert MUT.to_s!(1) == "1"
    end

    test "floats" do
      assert MUT.to_s!(1.2) == "1.2"
    end

    test "hex and oversize float" do
      assert MUT.to_s!("7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718") == "7e0981ff4c0daa3a47db5542ad5c167176145ef65f597a7f94ba2f5b41d35718"
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

    test "nested: list / list" do
      assert MUT.to_s!([[1, 2], [3, 4]]) == "- - 1\n  - 2\n- - 3\n  - 4"
    end

    test "nested: list / map" do
      assert MUT.to_s!([%{a: 1}, %{b: 2}]) == "- a: 1\n- b: 2"
      assert MUT.to_s!([%{a: 1, b: 2}]) == "- a: 1\n  b: 2"
    end

    test "nested: map / list" do
      expected = """
                 a:
                   - 1
                   - 2
                 b:
                   - 3
                   - 4
                 """ |> String.trim()

      assert MUT.to_s!(%{a: [1, 2], b: [3, 4]}) == expected
    end

    test "nested: map / empty list" do
      expected = """
                 a: []
                 """ |> String.trim()

      assert MUT.to_s!(%{a: []}) == expected
    end

    test "nested: map / empty map" do
      expected = """
                 a: {}
                 """ |> String.trim()

      assert MUT.to_s!(%{a: %{}}) == expected
    end

    test "nested: map / map" do
      expected = """
                 a:
                   b: 1
                   c:
                     d: 2
                 e:
                   f: 3
                   g: 4
                 """ |> String.trim()

      assert MUT.to_s!(%{a: %{b: 1, c: %{d: 2}}, e: %{f: 3, g: 4}}) == expected
    end

    # see https://yaml-multiline.info/
    test "multiline strings" do
      assert MUT.to_s!("hello\nworld") == "|-\nhello\nworld"
      assert MUT.to_s!("hello\nworld\n") == "|\nhello\nworld"
    end
    # see https://yaml.org/spec/1.2.2/#example-tabs-and-spaces
    test "multiline strings - mix spaces and tabs" do
      given = "void main() {\n\tprintf(\"Hello, world!\\n\");\n}\n"
      expected = """
                block: |
                  void main() {
                  \tprintf("Hello, world!\\n");
                  }
                """ |> String.trim()
      assert MUT.to_s!(%{block: given}) == expected
    end
    test "nested: list / multiline string" do
      assert MUT.to_s!(["a\nb\n", "c"]) == "- |\n  a\n  b\n- c"
    end
    test "nested: map / multiline string" do
      expected = """
                 a: |-
                   a1
                   a2
                 b: b1
                 c: |
                   c1
                   c2
                 d: d1
                 """ |> String.trim()

      assert MUT.to_s!(%{a: "a1\na2", b: "b1", c: "c1\nc2\n", d: "d1"}) == expected
    end

    test "date" do
      assert MUT.to_s!(~D[2016-05-24]) == "2016-05-24"
    end

    test "datetime" do
      assert MUT.to_s!(~U[2016-05-24 13:26:08Z])      == "2016-05-24T13:26:08Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.1Z])    == "2016-05-24T13:26:08.1Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.02Z])   == "2016-05-24T13:26:08.02Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.003Z])  == "2016-05-24T13:26:08.003Z"
      assert MUT.to_s!(~U[2016-05-24 13:26:08.0004Z]) == "2016-05-24T13:26:08.0004Z"
    end

  end

end
