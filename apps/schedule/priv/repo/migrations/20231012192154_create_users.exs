defmodule Schedule.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :username, :string
      add :email, :string
      add :hashed_password, :string
      timestamps()
    end

    # create unique_index(:users, [:username, :email])
    create unique_index(:users, [:username])
    create unique_index(:users, [:email])
  end
end
