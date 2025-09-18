// Workout-related types
export interface ElixirWorkout {
  id: number;
  name: string;
  best_workout_time: number;
  program_id: number;
  exercises: ElixirExercise[];
}

export interface ElixirWorkoutPerformed {
  id: number;
  user_id: number;
  workout_id: number;
  date: string;
  exercises_performed: ElixirExercisePerformed[];
}

// Frontend compatibility types
export interface Workout {
  id: string;
  name: string;
  best_workout_time: number;
  program_id: string;
  exercises: Exercise[];
}

export interface WorkoutPerformed {
  id: string;
  user_id: string;
  workout_id: string;
  date: string;
  exercises_performed: ExercisePerformed[];
}

// Import types from exercise.ts
import { ElixirExercise, ElixirExercisePerformed, Exercise, ExercisePerformed } from './exercise';
