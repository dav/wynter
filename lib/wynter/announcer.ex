defmodule Wynter.Announcer do
  @moduledoc false

  def announce_powerball_status() do
    chat_worker = Wynter.get_chat_worker()
    status = Wynter.current_powerball_status()
    GenServer.cast(chat_worker, {:send, status})
  end
end
