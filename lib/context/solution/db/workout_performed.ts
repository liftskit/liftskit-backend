import { buildElixirPath } from "./elixir-routes";
import { handleElixirResponse, handleElixirSingleResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { 
  WorkoutPerformed, 
  ElixirWorkoutPerformed,
} from "./types/workout";
import {
  ExercisePerformed,
  ElixirExercisePerformed,
} from "./types/exercise";
import { CreateExercisePerformedRequest } from "./types/common";

export const postWorkoutPerformed = async (
  username: string,
  workoutPerformedData: any,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.WORKOUTS_PERFORMED, workoutPerformedData);
    const workoutPerformed = handleElixirResponse<ElixirWorkoutPerformed>(response.data);
    return DataMapper.mapWorkoutPerformed(workoutPerformed);
  } catch (error) {
    console.error("Error in postWorkoutPerformed:", error);
    throw error;
  }
};

export const getAllWorkoutsForUser = async (username: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS_PERFORMED);
    const workoutsPerformed = handleElixirResponse<ElixirWorkoutPerformed[]>(response.data);
    
    // Filter by username (this would ideally be done on the backend)
    const userWorkouts = workoutsPerformed.filter(wp => {
      // Since we don't have username in the workout performed, we'll return all for now
      // In a real implementation, you'd want proper user filtering on the backend
      return true;
    });
    
    return DataMapper.mapWorkoutsPerformed(userWorkouts);
  } catch (error) {
    console.error("Error in getAllWorkoutsForUser:", error);
    throw error;
  }
};

export const getAllWorkoutDatesForUser = async (username: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS_PERFORMED);
    const workoutsPerformed = handleElixirResponse<ElixirWorkoutPerformed[]>(response.data);
    
    // Extract unique dates
    const dates = [...new Set(workoutsPerformed.map(wp => wp.date))];
    return dates.sort();
  } catch (error) {
    console.error("Error in getAllWorkoutDatesForUser:", error);
    throw error;
  }
};

export const getAllWorkoutsForUserOnDate = async (username: string, date: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS_PERFORMED);
    const workoutsPerformed = handleElixirResponse<ElixirWorkoutPerformed[]>(response.data);
    
    // Filter by date
    const dateWorkouts = workoutsPerformed.filter(wp => wp.date === date);
    return DataMapper.mapWorkoutsPerformed(dateWorkouts);
  } catch (error) {
    console.error("Error in getAllWorkoutsForUserOnDate:", error);
    throw error;
  }
};

// Exercise performed functions
export const postExercisePerformed = async (
  exercisePerformedData: CreateExercisePerformedRequest,
  accessToken: string,
) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.EXERCISES_PERFORMED, exercisePerformedData);
    const exercisePerformed = handleElixirResponse<ElixirExercisePerformed>(response.data);
    return DataMapper.mapExercisePerformed(exercisePerformed);
  } catch (error) {
    console.error("Error in postExercisePerformed:", error);
    throw error;
  }
};

export const getExercisePerformedById = async (exercisePerformedId: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(buildElixirPath(ELIXIR_ROUTES.EXERCISE_PERFORMED_BY_ID, { id: exercisePerformedId }));
    const exercisePerformed = handleElixirResponse<ElixirExercisePerformed>(response.data);
    return DataMapper.mapExercisePerformed(exercisePerformed);
  } catch (error) {
    console.error("Error in getExercisePerformedById:", error);
    throw error;
  }
};

export const putExercisePerformed = async (
  exercisePerformedId: string,
  exercisePerformedData: any,
  accessToken: string,
) => {
  try {
    const response = await elixirApi.put(
      buildElixirPath(ELIXIR_ROUTES.EXERCISE_PERFORMED_BY_ID, { id: exercisePerformedId }),
      exercisePerformedData
    );
    
    const exercisePerformed = handleElixirResponse<ElixirExercisePerformed>(response.data);
    return DataMapper.mapExercisePerformed(exercisePerformed);
  } catch (error) {
    console.error("Error in putExercisePerformed:", error);
    throw error;
  }
};

export const deleteExercisePerformed = async (exercisePerformedId: string, accessToken: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.EXERCISE_PERFORMED_BY_ID, { id: exercisePerformedId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteExercisePerformed:", error);
    throw error;
  }
};

export const getAllExercisesPerformed = async (username: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.EXERCISES_PERFORMED);
    const exercisesPerformed = handleElixirResponse<ElixirExercisePerformed[]>(response.data);
    return DataMapper.mapExercisesPerformed(exercisesPerformed);
  } catch (error) {
    console.error("Error in getAllExercisesPerformed:", error);
    throw error;
  }
};

export const getAllExercisesPerformedByName = async (
  username: string,
  exerciseName: string,
  accessToken: string,
) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.EXERCISES_PERFORMED);
    const exercisesPerformed = handleElixirResponse<ElixirExercisePerformed[]>(response.data);
    
    // Filter by exercise name
    const filteredExercises = exercisesPerformed.filter(ep => 
      ep.exercise_root.name === exerciseName
    );
    
    return DataMapper.mapExercisesPerformed(filteredExercises);
  } catch (error) {
    console.error("Error in getAllExercisesPerformedByName:", error);
    throw error;
  }
};
