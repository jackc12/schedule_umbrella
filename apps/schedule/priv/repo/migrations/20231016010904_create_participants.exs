defmodule Schedule.Repo.Migrations.CreateUserEvents do
  use Ecto.Migration

  def change do
    create table(:participants, primary_key: false) do
      add :user_id, references(:users, primary_key: true)
      add :event_id, references(:events, primary_key: true)
    end

    create unique_index(:participants, [:user_id, :event_id])
  end
end
