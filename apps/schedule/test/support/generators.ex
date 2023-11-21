defmodule Schedule.Test.Support.Generators do
  def user(),
    do: %{
      email: "email@email.com",
      password: "password",
      password_confirmation: "password",
      username: "username"
    }

  def event() do
    %{
      location: "location",
      name: "name",
      time:
        DateTime.utc_now()
        |> DateTime.truncate(:second)
    }
  end
end
