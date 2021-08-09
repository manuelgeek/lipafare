# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :lipafare,
  ecto_repos: [Lipafare.Repo]

# Configures the endpoint
config :lipafare, LipafareWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "AbaB3OmgnDV6YAinDgtrKsKE2mCyOk4AGK8SNoUY9bcCvpcs/ogGHnoUSbd3r6Su",
  render_errors: [view: LipafareWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Lipafare.PubSub,
  live_view: [signing_salt: "1AWHwi+P"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
