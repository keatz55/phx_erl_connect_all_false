# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

# Configures the endpoint
config :app1, App1Web.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "v44u1cHSnBj7a89ubqErpZ4vDW9c/u3FQiZm32diB4MKdzPRpvWSUF96lCEB4tgJ",
  render_errors: [view: App1Web.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: App1.PubSub,
  live_view: [signing_salt: "j8GeqAaT"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"