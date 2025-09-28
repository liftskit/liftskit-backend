#!/usr/bin/env elixir

# Script to generate comprehensive dummy data for analytics testing
# This script creates realistic workout data for the user tlinkey0818@gmail.com
# focusing on official exercises for analytics tracking

Mix.install([
  {:ecto_sql, "~> 3.10"},
  {:postgrex, "~> 0.17"},
  {:jason, "~> 1.4"}
])

defmodule DummyDataGenerator do
  @moduledoc """
  Generates realistic dummy workout data for analytics testing.
  Creates data spanning several months with realistic progression patterns.
  """

  # Official exercises from the JSON file
  @official_exercises [
    "Back Squat", "Barbell Row", "Bench Press", "Box Squat", "Bulgarian Split Squat",
    "Calf Raise", "Clean", "Close-Grip Bench Press", "Conventional Deadlift", "Deadlift",
    "Dips", "Front Squat", "Hang Clean", "Hang Snatch", "Hip Thrust", "Incline Bench Press",
    "Jerk", "Leg Press", "Lunge", "Overhead Press", "Pause Squat", "Power Clean",
    "Power Jerk", "Power Snatch", "Pull-Up", "Push-Up", "Romanian Deadlift", "Row",
    "Shoulder Press", "Snatch", "Split Squat", "Sumo Deadlift", "Weighted Pull-Up"
  ]

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

  def run do
    IO.puts("🚀 Starting dummy data generation for analytics testing...")

    # Get database URL from environment or use default
    database_url = System.get_env("DATABASE_URL") || "postgres://postgres:password@localhost/liftskit_backend_dev"

    # Parse database URL
    {:ok, %{host: host, port: port, database: database, username: username, password: password}} =
      URI.parse(database_url) |> parse_database_url()

    # Start Ecto repo
    {:ok, _} = Application.ensure_all_started(:postgrex)

    repo_config = %{
      hostname: host,
      port: port,
      database: database,
      username: username,
      password: password,
      pool_size: 10
    }

    {:ok, repo} = Postgrex.start_link(repo_config)

    # Find or create user
    user_id = find_or_create_user(repo)
    IO.puts("✅ User ID: #{user_id}")

    # Generate workout data for the last 4 months
    start_date = Date.add(Date.utc_today(), -120) # 4 months ago
    end_date = Date.utc_today()

    IO.puts("📅 Generating data from #{start_date} to #{end_date}")

    # Generate workouts
    workouts_generated = generate_workouts(repo, user_id, start_date, end_date)
    IO.puts("✅ Generated #{workouts_generated} workouts")

    # Generate one-rep-max data
    generate_one_rep_maxes(repo, user_id)
    IO.puts("✅ Generated one-rep-max data")

    IO.puts("🎉 Dummy data generation completed successfully!")
    IO.puts("📊 You can now test analytics features with realistic data")
  end

  defp parse_database_url(%URI{scheme: "postgres", userinfo: userinfo, host: host, port: port, path: path}) do
    username = case userinfo do
      nil -> "postgres"
      userinfo -> String.split(userinfo, ":") |> List.first()
    end

    password = case userinfo do
      nil -> nil
      userinfo -> String.split(userinfo, ":") |> List.last()
    end

    database = String.trim_leading(path, "/")

    {:ok, %{
      host: host || "localhost",
      port: port || 5432,
      database: database,
      username: username,
      password: password
    }}
  end

  defp find_or_create_user(repo) do
    email = "tlinkey0818@gmail.com"
    username = "tlinkey"

    # Try to find existing user
    case query_user(repo, email) do
      nil ->
        IO.puts("👤 Creating new user: #{email}")
        create_user(repo, email, username)
      user_id ->
        IO.puts("👤 Found existing user: #{email}")
        user_id
    end
  end

  defp query_user(repo, email) do
    case Postgrex.query(repo, "SELECT id FROM users WHERE email = $1", [email]) do
      {:ok, %{rows: []}} -> nil
      {:ok, %{rows: [[id]]}} -> id
    end
  end

  defp create_user(repo, email, username) do
    now = DateTime.utc_now()
    case Postgrex.query(repo,
      "INSERT INTO users (email, username, inserted_at, updated_at) VALUES ($1, $2, $3, $4) RETURNING id",
      [email, username, now, now]) do
      {:ok, %{rows: [[id]]}} -> id
    end
  end

  defp generate_workouts(repo, user_id, start_date, end_date) do
    # Generate workouts 3-5 times per week with some gaps
    workout_dates = generate_workout_schedule(start_date, end_date)

    Enum.reduce(workout_dates, 0, fn {date, template}, acc ->
      workout_id = create_workout_performed(repo, user_id, date, template)
      generate_exercises_for_workout(repo, workout_id, template, date)
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
    |> Enum.take(Enum.count(dates) * 4 div 7) # Roughly 4 workouts per week

    # Assign workout templates
    workout_dates
    |> Enum.with_index()
    |> Enum.map(fn {date, index} ->
      template = Enum.at(@workout_templates, rem(index, length(@workout_templates)))
      {date, template}
    end)
  end

  defp create_workout_performed(repo, user_id, date, template) do
    # Generate realistic workout duration (45-90 minutes)
    duration_minutes = 45 + :rand.uniform(45)

    # Convert date to datetime
    workout_datetime = DateTime.new!(date, ~T[18:00:00], "Etc/UTC")

    case Postgrex.query(repo,
      "INSERT INTO workouts_performed (user_id, workout_name, program_name, workout_date, workout_time, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING id",
      [user_id, template.name, template.program, workout_datetime, duration_minutes, workout_datetime, workout_datetime]) do
      {:ok, %{rows: [[id]]}} -> id
    end
  end

  defp generate_exercises_for_workout(repo, workout_id, template, date) do
    template.exercises
    |> Enum.with_index()
    |> Enum.each(fn {exercise_name, order_index} ->
      generate_exercise_performed(repo, workout_id, exercise_name, order_index, date)
    end)
  end

  defp generate_exercise_performed(repo, workout_id, exercise_name, order_index, date) do
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
    time_seconds = if exercise_type == :Cardio, do: 300 + :rand.uniform(600), else: nil

    # Convert date to datetime
    workout_datetime = DateTime.new!(date, ~T[18:00:00], "Etc/UTC")

    case Postgrex.query(repo,
      "INSERT INTO exercise_performed (workout_performed_id, _type, name, reps, sets, time, weight, is_superset, superset_group, superset_order, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)",
      [workout_id, to_string(exercise_type), exercise_name, reps, sets, time_seconds, final_weight, false, nil, nil, workout_datetime, workout_datetime]) do
      {:ok, _} -> :ok
    end
  end

  defp generate_one_rep_maxes(repo, user_id) do
    # Generate realistic one-rep-max data for major lifts
    major_lifts = ["Back Squat", "Bench Press", "Conventional Deadlift", "Overhead Press", "Barbell Row"]

    Enum.each(major_lifts, fn exercise_name ->
      base_weight = Map.get(@base_weights, exercise_name, 100)
      # One-rep-max is typically 10-15% higher than working weight
      estimated_orm = round(base_weight * 1.12)

      now = DateTime.utc_now()

      case Postgrex.query(repo,
        "INSERT INTO one_rep_maxes (user_id, exercise_name, one_rep_max, inserted_at, updated_at) VALUES ($1, $2, $3, $4, $5) ON CONFLICT (user_id, exercise_name) DO UPDATE SET one_rep_max = $3, updated_at = $5",
        [user_id, exercise_name, estimated_orm, now, now]) do
        {:ok, _} -> :ok
      end
    end)
  end
end

# Run the script
DummyDataGenerator.run()
