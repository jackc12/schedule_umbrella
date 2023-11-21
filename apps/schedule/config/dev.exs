use Mix.Config

config :schedule, Schedule.Repo,
  username: "postgres",
  password: "postgres",
  database: "schedule_dev",
  url: "postgresql://postgres:postgres@db/schedule_dev",
  port: "5432",
  pool: Ecto.Adapters.SQL.Sandbox
