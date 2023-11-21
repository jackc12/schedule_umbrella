defmodule Schedule.Schema.AttendanceParticipants do
  use Ecto.Schema

  embedded_schema do
    field(:is_signed_up, :boolean)
    field(:location, :string)
    field(:name, :string)
    field(:owner, :string)
    field(:participants, {:array, :string})
    field(:time, :utc_datetime)
  end

  def new(event, is_signed_up, participants) do
    __MODULE__
    |> struct(
      event
      |> Map.from_struct()
      |> Map.put(:is_signed_up, is_signed_up)
      |> Map.put(:participants, participants)
    )
  end
end
