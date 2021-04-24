defmodule WynterTest do
  use ExUnit.Case
  doctest Wynter

  test "responds with time" do
    message = %{
      type: "message",
      channel: "test-channel",
      text: ".time"
    }

    slack = %{}
    state = %{state: "yup"}

    {status, response_string} = Wynter.handle_incoming_slack_message(message, slack, state)
    assert status == :respond
    assert String.contains?(response_string, "The current time is")
  end

  test "ignores unknown" do
    message = %{
      type: "message",
      channel: "test-channel",
      text: "something else"
    }

    slack = %{}
    state = %{state: "yup"}

    expected_response = {:ignored, message}
    response = Wynter.handle_incoming_slack_message(message, slack, state)
    assert response == expected_response
  end

  test "usa date" do
    assert Wynter.to_usa_date_string("2021-04-25T02:59:59") == "Sat Apr 24"
  end
end
