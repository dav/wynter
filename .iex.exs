unless Mix.env == :prod do
  Envy.auto_load
end

{:ok, rtm} = Slack.Bot.start_link(SlackRtm, [], System.get_env("SLACK_API_TOKEN"))
channels = Slack.Web.Conversations.list(%{token: System.get_env("SLACK_API_TOKEN")}) |> Map.get("channels")
IO.puts "Channel ids available:"
Enum.map(channels, fn (channel) -> IO.puts("  #{channel["name"]}: #{channel["id"]}") end)
IO.puts "Use `send rtm, {:message, \"Hello, world\", \"(a channel id)\"}` to send a message.\n"