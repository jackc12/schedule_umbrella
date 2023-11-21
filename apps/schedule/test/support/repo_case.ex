defmodule Schedule.Test.Support.RepoCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      alias Schedule.RepoCase

      import Ecto
      import Ecto.Query
      import Schedule.Test.Support.RepoCase
      alias Schedule.{Repo, Schema.User, Schema.Event, Schema.Participant}
      import Schedule.Test.Support.Generators
      doctest Schedule
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Schedule.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Schedule.Repo, {:shared, self()})
    end

    :ok
  end
end
