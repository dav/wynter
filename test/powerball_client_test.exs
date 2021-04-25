defmodule PowerballClientTest do
  use ExUnit.Case, async: true

  doctest PowerballClient

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  test "estimated_jackpot with successful GET", %{bypass: bypass}  do
    mock_response_data = [
      %{
        field_next_draw_date: "2021-04-29T02:59:59",
        field_prize_amount: "$116 Million",
        field_prize_amount_cash: "$80.6 Million",
        title: "Powerball Prize Estimate"
      }
    ]
    mock_response_json = Poison.encode!(mock_response_data)
    expected_data = [
      field_next_draw_date: "2021-04-29T02:59:59",
      field_prize_amount: "$116 Million",
      field_prize_amount_cash: "$80.6 Million",
      title: "Powerball Prize Estimate"
    ]

    Bypass.expect_once(bypass, "GET", "/api/v1/estimates/powerball", fn conn ->
      %{"_format" => "json"} = URI.decode_query(conn.query_string)
      Plug.Conn.resp(conn, 200, mock_response_json)
    end)

    {:ok, client} = GenServer.start_link(PowerballClient, endpoint_url(bypass.port))
    assert {:ok, expected_data} == PowerballClient.get_estimated_jackpot(client)
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
