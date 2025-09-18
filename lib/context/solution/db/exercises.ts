import { buildElixirPath } from "./elixir-routes";
import { handleElixirResponse, handleElixirSingleResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { 
  Exercise, 
  ElixirExercise,
  ExerciseRoot,
  ElixirExerciseRoot,
} from "./types/exercise";
import { ElixirOfficialExercise } from "./types/exercise";

export const getAllExerciseRootsOfficial = async () => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.OFFICIAL_EXERCISES);
    const officialExercises = handleElixirResponse<ElixirOfficialExercise[]>(response.data);
    
    // Convert to exercise root format for compatibility
    const exerciseRoots: ElixirExerciseRoot[] = officialExercises.map(oe => ({
      id: oe.id,
      name: oe.name,
      _type: "official"
    }));
    
    return DataMapper.mapExerciseRoots(exerciseRoots);
  } catch (error) {
    console.error("Error in getAllExerciseRootsOfficial:", error);
    throw error;
  }
};

export const deleteExerciseRootOfficial = async (exerciseRootId: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.OFFICIAL_EXERCISE_BY_ID, { id: exerciseRootId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteExerciseRootOfficial:", error);
    throw error;
  }
};

export const putExerciseRootOfficial = async (exerciseRootId: string, exerciseRootData: any) => {
  try {
    const response = await elixirApi.put(
      buildElixirPath(ELIXIR_ROUTES.OFFICIAL_EXERCISE_BY_ID, { id: exerciseRootId }),
      exerciseRootData
    );
    
    const exerciseRoot = handleElixirResponse<ElixirOfficialExercise>(response.data);
    
    // Convert to exercise root format for compatibility
    const converted: ElixirExerciseRoot = {
      id: exerciseRoot.id,
      name: exerciseRoot.name,
      _type: "official"
    };
    
    return DataMapper.mapExerciseRoot(converted);
  } catch (error) {
    console.error("Error in putExerciseRootOfficial:", error);
    throw error;
  }
};

export const getAllExerciseRoots = async () => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.EXERCISE_ROOTS);
    const exerciseRoots = handleElixirResponse<ElixirExerciseRoot[]>(response.data);
    return DataMapper.mapExerciseRoots(exerciseRoots);
  } catch (error) {
    console.error("Error in getAllExerciseRoots:", error);
    throw error;
  }
};

export const getExerciseRootById = async (exerciseRootId: string) => {
  try {
    const response = await elixirApi.get(buildElixirPath(ELIXIR_ROUTES.EXERCISE_ROOT_BY_ID, { id: exerciseRootId }));
    const exerciseRoot = handleElixirResponse<ElixirExerciseRoot>(response.data);
    return DataMapper.mapExerciseRoot(exerciseRoot);
  } catch (error) {
    console.error("Error in getExerciseRootById:", error);
    throw error;
  }
};

export const postExerciseRoot = async (exerciseRootData: any) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.EXERCISE_ROOTS, exerciseRootData);
    const exerciseRoot = handleElixirResponse<ElixirExerciseRoot>(response.data);
    return DataMapper.mapExerciseRoot(exerciseRoot);
  } catch (error) {
    console.error("Error in postExerciseRoot:", error);
    throw error;
  }
};

export const deleteExerciseRoot = async (exerciseRootId: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.EXERCISE_ROOT_BY_ID, { id: exerciseRootId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteExerciseRoot:", error);
    throw error;
  }
};

export const getAllExercises = async () => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.EXERCISES);
    const exercises = handleElixirResponse<ElixirExercise[]>(response.data);
    return DataMapper.mapExercises(exercises);
  } catch (error) {
    console.error("Error in getAllExercises:", error);
    throw error;
  }
};

export const getExerciseById = async (exerciseId: string) => {
  try {
    const response = await elixirApi.get(buildElixirPath(ELIXIR_ROUTES.EXERCISE_BY_ID, { id: exerciseId }));
    const exercise = handleElixirResponse<ElixirExercise>(response.data);
    return DataMapper.mapExercise(exercise);
  } catch (error) {
    console.error("Error in getExerciseById:", error);
    throw error;
  }
};

export const postExercise = async (exerciseData: any) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.EXERCISES, exerciseData);
    const exercise = handleElixirResponse<ElixirExercise>(response.data);
    return DataMapper.mapExercise(exercise);
  } catch (error) {
    console.error("Error in postExercise:", error);
    throw error;
  }
};

export const deleteExercise = async (exerciseId: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.EXERCISE_BY_ID, { id: exerciseId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteExercise:", error);
    throw error;
  }
};

export const getAllExerciseNames = async (username: string) => {
  try {
    // Get all exercise roots to get exercise names
    const response = await elixirApi.get(ELIXIR_ROUTES.EXERCISE_ROOTS);
    const exerciseRoots = handleElixirResponse<ElixirExerciseRoot[]>(response.data);
    
    // Extract unique exercise names
    const exerciseNames = [...new Set(exerciseRoots.map(er => er.name))];
    return exerciseNames.sort();
  } catch (error) {
    console.error("Error in getAllExerciseNames:", error);
    throw error;
  }
};
