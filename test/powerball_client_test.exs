defmodule PowerballClientTest do
  use ExUnit.Case, async: true

  doctest PowerballClient

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  describe "PowerballClient.get_estimated_jackpot/0 when remote request succeeds" do
    setup [:stub_network_request_for_success]

    test "it returns data from remote server", %{bypass: bypass, expected_data: expected_data} do
      {:ok, client} = GenServer.start_link(PowerballClient, endpoint_url(bypass.port))
      assert {:ok, expected_data} == PowerballClient.get_estimated_jackpot(client)
    end
  end

  describe "PowerballClient.get_estimated_jackpot/0 when remote request fails" do
    setup [:stub_network_request_for_fail_500]

    test "it returns data from remote server", %{bypass: bypass} do
      {:ok, client} = GenServer.start_link(PowerballClient, endpoint_url(bypass.port))
      assert {:error, "Powerball Server 500 Error"} == PowerballClient.get_estimated_jackpot(client)
    end
  end

  defp stub_network_request_for_success(context) do
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

    bypass = context[:bypass]
    Bypass.expect_once(bypass, "GET", "/api/v1/estimates/powerball", fn conn ->
      %{"_format" => "json"} = URI.decode_query(conn.query_string)
      Plug.Conn.resp(conn, 200, mock_response_json)
    end)

    [expected_data: expected_data]
  end

  defp stub_network_request_for_fail_500(context) do
    bypass = context[:bypass]
    Bypass.expect_once(bypass, "GET", "/api/v1/estimates/powerball", fn conn ->
      %{"_format" => "json"} = URI.decode_query(conn.query_string)
      Plug.Conn.resp(conn, 500, "{doesn't matter}")
    end)
  end

  defp endpoint_url(port), do: "http://localhost:#{port}"
end
