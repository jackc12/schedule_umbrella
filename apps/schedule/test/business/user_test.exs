defmodule Schedule.Test.Business.UserTest do
  use Schedule.Test.Support.RepoCase
  import Pbkdf2

  describe "`Schedule.edit_user/1`" do
    setup do
      user_params = user()
      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()
      %{user_id: user_id}
    end

    test "returns `User` `changeset` with blank `password` and `password_confirmation`", %{user_id: user_id} do
      assert %{errors: edit_user_changeset_errors} = Schedule.edit_user(user_id)
      assert edit_user_changeset_errors[:password] == {"can't be blank", [validation: :required]}
      assert edit_user_changeset_errors[:password_confirmation] == {"can't be blank", [validation: :required]}
    end
  end

  describe "`Schedule.get_user/1`" do
    setup do
      user_params = user()

      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()

      %User{}
      |> User.changeset_with_password(%{
        user_params
        | email: "different_email@email.com",
          username: "different_username"
      })
      |> Repo.insert()

      user_params
      |> Map.put(:user_id, user_id)
    end

    test "returns correct `User`", %{
      email: email,
      username: username,
      user_id: user_id
    } do
      retrieved_user = Schedule.get_user(user_id)
      assert retrieved_user.email == email
      assert retrieved_user.password == nil
      assert retrieved_user.username == username
      assert retrieved_user.id == user_id
    end
  end

  describe "`Schedule.get_user_by_username_and_password/2`" do
    setup do
      user_params = user()

      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()

      %User{}
      |> User.changeset_with_password(%{
        user_params
        | email: "different_email@email.com",
          username: "different_username"
      })
      |> Repo.insert()

      user_params
      |> Map.put(:user_id, user_id)
    end

    test "returns `User` with correct `username` and `password`", %{
      email: email,
      password: password,
      username: username,
      user_id: user_id
    } do
      retrieved_user = Schedule.get_user_by_username_and_password(username, password)
      assert retrieved_user.email == email
      assert retrieved_user.password == nil
      assert retrieved_user.username == username
      assert retrieved_user.id == user_id
    end

    test "does not return `User` with incorrect `username`", %{password: password} do
      assert Schedule.get_user_by_username_and_password("incorrect username", password) == false
    end

    test "does not return `User` with incorrect `password`", %{username: username} do
      assert Schedule.get_user_by_username_and_password(username, "incorrect password") == false
    end

    test "does not return `User` with incorrect `username` and `password`" do
      assert Schedule.get_user_by_username_and_password("incorrect username", "incorrect password") == false
    end
  end

  describe "`Schedule.insert_user/1`" do
    setup do
      user()
    end

    test "adds a `User` to the database", %{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      username: username
    } do
      count_query = from(u in User, select: count(u.id))
      before_count = Repo.one(count_query)
      {:ok, _user} = Schedule.insert_user(email, password, password_confirmation, username)
      assert Repo.one(count_query) == before_count + 1
    end

    test "adds a `User` with the correct attributes", %{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      username: username
    } do
      {:ok, user} = Schedule.insert_user(email, password, password_confirmation, username)
      assert user.email == email
      assert user.password == password
      assert user.username == username
    end

    test "returns appropriate `error` if `email` has been taken", %{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      username: username
    } do
      assert {:ok, _user} = Schedule.insert_user(email, password, password_confirmation, username)

      assert {:error,
              %{
                errors: [
                  email:
                    {"has already been taken",
                     [constraint: :unique, constraint_name: "users_email_index"]}
                ]
              } = _changeset} =
               Schedule.insert_user(email, password, password, "different username")
    end

    test "returns appropriate `error` if `password`s don't match", %{
      email: email,
      password: password,
      username: username
    } do
      assert {:error, _changeset} =
               Schedule.insert_user(email, password, "passwords don't match", username)
    end

    test "returns appropriate `error` if `username` has been taken", %{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      username: username
    } do
      assert {:ok, _user} = Schedule.insert_user(email, password, password, username)

      assert {:error, _changeset} =
               Schedule.insert_user(
                 "different_email@email.com",
                 password,
                 password_confirmation,
                 username
               )
    end
  end

  describe "`Schedule.new_user/0`" do
    test "returns `User` `changeset` with blank `email`, `username`, `hashed_password` password` and `password_confirmation`" do
      assert %{errors: new_user_changeset_errors} = Schedule.new_user()
      assert new_user_changeset_errors[:email] == {"can't be blank", [validation: :required]}
      assert new_user_changeset_errors[:username] == {"can't be blank", [validation: :required]}
      assert new_user_changeset_errors[:hashed_password] == {"can't be blank", [validation: :required]}
      assert new_user_changeset_errors[:password] == {"can't be blank", [validation: :required]}
      assert new_user_changeset_errors[:password_confirmation] == {"can't be blank", [validation: :required]}
    end
  end

  describe "`Schedule.update_user/5`" do
    setup do
      user_params = user()

      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()

      %User{}
      |> User.changeset_with_password(%{
        user_params
        | email: "different_email@email.com",
          username: "different_username"
      })
      |> Repo.insert()

      user_params
      |> Map.put(:user_id, user_id)
    end

    test "updates `User` `email`", %{
      password: password,
      password_confirmation: password_confirmation,
      username: username,
      user_id: user_id
    } do
      updated_email = "updated_email@email.com"
      assert {:ok, %{email: updated_email, id: user_id, password: password, username: username}} = Schedule.update_user(updated_email, password, password_confirmation, user_id, username)

      retrieved_updated_user = Repo.get(User, user_id)

      assert retrieved_updated_user.email == updated_email
      assert retrieved_updated_user.password == nil
      assert retrieved_updated_user.username == username
      assert retrieved_updated_user.id == user_id
    end

    test "updates `User` `password`", %{
      email: email,
      username: username,
      user_id: user_id
    } do
      updated_password = "updated password"
      updated_password_confirmation = updated_password

      assert {:ok, %{email: updated_email, id: user_id, password: updated_password, username: username}} = Schedule.update_user(email, updated_password, updated_password_confirmation, user_id, username)

      retrieved_updated_user = Repo.get(User, user_id)

      assert retrieved_updated_user.email == email
      assert retrieved_updated_user.password == nil
      assert retrieved_updated_user.username == username
      assert retrieved_updated_user.id == user_id

      assert verify_pass(updated_password, retrieved_updated_user.hashed_password)
    end

    test "updates `User` `username`", %{
      email: email,
      password: password,
      password_confirmation: password_confirmation,
      user_id: user_id
    } do
      updated_username = "updated username"

      assert {:ok, %{email: updated_email, id: user_id, password: password, username: username}} = Schedule.update_user(email, password, password_confirmation, user_id, updated_username)

      retrieved_updated_user = Repo.get(User, user_id)

      assert retrieved_updated_user.email == email
      assert retrieved_updated_user.password == nil
      assert retrieved_updated_user.username == updated_username
      assert retrieved_updated_user.id == user_id
    end

    test "updates `User` `email`, `password`, and `username`", %{user_id: user_id} do
      updated_email = "updated_email@email.com"
      updated_password = "updated password"
      updated_password_confirmation = updated_password
      updated_username = "updated username"

      assert {:ok, %{email: updated_email, id: user_id, password: password, username: username}} = Schedule.update_user(updated_email, updated_password, updated_password_confirmation, user_id, updated_username)

      retrieved_updated_user = Repo.get(User, user_id)

      assert retrieved_updated_user.email == updated_email
      assert retrieved_updated_user.password == nil
      assert retrieved_updated_user.username == updated_username
      assert retrieved_updated_user.id == user_id

      assert verify_pass(updated_password, retrieved_updated_user.hashed_password)
    end
  end
end
