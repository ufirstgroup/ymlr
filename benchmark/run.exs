# Very rudimentary script for benchmarking.
#  This library is definitely not optimized for performance. But now at least
# we know if our changes make performance better or worse.

Mix.install([:benchee, :req, :jason, {:ymlr, path: ".."}, :benchee_markdown])

inputs = [
  {"Canada", "canada.json"},
  {"CITM Catalog", "citm_catalog.json"},
  {"Twitter", "twitter.json"}
]

inputs =
  for {label, filename} <- inputs, reduce: %{} do
    acc ->
      input_file = "./#{filename}"

      if !File.exists?(input_file) do
        content =
          "https://raw.githubusercontent.com/miloyip/nativejson-benchmark/master/data/#{filename}"
          |> Req.get!()
          |> Map.get(:body)

        File.write!(input_file, content)
      end

      input_content =
        input_file
        |> File.read!()
        |> Jason.decode!()

      Map.put(acc, label, input_content)
  end

Benchee.run(
  %{
    "Jason" => fn input -> Jason.encode!(input) end,
    "Ymlr" => fn input -> Ymlr.document!(input) end
  },
  inputs: inputs,
  formatters: [
    {Benchee.Formatters.Markdown, file: "../BENCHMARK.md"},
    Benchee.Formatters.Console
  ]
)
