defmodule Wynter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    IO.puts("Starting #{__MODULE__}")

    unless Mix.env() == :prod do
      Envy.auto_load()
    end

    children =
      case Mix.env() do
        :test ->
          []

        _ ->
          [
            Wynter.Scheduler,
            Wynter.ChatWorker
            # Starts a worker by calling: Wynter.Worker.start_link(arg)
            # {Wynter.Worker, arg}
          ]
      end

    IO.inspect(Mix.env())

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Wynter.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
