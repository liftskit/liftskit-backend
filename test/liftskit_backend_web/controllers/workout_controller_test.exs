defmodule LiftskitBackendWeb.WorkoutControllerTest do
  use LiftskitBackendWeb.ConnCase

  import LiftskitBackend.WorkoutsFixtures
  import LiftskitBackend.ProgramsFixtures
  alias LiftskitBackend.Workouts.Workout

  @create_attrs %{
    name: "some name",
    bestWorkoutTime: "some bestWorkoutTime"
  }
  @create_with_exercises_attrs %{
    name: "workout with exercises",
    bestWorkoutTime: "10:30",
    exercises: [
      %{
        ormPercent: "85.0",
        reps: 8,
        sets: 3,
        time: "2:00",
        weight: 135,
        isSuperset: false,
        exerciseRoot: 1
      },
      %{
        ormPercent: "75.0",
        reps: 12,
        sets: 4,
        time: "1:30",
        weight: 95,
        isSuperset: true,
        exerciseRoot: 2
      }
    ]
  }
  @update_attrs %{
    name: "some updated name",
    bestWorkoutTime: "some updated bestWorkoutTime"
  }
  @invalid_attrs %{name: nil, bestWorkoutTime: nil}

  setup :register_and_log_in_user

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all workouts", %{conn: conn} do
      conn = get(conn, ~p"/api/workouts")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create workout" do
    test "renders workout when data is valid", %{conn: conn} do
      # Create a program first
      program = program_fixture(conn.assigns.current_scope)
      attrs = Map.put(@create_attrs, :programId, program.id)

      conn = post(conn, ~p"/api/workouts", workout: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "some bestWorkoutTime",
               "name" => "some name"
             } = json_response(conn, 200)["data"]
    end

    test "renders workout with exercises when exercises are provided", %{conn: conn} do
      # Create a program first
      program = program_fixture(conn.assigns.current_scope)
      attrs = Map.put(@create_with_exercises_attrs, :programId, program.id)

      conn = post(conn, ~p"/api/workouts", workout: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")
      response = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "10:30",
               "name" => "workout with exercises",
               "exercises" => exercises
             } = response

      assert length(exercises) == 2

      # Check first exercise
      [first_exercise | _] = exercises
      assert first_exercise["reps"] == 8
      assert first_exercise["sets"] == 3
      assert first_exercise["weight"] == 135
      assert first_exercise["isSuperset"] == false

      # Check second exercise
      [_, second_exercise | _] = exercises
      assert second_exercise["reps"] == 12
      assert second_exercise["sets"] == 4
      assert second_exercise["weight"] == 95
      assert second_exercise["isSuperset"] == true
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/workouts", workout: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update workout" do
    setup [:create_workout]

    test "renders workout when data is valid", %{conn: conn, workout: %Workout{id: id} = workout} do
      conn = put(conn, ~p"/api/workouts/#{workout}", workout: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "some updated bestWorkoutTime",
               "name" => "some updated name"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, workout: workout} do
      conn = put(conn, ~p"/api/workouts/#{workout}", workout: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete workout" do
    setup [:create_workout]

    test "deletes chosen workout", %{conn: conn, workout: workout} do
      conn = delete(conn, ~p"/api/workouts/#{workout}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/workouts/#{workout}")
      end
    end
  end

  defp create_workout(%{scope: scope}) do
    workout = workout_fixture(scope)

    %{workout: workout}
  end
end
