defmodule ScheduleWeb.Router do
  use ScheduleWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug ScheduleWeb.Authenticator
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug ScheduleWeb.Authenticated
  end

  scope "/", ScheduleWeb do
    pipe_through :browser

    resources "/users", UserController, only: [:new, :create, :edit, :update]

    get "/", HomeController, :index

    get "/login", SessionController, :new
    post "/login", SessionController, :create
    delete "/login", SessionController, :delete

    get "/event/:id", EventController, :show
  end

  scope "/events", ScheduleWeb do
    pipe_through :browser
    pipe_through :authenticated

    resources "/", EventController, only: [:index, :new, :create, :delete] do
      post "/signup", SignupController, :create
      post "/cancel", SignupController, :delete
    end
  end
end
