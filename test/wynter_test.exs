defmodule WynterTest do
  use ExUnit.Case
  doctest Wynter

  test "responds with time" do
    message = %{
      type: "message",
      channel: "test-channel",
      text: "time"
    }

    slack = %{}
    state = %{state: "yup"}

    response = Wynter.handle_incoming_slack_message(message, slack, state)
    assert String.contains?(response, "The current time is")
  end

  test "echoes" do
    message = %{
      type: "message",
      channel: "test-channel",
      text: "something else"
    }

    slack = %{}
    state = %{state: "yup"}

    expected_response = "Did someone say '#{message.text}'?"
    response = Wynter.handle_incoming_slack_message(message, slack, state)
    assert response == expected_response
  end

  test "usa date" do
    assert Wynter.to_usa_date_string("2021-04-25T02:59:59") == "Sat Apr 24"
  end
end
