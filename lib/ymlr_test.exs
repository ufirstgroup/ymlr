defmodule YmlrTest do
	use ExUnit.Case
	doctest Ymlr

	alias Ymlr, as: MUT

	describe "document/2" do

		test "with comment" do
			assert MUT.document!({"comment", %{a: 1}}) == "---\n# comment\na: 1\n"
		end

		test "with comments" do
			assert MUT.document!({["line 1", "line 2"], %{a: 1}}) == "---\n# line 1\n# line 2\na: 1\n"
		end

		test "no comment" do
			assert MUT.document!({[], %{a: 1}}) == "---\na: 1\n"
			assert MUT.document!(%{a: 1}) == "---\na: 1\n"
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
	end

	describe "documents/1" do

		test "single" do
			assert MUT.documents!([%{a: 1}]) == """
			---
			a: 1
			"""
		end

		test "multiple" do
			assert MUT.documents!([%{a: 1}, %{b: 2}]) == """
			---
			a: 1

			---
			b: 2
			"""
		end
	end

end
