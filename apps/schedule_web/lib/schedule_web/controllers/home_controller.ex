defmodule ScheduleWeb.HomeController do
  use ScheduleWeb, :controller

  def index(conn, _params) do
    events = Schedule.list_events()

    render(conn, "index.html", events: events, current_user: conn.assigns.current_user)
  end
end
