# Wynter

A Slack bot based on [BlakeWilliams/Elixir-Slack](https://github.com/BlakeWilliams/Elixir-Slack)
intended for use and development by a private Slack team I am on. This is my first Elixir project
so take that as a warning on quality of code and approaches.

## Installation

You could just install Elixir (and of course Erlang), however this project has
a `.tool-versions` file to lock it to certain language versions, so
ideally first ensure [ASDF](https://asdf-vm.com/#/) is installed.
This [guide](https://app.pluralsight.com/guides/installing-elixir-erlang-with-asdf) may be helpful. 

Use `asdf install`.

Run `mix deps.get` to install the project dependencies.

Copy `.env.example` to `.env` and make sure your bot's Slack API token is set in it.

So far this has been developed using a custom integration bot.
Check at the URL https://*YourSlackChannelName*.slack.com/apps/manage/custom-integrations

Until a better method is figured out, for interactive testing, it probably makes sense 
to have your own bot token and not use the "production" one, otherwise strange things may happen.
I believe this means creating a new integration yourself, either in the
target Slack team or in a different one.

## Running the bot

A `Makefile` exists to simplify remembering tasks by wrapping commands.

Running `make console` will start the app in interactive REPL mode (this wraps `iex -S mix`).

When the console is started, the `.iex.exs` script is executed which starts the bot.

```angular2html
% make console
iex -S mix
Erlang/OTP 23 [erts-11.2] [source] [64-bit] [smp:8:8] [ds:8:8:10] [async-threads:1] [hipe]

Interactive Elixir (1.11.4) - press Ctrl+C to exit (type h() ENTER for help)
Channel ids available:
    general: CZJQ045NX
    random: CBJ104691
    708parker: CBENWN7NH
    music: CC582JU6T
    achannelofnothing: CFRTRKVBM
    insider-trading: CGWJOP3RN
    nothing-to-see-here: C0459MTGS77
Use `send rtm, {:message, "Hello, world", "(a channel id)"}` to send a message.

handle_connect: Connected as wynter
Me info:
  created => 1618453163
  first_login => 1618455257
  id => U01V2GJQ2J4
  manual_presence => active
  name => wynter
  prefs => (is a map)
```

Hit control-C twice to exit.

## The original README contents

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `wynter` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wynter, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/wynter](https://hexdocs.pm/wynter).

