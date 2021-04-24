chat_worker = Wynter.get_chat_worker
IO.puts "Use `GenServer.cast(chat_worker, {:send, \"hello world\"})` to send a message.\n"
