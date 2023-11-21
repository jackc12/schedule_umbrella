defmodule ScheduleWeb.ControllerHelpers do
  use ScheduleWeb, :controller

  def put_link(conn, link), do: put_session(conn, :link, link)

  def get_link(conn) do
    link =
      case get_session(conn, :link) do
        "/" <> link -> "/" <> link
        _ -> Routes.home_path(conn, :index)
      end

    {delete_session(conn, :link), link}
  end
end
