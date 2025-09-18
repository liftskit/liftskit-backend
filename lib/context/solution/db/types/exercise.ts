// Exercise-related types
export interface ElixirExerciseRoot {
  id: number;
  name: string;
  _type: string;
}

export interface ElixirExercise {
  id: number;
  orm_percent: number;
  reps: number;
  sets: number;
  time: number;
  weight: number;
  is_superset: boolean;
  exercise_root: ElixirExerciseRoot;
  workout_id: number;
  superset_exercises?: ElixirExercise[];
}

export interface ElixirExercisePerformed {
  id: number;
  exercise_root_id: number;
  workout_performed_id: number;
  sets: number;
  reps: number;
  weight: number;
  time: number;
  orm_percent: number;
  exercise_root: ElixirExerciseRoot;
}

export interface ElixirOfficialExercise {
  id: number;
  name: string;
}

// Frontend compatibility types
export interface ExerciseRoot {
  id: string;
  name: string;
  _type: string;
}

export interface Exercise {
  id: string;
  orm_percent: number;
  reps: number;
  sets: number;
  time: number;
  weight: number;
  is_superset: boolean;
  exercise_root: ExerciseRoot;
  workout_id: string;
  superset_exercises?: Exercise[];
}

export interface ExercisePerformed {
  id: string;
  exercise_root_id: string;
  workout_performed_id: string;
  sets: number;
  reps: number;
  weight: number;
  time: number;
  orm_percent: number;
  exercise_root: ExerciseRoot;
}
