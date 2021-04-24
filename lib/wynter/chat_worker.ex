defmodule Wynter.ChatWorker do
  @moduledoc false

  use GenServer

  def start_link() do
    IO.inspect("Starting process ChatWorker.")
    GenServer.start_link(__MODULE__, :ok)
  end

  def child_spec(_) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      name: __MODULE__
    }
  end

  def init(:ok) do
    api_token = System.get_env("SLACK_API_TOKEN")
    IO.puts("WynterChat.Worker init")
    {:ok, rtm} = Slack.Bot.start_link(SlackRtm, [], api_token)

    channel_name = "nothing-to-see-here"
    channel_id = channel_id_for(channel_name, api_token)
    IO.puts("Channel id for #{channel_name}: #{channel_id}")

    {:ok, %{slack: rtm, channel_id: channel_id}}
  end

  # API

  def send_message(pid, message) do
    GenServer.cast(pid, {:send, message})
  end

  # Callbacks

  def handle_cast({:send, message}, state) do
    slack = state[:slack]
    send(slack, {:message, message, state[:channel_id]})
    {:noreply, state}
  end

  defp channel_id_for(name, api_token) do
    channel =
      Slack.Web.Conversations.list(%{token: api_token})
      |> Map.get("channels")
      |> Enum.find(fn channel -> channel["name"] == name end)

    channel["id"]
  end
end
