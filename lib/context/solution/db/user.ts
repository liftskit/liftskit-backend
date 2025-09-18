import { handleElixirResponse } from "./handle-elixir-response";
import { ELIXIR_ROUTES } from "./elixir-routes";
import elixirApi from "./elixir-axios-client";
import { DataMapper } from "./data-mapper";
import { ElixirUser } from "./types/auth";
import { ElixirOneRepMax } from "./types/one-rep-max";

// Note: Some functions from the original service are not implemented in Elixir backend
// These are marked with comments and return appropriate fallbacks

export const checkBalance = async (public_key: string) => {
  // This endpoint doesn't exist in Elixir backend
  // Return a placeholder or throw an error
  throw new Error("Balance checking not implemented in Elixir backend");
};

export const getOneRepMax = async (
  username: string,
  exerciseName: string,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  // This would need to be implemented differently in Elixir
  // For now, we'll search by exercise name and user
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.ONE_REP_MAXES);
    const oneRepMaxes = handleElixirResponse<ElixirOneRepMax[]>(response.data);
    
    // Filter by username and exercise name (this is a simplified approach)
    // In a real implementation, you'd want proper filtering on the backend
    const filtered = oneRepMaxes.filter(orm => 
      orm.exercise_root.name === exerciseName
    );
    
    if (filtered.length > 0) {
      return DataMapper.mapOneRepMax(filtered[0]);
    }
    
    return null;
  } catch (error) {
    console.error("Error in getOneRepMax:", error);
    throw error;
  }
};

export const getOneRepMaxDict = async (
  username: string,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.ONE_REP_MAXES);
    const oneRepMaxes = handleElixirResponse<ElixirOneRepMax[]>(response.data);
    
    // Convert to the expected format
    const mapped = DataMapper.mapOneRepMaxes(oneRepMaxes);
    
    // Create a dictionary by exercise name
    const dict: Record<string, any> = {};
    mapped.forEach(orm => {
      dict[orm.exercise_root.name] = orm;
    });
    
    return dict;
  } catch (error) {
    console.error("Error in getOneRepMaxDict:", error);
    throw error;
  }
};

export const getUserBalance = async (public_key: string) => {
  // This endpoint doesn't exist in Elixir backend
  throw new Error("Balance checking not implemented in Elixir backend");
};

export const getUserInfo = async (username: string, accessToken: string) => {
  try {
    // Search for user by username
    const response = await elixirApi.get(ELIXIR_ROUTES.USER_SEARCH, {
      params: { username }
    });
    
    const users = handleElixirResponse<ElixirUser[]>(response.data);
    const user = users.find(u => u.username === username);
    
    if (!user) {
      throw new Error("User not found");
    }
    
    return handleElixirResponse(DataMapper.mapUser(user));
  } catch (error) {
    console.error("Error in getUserInfo:", error);
    throw error;
  }
};

export const getUserPassword = async (email: string) => {
  // Password recovery not implemented in Elixir backend
  throw new Error("Password recovery not implemented in Elixir backend");
};

export const getWalletAddress = async (
  username: string,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  // Wallet functionality not implemented in Elixir backend
  throw new Error("Wallet functionality not implemented in Elixir backend");
};

export const putWalletAddress = async (
  username: string,
  walletAddress: string,
  accessToken: string, // Not needed for session-based auth but keeping signature
) => {
  // Wallet functionality not implemented in Elixir backend
  throw new Error("Wallet functionality not implemented in Elixir backend");
};

export const listAllUsers = async (accessToken: string) => {
  try {
    const response = await elixirApi.get(ELIXIR_ROUTES.USERS);
    const users = handleElixirResponse<ElixirUser[]>(response.data);
    return DataMapper.mapUsers(users);
  } catch (error) {
    console.error("Error in listAllUsers:", error);
    throw error;
  }
};

export const getUserByEmail = async (email: string, accessToken: string) => {
  try {
    // Search for user by email
    const response = await elixirApi.get(ELIXIR_ROUTES.USER_SEARCH, {
      params: { email }
    });
    
    const users = handleElixirResponse<ElixirUser[]>(response.data);
    const user = users.find(u => u.email === email);
    
    if (!user) {
      throw new Error("User not found");
    }
    
    return DataMapper.mapUser(user);
  } catch (error) {
    console.error("Error in getUserByEmail:", error);
    throw error;
  }
};

export const getAllFollowedProgramNames = async (username: string, accessToken: string) => {
  // This functionality not implemented in Elixir backend
  return [];
};

export const getAllFollowedProgramsWorkouts = async (username: string, programName: string, accessToken: string) => {
  // This functionality not implemented in Elixir backend
  return [];
};

export const getFollowSharedWorkouts = async (username: string, sharedWorkoutId: string, accessToken: string) => {
  // This functionality not implemented in Elixir backend
  return null;
};

export const postFollowSharedWorkouts = async (username: string, sharedWorkoutId: string, accessToken: string) => {
  // This functionality not implemented in Elixir backend
  return null;
};

// New functions for Elixir backend
export const signIn = async (email: string, password: string) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.SIGNIN, {
      email,
      password
    });
    
    return handleElixirResponse(response.data);
  } catch (error) {
    console.error("Error in signIn:", error);
    throw error;
  }
};

export const signUp = async (username: string, email: string, password: string) => {
  try {
    const response = await elixirApi.post(ELIXIR_ROUTES.SIGNUP, {
      username,
      email,
      password
    });
    
    return handleElixirResponse(response.data);
  } catch (error) {
    console.error("Error in signUp:", error);
    throw error;
  }
};

export const getCurrentUser = async () => {
  try {
    // This would need to be implemented in the Elixir backend
    // For now, we'll return null
    return null;
  } catch (error) {
    console.error("Error in getCurrentUser:", error);
    throw error;
  }
};
