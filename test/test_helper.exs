# if running with `test --no-start` alias, may need to explicitly start some processes
# Application.ensure_all_started(:elixir, :logger)

unless Mix.env() == :prod do
  Envy.auto_load()
end

ExUnit.start()
