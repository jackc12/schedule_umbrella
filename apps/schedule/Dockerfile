FROM elixir:1.7.4-alpine

RUN mix local.hex --force
RUN mix local.rebar --force

# Install deps
# WORKDIR /schedule_umbrella
# COPY /mix.exs mix.exs
# COPY /config/config.exs config/config.exs
# WORKDIR /schedule_umbrella/apps/schedule
# COPY /apps/schedule/mix.exs mix.exs
# COPY /apps/schedule/config config/
# RUN mix deps.get

# Copy code
# COPY /apps/schedule/lib lib
# Compile code
# RUN mix compile

# Copy db migrations
# COPY /apps/schedule/priv/repo/migrations /priv/repo/migrations

# Copy tests
# COPY /apps/schedule/test test

CMD mix ecto.create \
    && mix ecto.migrate \
    && sh
