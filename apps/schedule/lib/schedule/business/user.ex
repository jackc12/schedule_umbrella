defmodule Schedule.Business.User do
  alias Schedule.{Schema.User, Password}

  defmacro __using__(_opts) do
    quote do
      def edit_user(user_id) do
        user_id
        |> get_user()
        |> User.changeset_with_password()
      end

      def get_user(user_id), do: @repo.get!(User, user_id)

      def get_user_by_username_and_password(username, password) do
        with user when not is_nil(user) <- @repo.get_by(User, %{username: username}),
             true <- Password.verify_with_hash(password, user.hashed_password) do
          user
        else
          _ -> Password.dummy_verify()
        end
      end

      def insert_user(email, password, password_confirmation, username) do
        %User{}
        |> User.changeset_with_password(%{
          email: email,
          username: username,
          password: password,
          password_confirmation: password_confirmation
        })
        |> @repo.insert
      end

      def new_user, do: User.changeset_with_password(%User{})

      def update_user(email, password, password_confirmation, user_id, username) do
        user = get_user(user_id)
        user
        |> User.changeset_with_password(%{
          username: username,
          email: email,
          password: password,
          password_confirmation: password_confirmation
        })
        |> @repo.update
      end
    end
  end
end
