defmodule SlackRtm do
  use Slack

  def handle_connect(slack, state) do
    dump_slack_info(slack)

    {:ok, state}
  end

  def handle_event(message = %{type: "message"}, slack, state) do
    print_named_map("Message", message)
    response = Wynter.handle_incoming_slack_message(message, slack, state)
    send_message(response, message.channel, slack)

    {:ok, state}
  end
  def handle_event(_, _, state), do: {:ok, state}

  def handle_info({:message, text, channel}, slack, state) do
    IO.puts "handle_info: Sending your message, captain!"

    send_message(text, channel, slack)

    {:ok, state}
  end
  def handle_info(_, _, state), do: {:ok, state}

  defp print_named_map(name, map) do
    IO.puts "#{name}:"

    for {key, value} <- map do
      if is_map(value) do
        IO.puts "  #{key} => (is a map)"
      else
        if is_list(value) do
          IO.puts "  #{key} => (is a list)"
        else
          IO.puts "  #{key} => #{value}"
        end
      end
    end
  end

  defp dump_slack_info(slack) do
    IO.puts "handle_connect: Connected as #{slack.me.name}"

    IO.puts "Me info:"
    for {key, value} <- slack.me do
      if is_map(value) do
        IO.puts "  #{key} => (is a map)"
      else
        IO.puts "  #{key} => #{value}"
      end
    end

    token = System.get_env("SLACK_API_TOKEN")
    slack
    |> Map.put(:channels, Slack.Web.Conversations.list(%{token: token}) |> Map.get("channels"))
    |> Map.put(:ims, Slack.Web.Im.list(%{token: token}) |> Map.get("ims"))
    |> Map.put(:users, Slack.Web.Users.list(%{token: token}) |> Map.get("members"))

    IO.puts "Channels:"
    for {key, value} <- slack.channels do
      IO.puts "  #{key} => #{value}"
    end

    IO.puts "Users:"
    for {key, value} <- slack.users do
      IO.puts "  #{key} => #{value}"
    end

    IO.puts "IMs:"
    for {key, value} <- slack.ims do
      IO.puts "  #{key} => #{value}"
    end
  end

end