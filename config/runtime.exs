# NOTE: Since config/releases.exs and config/runtime.exs are also used in releases, where Mix is not available,
# you cannot call any Mix functions in them. Instead functions from the Config module should be used.
# Luckily (since v1.11) they include the new config_env/0 and config_target/0 functions to get the
# configuration environment and target respectively.

IO.puts("In config/runtime.exs")
