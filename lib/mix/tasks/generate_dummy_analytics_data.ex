defmodule Mix.Tasks.GenerateDummyAnalyticsData do
  @moduledoc """
  Mix task to generate comprehensive dummy data for analytics testing.

  This task creates realistic workout data for the user tlinkey0818@gmail.com
  focusing on official exercises for analytics tracking.

  Usage:
    mix generate_dummy_analytics_data
  """

  use Mix.Task
  require Logger


  # Exercise types mapping
  @exercise_types %{
    "Back Squat" => :Strength,
    "Barbell Row" => :Strength,
    "Bench Press" => :Strength,
    "Box Squat" => :Strength,
    "Bulgarian Split Squat" => :Strength,
    "Calf Raise" => :Strength,
    "Clean" => :Strength,
    "Close-Grip Bench Press" => :Strength,
    "Conventional Deadlift" => :Strength,
    "Deadlift" => :Strength,
    "Dips" => :Bodyweight,
    "Front Squat" => :Strength,
    "Hang Clean" => :Strength,
    "Hang Snatch" => :Strength,
    "Hip Thrust" => :Strength,
    "Incline Bench Press" => :Strength,
    "Jerk" => :Strength,
    "Leg Press" => :Strength,
    "Lunge" => :Bodyweight,
    "Overhead Press" => :Strength,
    "Pause Squat" => :Strength,
    "Power Clean" => :Strength,
    "Power Jerk" => :Strength,
    "Power Snatch" => :Strength,
    "Pull-Up" => :Bodyweight,
    "Push-Up" => :Bodyweight,
    "Romanian Deadlift" => :Strength,
    "Row" => :Strength,
    "Shoulder Press" => :Strength,
    "Snatch" => :Strength,
    "Split Squat" => :Bodyweight,
    "Sumo Deadlift" => :Strength,
    "Weighted Pull-Up" => :Strength
  }

  # Base weights for different exercises (in lbs)
  @base_weights %{
    "Back Squat" => 135,
    "Barbell Row" => 95,
    "Bench Press" => 115,
    "Box Squat" => 115,
    "Bulgarian Split Squat" => 0,
    "Calf Raise" => 45,
    "Clean" => 95,
    "Close-Grip Bench Press" => 95,
    "Conventional Deadlift" => 185,
    "Deadlift" => 185,
    "Dips" => 0,
    "Front Squat" => 95,
    "Hang Clean" => 95,
    "Hang Snatch" => 75,
    "Hip Thrust" => 135,
    "Incline Bench Press" => 95,
    "Jerk" => 95,
    "Leg Press" => 180,
    "Lunge" => 0,
    "Overhead Press" => 75,
    "Pause Squat" => 115,
    "Power Clean" => 95,
    "Power Jerk" => 95,
    "Power Snatch" => 75,
    "Pull-Up" => 0,
    "Push-Up" => 0,
    "Romanian Deadlift" => 135,
    "Row" => 95,
    "Shoulder Press" => 75,
    "Snatch" => 75,
    "Split Squat" => 0,
    "Sumo Deadlift" => 185,
    "Weighted Pull-Up" => 25
  }

  # Rep ranges for different exercises
  @rep_ranges %{
    "Back Squat" => {5, 12},
    "Barbell Row" => {6, 10},
    "Bench Press" => {5, 10},
    "Box Squat" => {5, 8},
    "Bulgarian Split Squat" => {8, 15},
    "Calf Raise" => {10, 20},
    "Clean" => {3, 5},
    "Close-Grip Bench Press" => {6, 10},
    "Conventional Deadlift" => {3, 8},
    "Deadlift" => {3, 8},
    "Dips" => {5, 15},
    "Front Squat" => {5, 10},
    "Hang Clean" => {3, 5},
    "Hang Snatch" => {3, 5},
    "Hip Thrust" => {8, 15},
    "Incline Bench Press" => {6, 10},
    "Jerk" => {3, 5},
    "Leg Press" => {10, 20},
    "Lunge" => {8, 15},
    "Overhead Press" => {5, 10},
    "Pause Squat" => {3, 8},
    "Power Clean" => {3, 5},
    "Power Jerk" => {3, 5},
    "Power Snatch" => {3, 5},
    "Pull-Up" => {3, 12},
    "Push-Up" => {8, 25},
    "Romanian Deadlift" => {6, 12},
    "Row" => {6, 12},
    "Shoulder Press" => {5, 10},
    "Snatch" => {3, 5},
    "Split Squat" => {8, 15},
    "Sumo Deadlift" => {3, 8},
    "Weighted Pull-Up" => {3, 8}
  }

  # Workout templates
  @workout_templates [
    %{
      name: "Push Day A",
      program: "Upper/Lower Split",
      exercises: ["Bench Press", "Overhead Press", "Close-Grip Bench Press", "Dips", "Push-Up"]
    },
    %{
      name: "Pull Day A",
      program: "Upper/Lower Split",
      exercises: ["Deadlift", "Barbell Row", "Pull-Up", "Weighted Pull-Up", "Row"]
    },
    %{
      name: "Leg Day A",
      program: "Upper/Lower Split",
      exercises: ["Back Squat", "Romanian Deadlift", "Bulgarian Split Squat", "Calf Raise", "Lunge"]
    },
    %{
      name: "Push Day B",
      program: "Upper/Lower Split",
      exercises: ["Incline Bench Press", "Shoulder Press", "Dips", "Push-Up", "Close-Grip Bench Press"]
    },
    %{
      name: "Pull Day B",
      program: "Upper/Lower Split",
      exercises: ["Sumo Deadlift", "Row", "Pull-Up", "Barbell Row", "Weighted Pull-Up"]
    },
    %{
      name: "Leg Day B",
      program: "Upper/Lower Split",
      exercises: ["Front Squat", "Hip Thrust", "Split Squat", "Calf Raise", "Leg Press"]
    },
    %{
      name: "Olympic Lifting",
      program: "Olympic Focus",
      exercises: ["Clean", "Snatch", "Jerk", "Hang Clean", "Hang Snatch", "Power Clean", "Power Snatch", "Power Jerk"]
    },
    %{
      name: "Strength Focus",
      program: "Powerlifting",
      exercises: ["Back Squat", "Bench Press", "Conventional Deadlift", "Pause Squat", "Box Squat"]
    }
  ]

  @shortdoc "Generate dummy analytics data for testing"

  def run(_args) do
    Mix.Task.run("app.start")

    Logger.info("🚀 Starting dummy data generation for analytics testing...")

    # Use existing user with ID = 1
    user_id = 1
    user = LiftskitBackend.Accounts.get_user!(user_id)
    Logger.info("✅ Using User ID: #{user.id} (#{user.email})")

    # Generate workout data for the last 4 months
    start_date = Date.add(Date.utc_today(), -120) # 4 months ago
    end_date = Date.utc_today()

    Logger.info("📅 Generating data from #{start_date} to #{end_date}")

    # Generate workouts
    workouts_generated = generate_workouts(user_id, start_date, end_date)
    Logger.info("✅ Generated #{workouts_generated} workouts")

    # Generate one-rep-max data
    generate_one_rep_maxes(user_id)
    Logger.info("✅ Generated one-rep-max data")

    Logger.info("🎉 Dummy data generation completed successfully!")
    Logger.info("📊 You can now test analytics features with realistic data")
  end

  defp generate_workouts(user_id, start_date, end_date) do
    # Generate workouts 3-5 times per week with some gaps
    workout_dates = generate_workout_schedule(start_date, end_date)

    Enum.reduce(workout_dates, 0, fn {date, template}, acc ->
      create_workout_with_exercises(user_id, date, template)
      acc + 1
    end)
  end

  defp generate_workout_schedule(start_date, end_date) do
    # Generate realistic workout schedule (3-5 workouts per week)
    dates = Date.range(start_date, end_date) |> Enum.to_list()

    workout_dates = dates
    |> Enum.filter(fn date ->
      # Skip some days randomly to simulate realistic patterns
      day_of_week = Date.day_of_week(date)
      random_factor = :rand.uniform(100)

      cond do
        # Higher chance on weekdays
        day_of_week in [1, 2, 3, 4, 5] and random_factor > 20 -> true
        # Lower chance on weekends
        day_of_week in [6, 7] and random_factor > 60 -> true
        true -> false
      end
    end)
    |> Enum.take(div(Enum.count(dates) * 4, 7)) # Roughly 4 workouts per week

    # Assign workout templates
    workout_dates
    |> Enum.with_index()
    |> Enum.map(fn {date, index} ->
      template = Enum.at(@workout_templates, rem(index, length(@workout_templates)))
      {date, template}
    end)
  end

  defp create_workout_with_exercises(user_id, date, template) do
    # Generate realistic workout duration (45-90 minutes)
    duration_minutes = 45 + :rand.uniform(45)

    # Convert date to datetime
    workout_datetime = DateTime.new!(date, ~T[18:00:00], "Etc/UTC")

    # Create scope for the user
    user = LiftskitBackend.Accounts.get_user!(user_id)
    scope = LiftskitBackend.Accounts.Scope.for_user(user)

    # Generate exercises for this workout
    exercises_data = template.exercises
    |> Enum.with_index()
    |> Enum.map(fn {exercise_name, _order_index} ->
      generate_exercise_data(exercise_name, date)
    end)

    # Create workout with exercises
    {:ok, _workout} = LiftskitBackend.WorkoutsPerformed.create_workout_performed(scope, %{
      "workout_name" => template.name,
      "program_name" => template.program,
      "workout_date" => workout_datetime,
      "workout_time" => duration_minutes,
      "exercises_performed" => exercises_data
    })
  end

  defp generate_exercise_data(exercise_name, date) do
    exercise_type = Map.get(@exercise_types, exercise_name, :Strength)
    base_weight = Map.get(@base_weights, exercise_name, 45)
    {min_reps, max_reps} = Map.get(@rep_ranges, exercise_name, {5, 10})

    # Generate realistic progression over time
    days_since_start = Date.diff(date, Date.add(Date.utc_today(), -120))
    progression_factor = 1.0 + (days_since_start * 0.002) # Small daily progression

    # Add some randomness to make it realistic
    weight_variation = 0.9 + (:rand.uniform(20) / 100) # ±10% variation
    current_weight = round(base_weight * progression_factor * weight_variation)

    # Generate sets and reps
    sets = 3 + :rand.uniform(2) # 3-4 sets
    reps = min_reps + :rand.uniform(max_reps - min_reps)

    # For bodyweight exercises, weight is 0
    final_weight = if exercise_type == :Bodyweight, do: 0, else: current_weight

    # Generate time for cardio exercises (if any)
    time_seconds = if exercise_type == :Cardio, do: 300 + :rand.uniform(600), else: 0

    %{
      "_type" => exercise_type,
      "name" => exercise_name,
      "reps" => reps,
      "sets" => sets,
      "time" => time_seconds,
      "weight" => final_weight,
      "is_superset" => false,
      "superset_group" => nil,
      "superset_order" => nil
    }
  end

  defp generate_one_rep_maxes(user_id) do
    # Generate realistic one-rep-max data for major lifts
    major_lifts = ["Back Squat", "Bench Press", "Conventional Deadlift", "Overhead Press", "Barbell Row"]

    # Create scope for the user
    user = LiftskitBackend.Accounts.get_user!(user_id)
    scope = LiftskitBackend.Accounts.Scope.for_user(user)

    Enum.each(major_lifts, fn exercise_name ->
      base_weight = Map.get(@base_weights, exercise_name, 100)
      # One-rep-max is typically 10-15% higher than working weight
      estimated_orm = round(base_weight * 1.12)

      # Try to create or update one-rep-max
      case get_one_rep_max_by_user_and_exercise(user_id, exercise_name) do
        nil ->
          {:ok, _orm} = LiftskitBackend.OneRepMaxes.create_one_rep_max(scope, %{
            "exercise_name" => exercise_name,
            "one_rep_max" => estimated_orm
          })
        existing_orm ->
          {:ok, _orm} = LiftskitBackend.OneRepMaxes.update_one_rep_max(scope, existing_orm, %{
            "one_rep_max" => estimated_orm
          })
      end
    end)
  end

  defp get_one_rep_max_by_user_and_exercise(user_id, exercise_name) do
    alias LiftskitBackend.OneRepMaxes.OneRepMax

    LiftskitBackend.Repo.get_by(OneRepMax, user_id: user_id, exercise_name: exercise_name)
  end
end
