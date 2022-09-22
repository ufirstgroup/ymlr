defmodule YmlrTest do
  use ExUnit.Case
  doctest Ymlr

  alias Ymlr, as: MUT

  describe "document/2" do
    test "no comment" do
      assert MUT.document!({[], %{a: 1}}) == "---\na: 1\n"
    end

    test "k8s resource" do
      expected_output = """
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

      input = YamlElixir.read_from_file!("test_support/fixtures/iam_policy.yaml")
      output = MUT.document!(input)

      assert output == expected_output
      assert YamlElixir.read_from_string!(output) |> MUT.document!() == output
    end

    test "k8s resource with atoms options" do
      expected_output = """
      ---
      :apiVersion: iam.cnrm.cloud.google.com/v1beta1
      :kind: :IAMPolicy
      :metadata:
        :annotations:
          :cnrm.cloud.google.com/deletion-policy: abandon
        :name: sa-testing-cc-iampolicy
      :spec:
        :bindings:
          - :members:
              - user:test@example.com
            :role: roles/iam.serviceAccountUser
        :resourceRef:
          :apiVersion: iam.cnrm.cloud.google.com/v1beta1
          :kind: :IAMServiceAccount
          :name: testing-cc
      """

      input = YamlElixir.read_from_file!("test_support/fixtures/iam_policy_atoms.yaml", atoms: true)
      output = MUT.document!(input, atoms: true)

      assert output == expected_output
      assert YamlElixir.read_from_string!(output, atoms: true) |> MUT.document!(atoms: true) == output
    end
  end
end
