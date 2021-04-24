import Config

config :elixir, :time_zone_database, Tzdata.TimeZoneDatabase

config :logger, level: :debug

config :wynter, Wynter.Scheduler,
  jobs: [
    {"08 07 * * *", {Wynter.Announcer, :announce_powerball_status, []}}
  ]
