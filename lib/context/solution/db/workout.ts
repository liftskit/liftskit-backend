import { buildElixirPath } from "./elixir-routes";
import { handleElixirResponse, handleElixirSingleResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { 
  Workout, 
  ElixirWorkout, 
} from "./types/workout";
import { Program, ElixirProgram } from "./types/program";
import { CreateWorkoutRequest } from "./types/common";

export const getWorkout = async (
  username: string,
  programName: string,
  workoutName: string,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  try {
    // First get the program to get its ID
    const programResponse = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(programResponse.data);
    const program = programs.find(p => p.name === programName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    // Then get the workout by program ID and name
    const workoutResponse = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS);
    const workouts = handleElixirResponse<ElixirWorkout[]>(workoutResponse.data);
    const workout = workouts.find(w => w.program_id === program.id && w.name === workoutName);
    
    if (!workout) {
      throw new Error("Workout not found");
    }
    
    return DataMapper.mapWorkout(workout);
  } catch (error) {
    console.error("Error in getWorkout:", error);
    throw error;
  }
};

export const getWorkoutById = async (workoutId: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(buildElixirPath(ELIXIR_ROUTES.WORKOUT_BY_ID, { id: workoutId }));
    const workout = handleElixirResponse<ElixirWorkout>(response.data);
    return DataMapper.mapWorkout(workout);
  } catch (error) {
    console.error("Error in getWorkoutById:", error);
    throw error;
  }
};

export const getWorkoutsByProgramName = async (
  username: string,
  programName: string,
  accessToken: string,
) => {
  try {
    // First get the program to get its ID
    const programResponse = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(programResponse.data);
    const program = programs.find(p => p.name === programName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    // Then get all workouts for that program
    const workoutResponse = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS);
    const workouts = handleElixirResponse<ElixirWorkout[]>(workoutResponse.data);
    const programWorkouts = workouts.filter(w => w.program_id === program.id);
    
    return DataMapper.mapWorkouts(programWorkouts);
  } catch (error) {
    console.error("Error in getWorkoutsByProgramName:", error);
    throw error;
  }
};

export const postWorkout = async (
  username: string,
  programName: string,
  workoutName: string,
  workoutData: any,
  accessToken: string,
) => {
  try {
    // First get the program to get its ID
    const programResponse = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(programResponse.data);
    const program = programs.find(p => p.name === programName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    // Create the workout
    const createRequest: CreateWorkoutRequest = {
      name: workoutName,
      program_id: program.id,
      exercises: workoutData.exercises || [],
    };
    
    const response = await elixirApi.post(ELIXIR_ROUTES.WORKOUTS, createRequest);
    const workout = handleElixirResponse<ElixirWorkout>(response.data);
    return DataMapper.mapWorkout(workout);
  } catch (error) {
    console.error("Error in postWorkout:", error);
    throw error;
  }
};

export const putWorkout = async (
  username: string,
  programName: string,
  workoutName: string,
  workoutData: any,
  accessToken: string,
) => {
  try {
    // First get the workout to get its ID
    const existingWorkout = await getWorkout(username, programName, workoutName, accessToken);
    
    // Update the workout
    const response = await elixirApi.put(
      buildElixirPath(ELIXIR_ROUTES.WORKOUT_BY_ID, { id: existingWorkout.id }),
      workoutData
    );
    
    const workout = handleElixirResponse<ElixirWorkout>(response.data);
    return DataMapper.mapWorkout(workout);
  } catch (error) {
    console.error("Error in putWorkout:", error);
    throw error;
  }
};

export const deleteWorkoutById = async (workoutId: string, accessToken: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.WORKOUT_BY_ID, { id: workoutId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteWorkoutById:", error);
    throw error;
  }
};

export const putProgram = async (
  username: string,
  programName: string,
  programData: any,
  accessToken: string,
) => {
  try {
    // First get the program to get its ID
    const programResponse = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(programResponse.data);
    const program = programs.find(p => p.name === programName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    // Update the program
    const response = await elixirApi.put(
      buildElixirPath(ELIXIR_ROUTES.PROGRAM_BY_ID, { id: program.id }),
      programData
    );
    
    const updatedProgram = handleElixirResponse<ElixirProgram>(response.data);
    return DataMapper.mapProgram(updatedProgram);
  } catch (error) {
    console.error("Error in putProgram:", error);
    throw error;
  }
};

export const deleteProgram = async (
  username: string,
  programName: string,
  accessToken: string,
) => {
  try {
    // First get the program to get its ID
    const programResponse = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(programResponse.data);
    const program = programs.find(p => p.name === programName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.PROGRAM_BY_ID, { id: program.id }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteProgram:", error);
    throw error;
  }
};
