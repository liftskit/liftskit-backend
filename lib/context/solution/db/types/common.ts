// Common response wrapper types
export interface ElixirResponse<T> {
  data: T;
}

export interface ElixirListResponse<T> {
  data: T[];
}

// Error response type
export interface ElixirErrorResponse {
  error: string;
  details?: any;
}

// Request types for creating/updating entities
export interface CreateWorkoutRequest {
  name: string;
  program_id: number;
  exercises: Omit<ElixirExercise, 'id' | 'workout_id'>[];
}

export interface CreateExercisePerformedRequest {
  exercise_root_id: number;
  workout_performed_id: number;
  sets: number;
  reps: number;
  weight: number;
  time: number;
  orm_percent: number;
}

export interface CreateOneRepMaxRequest {
  exercise_root_id: number;
  weight: number;
}

// Import types from exercise.ts
import { ElixirExercise } from './exercise';
