defmodule Wynter do
  @moduledoc """
  Documentation for `Wynter`.
  """

  @doc """
  Handle incoming slack message.
  """
  def handle_incoming_slack_message(message, _, _) do
    case String.starts_with?(message.text, ".") do
      true -> String.slice(message.text, 1..-1) |> handle_command()
      false -> {:ignored, message}
    end
  end

  defp handle_command(command) do
    case command do
      "powerball" ->
        {:respond, current_powerball_status()}

      "time" ->
        {:respond,
         "The current time is #{DateTime.to_string(Calendar.DateTime.now!("America/Los_Angeles"))}"}

      _ ->
        {:unrecognized, command}
    end
  end

  def get_chat_worker do
    child =
      Supervisor.which_children(Wynter.Supervisor)
      |> Enum.find(fn {mod, _, :worker, _} -> mod == Wynter.ChatWorker end)

    {_, chat_worker, _, _} = child
    chat_worker
  end

  def current_powerball_status do
    case Powerball.estimated_jackpot() do
      {:ok, data} ->
        "The current #{data[:title]} is #{data[:field_prize_amount]} on #{
          to_usa_date_string(data[:field_next_draw_date])
        }"

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
