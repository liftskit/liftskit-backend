// One Rep Max types
export interface ElixirOneRepMax {
  id: number;
  user_id: number;
  exercise_root_id: number;
  weight: number;
  exercise_root: ElixirExerciseRoot;
}

// Frontend compatibility types
export interface OneRepMax {
  id: string;
  user_id: string;
  exercise_root_id: string;
  weight: number;
  exercise_root: ExerciseRoot;
}

// Import types from exercise.ts
import { ElixirExerciseRoot, ExerciseRoot } from './exercise';
