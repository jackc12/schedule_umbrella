defmodule Schedule.Schema.Event do
  import Ecto.Changeset
  use Ecto.Schema

  schema "events" do
    field(:location, :string)
    field(:name, :string)
    field(:time, :utc_datetime)
    belongs_to(:owner, Schedule.Schema.User)

    many_to_many(:participants, Schedule.Schema.User,
      join_through: "participants",
      on_delete: :delete_all
    )

    timestamps()
  end

  def changeset(event, params \\ %{}) do
    event
    |> cast(params, [:location, :name, :owner_id, :time])
    |> validate_required([:name, :location, :owner_id, :time])
    |> validate_length(:name, min: 3)
    |> validate_length(:name, location: 3)
    |> assoc_constraint(:owner)
    |> foreign_key_constraint(:participants, name: :participants_event_id_fkey)
  end
end
