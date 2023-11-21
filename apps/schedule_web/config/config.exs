# Since configuration is shared in umbrella projects, this file
# should only configure the :schedule_web application itself
# and only for organization purposes. All other config goes to
# the umbrella root.
use Mix.Config

# General application configuration
config :schedule_web,
  generators: [context_app: false]

# Configures the endpoint
config :schedule_web, ScheduleWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: ScheduleWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: ScheduleWeb.PubSub, adapter: Phoenix.PubSub.PG2]

config :gettext,
  default_locale: "en/us"

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
