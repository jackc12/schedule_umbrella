defmodule ScheduleWeb.GlobalHelpers do
  def formatted_datetime(datetime) do
    datetime
    |> Timex.format!("{YYYY}-{0M}-{0D} {h12}:{m}{am}")
  end
end
