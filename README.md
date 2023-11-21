# Meetup

Scheduling app built using `phoenix 1.4.2`. Adheres to MVC Architecture. Click on [Model](https://github.com/jackc12/schedule_umbrella/tree/main/apps/schedule/lib/schedule), [View](https://github.com/jackc12/schedule_umbrella/tree/main/apps/schedule_web/lib/schedule_web/views), or [Controller](https://github.com/jackc12/schedule_umbrella/tree/main/apps/schedule_web/lib/schedule_web/controllers) to view the code for each individual component.

## Business rules
Anyone can view `Event`s and `User`s signed up. `User`s can create and sign up for events. `Event`s can only be deleted by `User`s that created them.

## Run in dev
[Install Docker](https://docs.docker.com/engine/install/)

Runs alpine linux docker image with codebase mounted as volume allowing hot reload.

Spawn alpine linux terminal:

`docker compose run -p 4000:4000 -it schedule_web`

Compile assets:

`cd assets && npm install && cd ..`

Create and migrate the database:

`cd ../schedule && mix do ecto.create, ecto.migrate && cd ../schedule_web`

Run app:

`mix phx.server`

Run app with interactive iex session:

`iex -S mix phx.server`


## Run in prod
[Install Docker](https://docs.docker.com/engine/install/)

Builds and runs release on alpine linux docker image.
`docker compose run -p 4001:4001 schedule_prod`

To stop production app:

`docker ps`

`docker rm -f <CONTAINER ID>`

Do this for postgres too.

It is generally bad practice to check in secrets into your version control system but I did for convenience.