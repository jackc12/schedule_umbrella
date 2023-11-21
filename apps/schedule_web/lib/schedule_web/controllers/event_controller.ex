defmodule ScheduleWeb.EventController do
  use ScheduleWeb, :controller
  alias ScheduleWeb.ControllerHelpers

  def index(conn, _params) do
    user_id = conn.assigns.current_user.id
    events = Schedule.get_event_attendance(user_id)
    conn = ControllerHelpers.put_link(conn, Routes.event_path(conn, :index))

    render(conn, "index.html", events: events)
  end

  def show(conn, %{"id" => event_id}) do
    {conn, event, is_owner} =
      case conn.assigns.current_user do
        %{id: user_id} ->
          IO.puts("\n\nCARTI\n\n")
          event_attendance_participants = %{owner: %{id: owner_id}} =
            Schedule.get_event_attendance_and_participants(event_id, user_id)
          {
            ControllerHelpers.put_link(conn, Routes.event_path(conn, :show, event_id)),
            event_attendance_participants,
            owner_id == user_id
          }

        _ ->
          IO.puts("\n\nTHUGGER\n\n")
          {conn, Schedule.get_event_participants(event_id), false}
      end
    render(conn, "show.html", current_user: conn.assigns.current_user, event: event, is_owner: is_owner)
  end

  def new(conn, _params) do
    event = Schedule.new_event()
    render(conn, "new.html", event: event, action: Routes.event_path(conn, :create))
  end

  def create(conn, %{"event" => %{"location" => location, "name" => name, "time" => time}}) do
    owner_id = conn.assigns.current_user.id
    case Schedule.insert_event(location, name, owner_id, time) do
      {:ok, event} -> redirect(conn, to: Routes.event_path(conn, :show, event))
      {:error, event} -> render(conn, "new.html", event: event)
    end
  end

  def delete(conn, %{"id" => event_id}) do
    user_id = conn.assigns.current_user.id
    case Schedule.delete_event(event_id, user_id) do
      {:ok, _event} -> (
        events = Schedule.get_event_attendance(user_id)
        conn
        |> put_flash(:info, "Event deleted")
        |> redirect(to: Routes.event_path(conn, :index, events))
      )
      {:error, _error} -> (
        event = Schedule.get_event_attendance_and_participants(event_id, user_id)
        conn
        |> put_flash(:error, "Delete failed")
        |> redirect(to: Routes.event_path(conn, :show, event))
      )
    end
  end
end
