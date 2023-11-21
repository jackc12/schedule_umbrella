defmodule ScheduleWeb.SignupController do
  use ScheduleWeb, :controller
  alias ScheduleWeb.ControllerHelpers

  def create(conn, %{"event_id" => event_id}) do
    user_id = conn.assigns.current_user.id
    {conn, link} = ControllerHelpers.get_link(conn)

    case Schedule.signup(user_id, event_id) do
      {:ok, _signed_up_user} ->
        conn
        |> put_flash(:info, "Signed up")
        |> redirect(to: link)

      {:error, _changeset} ->
        conn
        |> put_flash(:error, "Error signing up")
        |> redirect(to: link)
        |> halt()
    end
  end

  def delete(conn, %{"event_id" => event_id}) do
    user_id = conn.assigns.current_user.id
    {conn, link} = ControllerHelpers.get_link(conn)
    {event_id, ""} = Integer.parse(event_id)

    case Schedule.cancel(user_id, event_id) do
      {1, nil} ->
        conn
        |> put_flash(:info, "Cancelled")
        |> redirect(to: link)

      {0, nil} ->
        conn
        |> put_flash(:error, "Error cancelling")
        |> redirect(to: link)
        |> halt()
    end
  end
end
