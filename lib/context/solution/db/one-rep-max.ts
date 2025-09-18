import { buildElixirPath } from "./elixir-routes";
import { handleElixirResponse, handleElixirSingleResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { 
  OneRepMax, 
  ElixirOneRepMax,
} from "./types/one-rep-max";
import { CreateOneRepMaxRequest } from "./types/common";

export const getAllOneRepMaxes = async (username: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.ONE_REP_MAXES);
    const oneRepMaxes = handleElixirResponse<ElixirOneRepMax[]>(response.data);
    
    // Filter by username (this would ideally be done on the backend)
    const userOneRepMaxes = oneRepMaxes.filter(orm => {
      // Since we don't have username in the one rep max, we'll return all for now
      // In a real implementation, you'd want proper user filtering on the backend
      return true;
    });
    
    return DataMapper.mapOneRepMaxes(userOneRepMaxes);
  } catch (error) {
    console.error("Error in getAllOneRepMaxes:", error);
    throw error;
  }
};

export const getOneRepMaxById = async (oneRepMaxId: string, accessToken: string) => {
  try {
    const response = await elixirApi.get(buildElixirPath(ELIXIR_ROUTES.ONE_REP_MAX_BY_ID, { id: oneRepMaxId }));
    const oneRepMax = handleElixirResponse<ElixirOneRepMax>(response.data);
    return DataMapper.mapOneRepMax(oneRepMax);
  } catch (error) {
    console.error("Error in getOneRepMaxById:", error);
    throw error;
  }
};

export const postOneRepMax = async (oneRepMaxData: CreateOneRepMaxRequest, accessToken: string) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.ONE_REP_MAXES, oneRepMaxData);
    const oneRepMax = handleElixirResponse<ElixirOneRepMax>(response.data);
    return DataMapper.mapOneRepMax(oneRepMax);
  } catch (error) {
    console.error("Error in postOneRepMax:", error);
    throw error;
  }
};

export const putOneRepMax = async (
  username: string,
  exerciseName: string,
  oneRepMaxData: any,
  accessToken: string,
) => {
  try {
    // First find the one rep max by exercise name
    const response = await elixirApi.get(ELIXIR_ROUTES.ONE_REP_MAXES);
    const oneRepMaxes = handleElixirResponse<ElixirOneRepMax[]>(response.data);
    
    const oneRepMax = oneRepMaxes.find(orm => 
      orm.exercise_root.name === exerciseName
    );
    
    if (!oneRepMax) {
      throw new Error("One rep max not found for this exercise");
    }
    
    // Update the one rep max
    const updateResponse = await elixirApi.put(
      buildElixirPath(ELIXIR_ROUTES.ONE_REP_MAX_BY_ID, { id: oneRepMax.id }),
      oneRepMaxData
    );
    
    const updatedOneRepMax = handleElixirResponse<ElixirOneRepMax>(updateResponse.data);
    return DataMapper.mapOneRepMax(updatedOneRepMax);
  } catch (error) {
    console.error("Error in putOneRepMax:", error);
    throw error;
  }
};

export const deleteOneRepMax = async (oneRepMaxId: string, accessToken: string) => {
  try {
    await elixirApi.delete(buildElixirPath(ELIXIR_ROUTES.ONE_REP_MAX_BY_ID, { id: oneRepMaxId }));
    return { success: true };
  } catch (error) {
    console.error("Error in deleteOneRepMax:", error);
    throw error;
  }
};

export const getOneRepMaxByUserAndExercise = async (
  username: string,
  exerciseName: string,
  accessToken: string,
) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.ONE_REP_MAXES);
    const oneRepMaxes = handleElixirResponse<ElixirOneRepMax[]>(response.data);
    
    // Filter by exercise name
    const oneRepMax = oneRepMaxes.find(orm => 
      orm.exercise_root.name === exerciseName
    );
    
    if (!oneRepMax) {
      return null;
    }
    
    return DataMapper.mapOneRepMax(oneRepMax);
  } catch (error) {
    console.error("Error in getOneRepMaxByUserAndExercise:", error);
    throw error;
  }
};
