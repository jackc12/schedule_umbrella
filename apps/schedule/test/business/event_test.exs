defmodule Schedule.Test.Business.EventTest do
  use Schedule.Test.Support.RepoCase

  describe "`Schedule.cancel/1`" do
  end

  describe "`Schedule.delete_event/1`" do
    setup do
      user_params = user()

      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()

      %{location: location, name: name, time: time} =
        event_params =
        event()
        |> Map.put(:owner_id, user_id)

      {:ok, %{id: event_id}} =
        %Event{}
        |> Event.changeset(event_params)
        |> Repo.insert()

      %{event_id: event_id, location: location, name: name, time: time, user_id: user_id}
    end

    test "deletes an `Event` from the database", %{event_id: event_id, user_id: user_id} do
      count_query = from(e in Event, select: count(e.id))
      before_count = Repo.one(count_query)
      {:ok, _event} = Schedule.delete_event(event_id, user_id)
      assert Repo.one(count_query) == before_count - 1
    end

    test "deletes the correct `Event` from the database", %{
      event_id: event_id,
      location: location,
      name: name,
      time: time,
      user_id: user_id
    } do
      assert {:ok, event} = Schedule.delete_event(event_id, user_id)
      assert event.id == event_id
      assert event.location == location
      assert event.name == name
      assert event.time == time
      assert event.owner_id == user_id
    end

    test "does not deletes the `Event` from the database if `User` is not the owner", %{
      event_id: event_id,
      user_id: user_id
    } do
      assert {:error, :not_owner} == Schedule.delete_event(event_id, user_id + 1)
    end

    test "does nothing if event does not exist", %{event_id: event_id, user_id: user_id} do
      delete_event_query =
        from(e in Event,
          where: e.id == ^event_id
        )

      Repo.delete_all(delete_event_query)
      assert {:error, :no_event} == Schedule.delete_event(event_id, user_id)
    end

    test "deletes event with participants", %{event_id: event_id, user_id: user_id} do
      user_params_2 = %{user() | email: "email_2@email.com", username: "username 2"}
      {:ok, %{id: user_id_2}} =
        %User{}
        |> User.changeset_with_password(user_params_2)
        |> Repo.insert()
      %Participant{}
      |> Participant.changeset(%{user_id: user_id, event_id: event_id})
      |> Repo.insert()
      %Participant{}
      |> Participant.changeset(%{user_id: user_id_2, event_id: event_id})
      |> Repo.insert()

      participants_before = [participant_before_1, participant_before_2] = Repo.all(Participant)

      assert length(participants_before) == 2
      assert participant_before_1.event_id == event_id
      assert participant_before_1.user_id == user_id
      assert participant_before_2.event_id == event_id
      assert participant_before_2.user_id == user_id_2

      assert {:ok, deleted_event} = Schedule.delete_event(event_id, user_id)
      assert deleted_event.id == event_id

      participants_after = Repo.all(Participant)

      assert length(participants_after) == 0
    end
  end

  describe "`Schedule.get_event/1`" do
  end

  describe "`Schedule.get_event_attendance/1`" do
  end

  describe "`Schedule.get_event_attendance_and_participants/1`" do
  end

  describe "`Schedule.get_event_participants/1`" do
  end

  describe "`Schedule.insert_event/1`" do
    setup do
      user_params = user()

      {:ok, %{id: user_id}} =
        %User{}
        |> User.changeset_with_password(user_params)
        |> Repo.insert()

      event()
      |> Map.put(:user_id, user_id)
    end

    test "adds an `Event` to the database", %{
      location: location,
      name: name,
      user_id: user_id,
      time: time
    } do
      count_query = from(e in Event, select: count(e.id))
      before_count = Repo.one(count_query)
      {:ok, _event} = Schedule.insert_event(location, name, user_id, time)
      assert Repo.one(count_query) == before_count + 1
    end

    test "inserted `Event` has the attributes provided", %{
      location: location,
      name: name,
      user_id: user_id,
      time: time
    } do
      {:ok, event} = Schedule.insert_event(location, name, user_id, time)
      assert event.location == location
      assert event.name == name
      assert event.owner_id == user_id
      assert event.time == time
    end

    test "returns appropriate error if `owner` doesn't exist", %{
      location: location,
      name: name,
      user_id: user_id,
      time: time
    } do
      assert {:error,
              %{
                errors: [
                  owner:
                    {"does not exist",
                     [constraint: :assoc, constraint_name: "events_owner_id_fkey"]}
                ]
              } = _changeset} = Schedule.insert_event(location, name, user_id + 1, time)
    end
  end

  describe "`Schedule.list_events/1`" do
  end

  describe "`Schedule.new_event/1`" do
  end

  describe "`Schedule.signup/1`" do
  end

end
