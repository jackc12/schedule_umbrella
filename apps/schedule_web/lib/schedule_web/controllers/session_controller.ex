defmodule ScheduleWeb.SessionController do
  use ScheduleWeb, :controller

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"user" => %{"username" => username, "password" => password}}) do
    case Schedule.get_user_by_username_and_password(username, password) do
      %Schedule.Schema.User{} = user ->
        conn
        |> put_session(:user_id, user.id)
        |> put_flash(:info, "Successfully logged in")
        |> redirect(to: Routes.user_path(conn, :edit, user))

      _ ->
        conn
        |> put_flash(:error, "That username and password combination cannnot be found")
        |> render("new.html")
    end

    # implement
  end

  def delete(conn, _params) do
    conn
    |> clear_session()
    |> configure_session(drop: true)
    |> redirect(to: Routes.home_path(conn, :index))
  end
end
