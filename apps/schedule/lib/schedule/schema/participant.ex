defmodule Schedule.Schema.Participant do
  import Ecto.Changeset
  use Ecto.Schema
  @primary_key false

  schema "participants" do
    field(:user_id, :integer)
    field(:event_id, :integer)
  end

  def changeset(user_event, params) do
    user_event
    |> cast(params, [:user_id, :event_id])
    |> validate_required([:user_id, :event_id])
    |> unique_constraint(:user_id, name: :user_events_user_id_event_id_index)
    |> unique_constraint(:event_id, name: :participants_user_id_event_id_index)
    |> foreign_key_constraint(:user_id, name: :user_events_user_id_fkey)
    |> foreign_key_constraint(:event_id, name: :user_events_event_id_fkey)
  end
end
