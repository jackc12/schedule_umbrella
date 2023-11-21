use Mix.Config

# In this file, we keep production configuration that
# you'll likely want to automate and keep away from
# your version control system.
#
# You should document the content of this
# file or create a script for recreating it, since it's
# kept out of version control and might be hard to recover
# or recreate for your teammates (or yourself later on).

config :schedule, Schedule.Repo,
  username: "postgres",
  password: "postgres",
  database: "schedule_prod",
  size: 20, # The amount of database connections in the pool
  url: "postgresql://postgres:postgres@db/schedule_prod",
  port: "5432"
