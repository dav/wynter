defmodule PowerballClient do
  @moduledoc """
  `Powerball` provides access to Powerball lottery data`
  """

  # TODO: add access to these
  #  https://powerball.com/api/v1/draw-summary/powerball?_format=json
  #  https://powerball.com/api/v1/numbers/powerball/recent?_format=json

  use GenServer

  @impl true
  def init(endpoint_url) do
    {:ok, %{endpoint_url: endpoint_url}}
  end

  # API

  @doc """
  Returns the current estimated jackpot as a map
  """
  def get_estimated_jackpot(pid) do
    GenServer.call(pid, :estimated_jackpot)
  end

  # Callbacks

  @impl true
  def handle_call(:estimated_jackpot, _from, state) do
    {:reply, estimated_jackpot(state[:endpoint_url]), state}
  end

  defp estimated_jackpot(endpoint_url) do
    case HTTPoison.get("#{endpoint_url}/api/v1/estimates/powerball?_format=json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, process_response_body(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

      {:ok, %HTTPoison.Response{status_code: 500}} ->
        {:error, "Powerball Server 500 Error"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  defp process_response_body(body) do
    [first | _] =
      body
      |> Poison.decode!()

    first
    |> Enum.map(fn {k, v} -> {String.to_atom(k), v} end)
  end
end
