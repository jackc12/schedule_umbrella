defmodule Schedule.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events) do
      add :location, :string
      add :name, :string
      add :time, :utc_datetime
      add :owner_id, references(:users)
      timestamps()
    end
  end
end
