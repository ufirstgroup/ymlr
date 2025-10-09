defmodule YmlrTest do
  use ExUnit.Case
  doctest Ymlr

  alias Ymlr, as: MUT

  describe "document!/1" do
    test "KeywordMap preserves order" do
      assert MUT.document!(%MUT.KeywordMap{entries: [foo: 1, bar: 2, baz: 3]}) ==
               "---\nfoo: 1\nbar: 2\nbaz: 3\n"
    end
  end

  describe "document/2" do
    test "no comment" do
      assert MUT.document!({[], %{a: 1}}) == "---\na: 1\n"
    end

    test "k8s resource" do
      {:ok, input} = YamlElixir.read_from_file("test_support/fixtures/iam_policy.yaml")

      output = """
      ---
      apiVersion: iam.cnrm.cloud.google.com/v1beta1
      kind: IAMPolicy
      metadata:
        annotations:
          cnrm.cloud.google.com/deletion-policy: abandon
        name: sa-testing-cc-iampolicy
      spec:
        bindings:
          - members:
              - user:test@example.com
            role: roles/iam.serviceAccountUser
        resourceRef:
          apiVersion: iam.cnrm.cloud.google.com/v1beta1
          kind: IAMServiceAccount
          name: testing-cc
      """

      assert MUT.document!(input) == output
    end

    test "raises if not implemented" do
      assert_raise Protocol.UndefinedError,
                   ~r/protocol Ymlr.Encoder not implemented/,
                   fn -> MUT.document!({[], self()}) end

      assert_raise Protocol.UndefinedError,
                   ~r/protocol Ymlr.Encoder not implemented/,
                   fn -> MUT.documents!([{[], self()}]) end

      assert {:error, error} = MUT.document({[], self()})
      assert error =~ "protocol Ymlr.Encoder not implemented"
      assert {:error, error} = MUT.documents([{[], self()}])
      assert error =~ "protocol Ymlr.Encoder not implemented"
    end
  end
end
