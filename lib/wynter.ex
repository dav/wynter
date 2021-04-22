defmodule Wynter do
  @moduledoc """
  Documentation for `Wynter`.
  """

  @doc """
  Handle incoming slack message.
  """
  def handle_incoming_slack_message(message, _, _) do
    case message.text do
      "time" -> "The current time is #{DateTime.to_string(Calendar.DateTime.now! "America/Los_Angeles")}"
      _ -> "Did someone say '#{message.text}'?"
    end
  end
end
