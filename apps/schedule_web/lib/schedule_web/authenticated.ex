defmodule ScheduleWeb.Authenticated do
  import Plug.Conn
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]
  import Plug.Conn, only: [halt: 1]
  alias ScheduleWeb.Router.Helpers, as: Routes
  def init(opts), do: opts

  def call(%{assigns: %{current_user: nil}} = conn, _opts) do
    conn
    |> put_flash(:error, "You must be logged in")
    |> redirect(to: Routes.home_path(conn, :index))
    |> halt()
  end

  def call(conn, _opts), do: conn
end
