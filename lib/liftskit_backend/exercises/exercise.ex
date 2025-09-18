defmodule LiftskitBackend.Exercises.Exercise do
  use Ecto.Schema
  import Ecto.Changeset

  @derive Jason.Encoder

  schema "exercises" do
    field :orm_percent, :decimal
    field :reps, :integer
    field :sets, :integer
    field :time, :integer
    field :weight, :integer
    field :is_superset, :boolean, default: false

    belongs_to :workout, LiftskitBackend.Workouts.Workout, foreign_key: :workout_id
    belongs_to :exercise_root, LiftskitBackend.ExerciseRoots.ExerciseRoot, foreign_key: :exercise_root_id

    # join table for superset exercises
    has_many :exercise_supersets, LiftskitBackend.Exercises.ExerciseSuperset, foreign_key: :exercise_id
    has_many :superset_exercises, through: [:exercise_supersets, :superset_exercise]

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(exercise, attrs) do
    # Convert orm_percent string to Decimal if needed
    attrs = case attrs["orm_percent"] do
      value when is_binary(value) ->
        # Handle "[object Object]" case by defaulting to 0
        if value == "[object Object]" do
          Map.put(attrs, "orm_percent", Decimal.new("0"))
        else
          Map.put(attrs, "orm_percent", Decimal.new(value))
        end
      value when is_number(value) ->
        Map.put(attrs, "orm_percent", Decimal.new(value))
      _ ->
        attrs
    end

    exercise
    |> cast(attrs, [:orm_percent, :reps, :sets, :time, :weight, :is_superset, :exercise_root_id])
    |> validate_required([:orm_percent, :reps, :sets, :time, :weight, :is_superset, :exercise_root_id])
    |> foreign_key_constraint(:workout_id)
    |> foreign_key_constraint(:exercise_root_id)
    |> normalize_numeric_fields()
  end

  # Normalize numeric fields to ensure they're always valid integers
  defp normalize_numeric_fields(changeset) do
    changeset
    |> normalize_integer_field(:time, 0)
    |> normalize_integer_field(:reps, 0)
    |> normalize_integer_field(:sets, 0)
    |> normalize_integer_field(:weight, 0)
    |> normalize_decimal_field(:orm_percent, Decimal.new(0))
  end

  defp normalize_integer_field(changeset, field, default) do
    case get_field(changeset, field) do
      nil -> put_change(changeset, field, default)
      "" -> put_change(changeset, field, default)
      value when is_binary(value) ->
        case Integer.parse(value) do
          {int_value, ""} -> put_change(changeset, field, int_value)
          _ -> put_change(changeset, field, default)
        end
      value when is_integer(value) -> changeset
      _ -> put_change(changeset, field, default)
    end
  end

  defp normalize_decimal_field(changeset, field, default) do
    case get_field(changeset, field) do
      nil -> put_change(changeset, field, default)
      "" -> put_change(changeset, field, default)
      value when is_binary(value) ->
        case Decimal.parse(value) do
          {decimal_value, ""} -> put_change(changeset, field, decimal_value)
          _ -> put_change(changeset, field, default)
        end
      value when is_struct(value, Decimal) -> changeset
      value when is_number(value) -> put_change(changeset, field, Decimal.from_float(value))
      _ -> put_change(changeset, field, default)
    end
  end


end
