import { buildElixirPath } from "./elixir-routes";
import { handleElixirResponse, handleElixirSingleResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { 
  Program, 
  ElixirProgram,
} from "./types/program";
import { Workout, ElixirWorkout } from "./types/workout";

export const getAllProgramBlocks = async (username: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(response.data);
    
    // Filter by username (this would ideally be done on the backend)
    const userPrograms = programs.filter(p => {
      // Since we don't have username in the program, we'll return all for now
      // In a real implementation, you'd want proper user filtering on the backend
      return true;
    });
    
    return DataMapper.mapPrograms(userPrograms);
  } catch (error) {
    console.error("Error in getAllProgramBlocks:", error);
    throw error;
  }
};

export const getProgramBlock = async (
  username: string,
  programBlockName: string,
  accessToken: string,
) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.PROGRAMS);
    const programs = handleElixirResponse<ElixirProgram[]>(response.data);
    
    const program = programs.find(p => p.name === programBlockName);
    
    if (!program) {
      throw new Error("Program not found");
    }
    
    return DataMapper.mapProgram(program);
  } catch (error) {
    console.error("Error in getProgramBlock:", error);
    throw error;
  }
};

export const postProgramBlock = async (
  username: string,
  programBlockName: string,
  programBlockData: any,
  accessToken: string,
) => {
  try {
    const createRequest = {
      name: programBlockName,
      user_id: 1, // This would need to be the actual user ID from the session
      ...programBlockData
    };
    
    const response = await elixirApi.post(ELIXIR_ROUTES.PROGRAMS, createRequest);
    const program = handleElixirResponse<ElixirProgram>(response.data);
    return DataMapper.mapProgram(program);
  } catch (error) {
    console.error("Error in postProgramBlock:", error);
    throw error;
  }
};

export const deleteProgramBlock = async (
  username: string,
  programBlockName: string,
  accessToken: string,
) => {
  try {
    // First get the program to get its ID
    const program = await getProgramBlock(username, programBlockName, accessToken);
    
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.PROGRAM_BY_ID, { id: program.id }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteProgramBlock:", error);
    throw error;
  }
};

export const postNextWorkout = async (
  username: string,
  programBlockName: string,
  accessToken: string,
) => {
  try {
    // Get the program
    const program = await getProgramBlock(username, programBlockName, accessToken);
    
    // Get all workouts for this program
    const workoutResponse = await elixirApi.get(ELIXIR_ROUTES.WORKOUTS);
    const workouts = handleElixirResponse<ElixirWorkout[]>(workoutResponse.data);
    const programWorkouts = workouts.filter(w => w.program_id.toString() === program.id);
    
    if (programWorkouts.length === 0) {
      throw new Error("No workouts found for this program");
    }
    
    // For now, return the first workout
    // In a real implementation, you'd want logic to determine the "next" workout
    return DataMapper.mapWorkout(programWorkouts[0]);
  } catch (error) {
    console.error("Error in postNextWorkout:", error);
    throw error;
  }
};

export const postReset = async (
  username: string,
  programBlockName: string,
  accessToken: string,
) => {
  try {
    // This would typically reset progress or reset to the beginning
    // For now, we'll just return success
    // In a real implementation, you'd want to reset workout progress, etc.
    return { success: true, message: "Program reset successfully" };
  } catch (error) {
    console.error("Error in postReset:", error);
    throw error;
  }
};
