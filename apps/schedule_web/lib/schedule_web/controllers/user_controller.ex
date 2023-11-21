defmodule ScheduleWeb.UserController do
  use ScheduleWeb, :controller
  plug :prevent_unauthorized_access when action in [:edit, :update]

  def new(conn, _params) do
    user = Schedule.new_user()
    render(conn, "new.html", user: user)
  end

  def create(conn, %{
        "user" => %{
          "email" => email,
          "password" => password,
          "password_confirmation" => password_confirmation,
          "username" => username
        }
      }) do
    case Schedule.insert_user(email, password, password_confirmation, username) do
      {:ok, _user} -> redirect(conn, to: Routes.home_path(conn, :index))
      {:error, user} -> render(conn, "new.html", user: user)
    end
  end

  def edit(conn, %{"id" => id}) do
    user = Schedule.edit_user(id)
    render(conn, "edit.html", user: user)
  end

  def update(conn, %{
        "id" => user_id,
        "user" => %{
          "username" => username,
          "email" => email,
          "password" => password,
          "password_confirmation" => password_confirmation
        }
      }) do

    case Schedule.update_user(email, password, password_confirmation, user_id, username) do
      {:ok, user} -> redirect(conn, to: Routes.user_path(conn, :edit, user))
      {:error, user} -> render(conn, "edit.html", user: user)
    end
  end

  defp prevent_unauthorized_access(conn, _opts) do
    current_user = Map.get(conn.assigns, :current_user)

    requested_user_id =
      conn.params
      |> Map.get("id")
      |> String.to_integer()

    if current_user == nil || current_user.id != requested_user_id do
      conn
      |> put_flash(:error, "You must be logged in")
      |> redirect(to: Routes.home_path(conn, :index))
      |> halt()
    else
      conn
    end
  end
end
