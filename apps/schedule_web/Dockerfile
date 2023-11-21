FROM schedule:latest

# Resolves inotify-tools error
RUN apk add inotify-tools

# Compile assets
RUN apk update && apk add npm --no-cache
# bash is required to run release
# WORKDIR /schedule_umbrella/apps/schedule_web/assets
# RUN npm install


# Install deps
# WORKDIR /schedule_umbrella
# COPY /mix.exs mix.exs
# COPY /config/config.exs config/config.exs
# WORKDIR /schedule_umbrella/apps/schedule_web
# COPY /apps/schedule_web/mix.exs mix.exs
# COPY /apps/schedule_web/config config/
# RUN mix deps.get

# Compile code
# COPY /apps/schedule_web/lib lib
# RUN mix compile

CMD sh