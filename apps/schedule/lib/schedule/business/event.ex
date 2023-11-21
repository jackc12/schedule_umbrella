defmodule Schedule.Business.Event do
  alias Schedule.Schema.{Attendance, AttendanceParticipants, Event, User, Participant}

  defmacro __using__(_opts) do
    quote do
      def cancel(user_id, event_id) do
        IO.puts("\n\nuser_id: #{inspect(user_id)}\nevent_id: #{inspect(event_id)}\n\n")

        query =
          from(p in "participants",
            where: p.user_id == ^user_id and p.event_id == ^event_id
          )

        @repo.delete_all(query)
      end

      def delete_event(event_id, user_id) do
        case get_event(event_id) do
          %{owner_id: ^user_id} = event ->
            event
            |> Event.changeset()
            |> @repo.delete()

          nil ->
            {:error, :no_event}

          %Event{} ->
            {:error, :not_owner}

          _ ->
            {:error, :unknown}
        end
      end

      def get_event(event_id) do
        event = @repo.get(Event, event_id)
      end

      def get_event_attendance(user_id) do
        query =
          from(c in Event,
            preload: :participants
          )

        events_with_users = @repo.all(query)

        Enum.flat_map(events_with_users, fn
          %{participants: participants} = event
          when is_list(participants) and participants != [] ->
            Enum.reduce_while(
              participants,
              nil,
              fn
                %{id: ^user_id}, acc ->
                  {:halt, [Attendance.new(event, true)]}

                _, acc ->
                  {:cont, [Attendance.new(event, false)]}
              end
            )

          event ->
            [Attendance.new(event, false)]
        end)
      end

      def get_event_attendance_and_participants(event_id, user_id) do
        query =
          from(e in Event,
            where: e.id == ^event_id,
            preload: [:participants, :owner]
          )

        event_with_users = @repo.one(query)

        {participants, is_signed_up} =
          event_with_users.participants
          |> Enum.map_reduce(
            false,
            fn
              %{username: username, id: ^user_id}, _is_signed_up ->
                {username, true}

              %{username: username}, is_signed_up ->
                {username, is_signed_up}
            end
          )

        AttendanceParticipants.new(event_with_users, is_signed_up, participants)
      end

      def get_event_participants(event_id) do
        participants_query = from(u in User, select: u.username)

        event_and_participants_query =
          from(e in Event,
            where: e.id == ^event_id,
            preload: [participants: ^participants_query]
          )

        event_and_participants_query
        |> @repo.one()
      end

      def insert_event(location, name, owner_id, time) do
        %Event{}
        |> Event.changeset(%{
          location: location,
          name: name,
          owner_id: owner_id,
          time: time
        })
        |> @repo.insert
      end

      def list_events, do: @repo.all(Event)

      def new_event, do: Event.changeset(%Event{})

      def signup(user_id, event_id) do
        %Participant{}
        |> Participant.changeset(%{user_id: user_id, event_id: event_id})
        |> @repo.insert
      end
    end
  end
end
