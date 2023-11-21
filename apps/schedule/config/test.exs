use Mix.Config

config :schedule, Schedule.Repo,
  username: "postgres",
  password: "postgres",
  database: "schedule_test",
  url: "postgresql://postgres:postgres@db/schedule_test",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox

config :logger, level: :info
