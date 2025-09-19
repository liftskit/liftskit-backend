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
  @create_with_superset_attrs %{
    name: "Superset Test",
    bestWorkoutTime: "10:00",
    exercises: [
      %{
        exercise_root_id: 2,
        time: "0.00",
        sets: 5,
        reps: 5,
        orm_percent: 0,
        weight: 135,
        is_superset: true
      },
      %{
        exercise_root_id: 2,
        time: "0.00",
        sets: 5,
        reps: 5,
        orm_percent: 0,
        weight: 225,
        is_superset: false
      }
    ]
  }
  @create_with_exercise_root_object_attrs %{
    name: "Exercise Root Object Test",
    bestWorkoutTime: "15:00",
    exercises: [
      %{
        exercise_root: %{
          name: "Push-ups",
          _type: "Bodyweight"
        },
        orm_percent: 0,
        reps: 15,
        sets: 3,
        time: "0",
        weight: 0,
        is_superset: false
      },
      %{
        exercise_root: %{
          name: "Bench Press",
          _type: "Strength"
        },
        orm_percent: 85.0,
        reps: 8,
        sets: 4,
        time: "2:00",
        weight: 185,
        is_superset: true
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

    test "renders workout with exercise_root object format", %{conn: conn} do
      # Create a program first
      program = program_fixture(conn.assigns.current_scope)
      attrs = Map.put(@create_with_exercise_root_object_attrs, :programId, program.id)

      conn = post(conn, ~p"/api/workouts", workout: attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/workouts/#{id}")
      response = json_response(conn, 200)["data"]

      assert %{
               "id" => ^id,
               "bestWorkoutTime" => "15:00",
               "name" => "Exercise Root Object Test",
               "exercises" => exercises
             } = response

      assert length(exercises) == 2

      # Check first exercise (Push-ups)
      [first_exercise | _] = exercises
      assert first_exercise["reps"] == 15
      assert first_exercise["sets"] == 3
      assert first_exercise["weight"] == 0
      assert first_exercise["isSuperset"] == false
      assert first_exercise["exerciseRoot"]["name"] == "Push-ups"
      assert first_exercise["exerciseRoot"]["_type"] == "Bodyweight"

      # Check second exercise (Bench Press with superset)
      [_, second_exercise | _] = exercises
      assert second_exercise["reps"] == 8
      assert second_exercise["sets"] == 4
      assert second_exercise["weight"] == 185
      assert second_exercise["isSuperset"] == true
      assert second_exercise["exerciseRoot"]["name"] == "Bench Press"
      assert second_exercise["exerciseRoot"]["_type"] == "Strength"

      # Check superset exercise
      assert superset_exercise["reps"] == 12
      assert superset_exercise["sets"] == 4
      assert superset_exercise["weight"] == 30
      assert superset_exercise["exerciseRoot"]["name"] == "Dumbbell Flyes"
      assert superset_exercise["exerciseRoot"]["_type"] == "Strength"
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
