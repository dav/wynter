defmodule Wynter do
  @moduledoc """
  Documentation for `Wynter`.
  """

  @doc """
  Handle incoming slack message.
  """
  def handle_incoming_slack_message(message, _, _) do
    case message.text do
      "powerball" ->
        current_powerball_status()

      "time" ->
        "The current time is #{DateTime.to_string(Calendar.DateTime.now!("America/Los_Angeles"))}"

      _ ->
        "Did someone say '#{message.text}'?"
    end
  end

  defp current_powerball_status do
    case Powerball.estimated_jackpot do
      {:ok, data} ->
        "The current #{data[:title]} is #{data[:field_prize_amount]} on #{to_usa_date_string(data[:field_next_draw_date])}"

      {:error, reason} ->
        "Failed to get Powerball data: #{reason}"
    end
  end

  def to_usa_date_string(date_string) do
    case DateTime.from_iso8601(date_string <> "Z") do
      {:ok, date_time, _} -> to_ny_time_string(date_time)
      _ -> date_string
    end
  end

  defp to_ny_time_string(date_time) do
    {:ok, ny_date_time} = DateTime.shift_zone(date_time, "America/New_York")
    ny_date_time
    |> Calendar.strftime("%a %b %d")
  end

end
