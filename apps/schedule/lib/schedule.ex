defmodule Schedule do
  import Ecto.Query
  @repo Schedule.Repo
  use Schedule.Business.User
  use Schedule.Business.Event
end
