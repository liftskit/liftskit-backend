// Core types needed by the services - import directly from domain files as needed
// This file is kept for backward compatibility but should not be used for new imports

// Re-export commonly used types for convenience
export type { ElixirUser } from './types/auth';
export type { User } from './types/user';
export type { Exercise, ElixirExercise, ExerciseRoot, ElixirExerciseRoot } from './types/exercise';
export type { Workout, ElixirWorkout } from './types/workout';
export type { Program, ElixirProgram } from './types/program';
export type { OneRepMax, ElixirOneRepMax } from './types/one-rep-max';
export type { ElixirTag } from './types/tag';
export type { 
  ElixirResponse, 
  ElixirListResponse, 
  ElixirErrorResponse,
  CreateWorkoutRequest,
  CreateExercisePerformedRequest,
  CreateOneRepMaxRequest
} from './types/common';
