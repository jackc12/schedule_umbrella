defmodule Schedule.Schema.Attendance do
  use Ecto.Schema

  embedded_schema do
    field(:is_signed_up, :boolean)
    field(:location, :string)
    field(:name, :string)
    field(:time, :utc_datetime)
  end

  def new(event, is_signed_up) do
    __MODULE__
    |> struct(
      event
      |> Map.from_struct()
      |> Map.put(:is_signed_up, is_signed_up)
    )
  end
end
