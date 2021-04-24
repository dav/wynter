defmodule Powerball do
  @moduledoc """
  `Powerball` provides access to Powerball lottery data`
  """

  # TODO: add access to these
  #  https://powerball.com/api/v1/draw-summary/powerball?_format=json
  #  https://powerball.com/api/v1/numbers/powerball/recent?_format=json

  @doc """
  Returns the current estimated jackpot as a map
  """
  def estimated_jackpot do
    case HTTPoison.get("https://powerball.com/api/v1/estimates/powerball?_format=json") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, process_response_body(body)}

      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, "Not found"}

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
