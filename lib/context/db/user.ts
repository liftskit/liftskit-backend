import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import { ROUTES } from "./routes";
import api from "./axios-client";
import axios from "axios";


export const checkBalance = async (public_key) => {
  const fullURL = buildPath("/check_balance/:public_key", [public_key]);
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getOneRepMax = async (
  username: string,
  exerciseName: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ONE_REP_MAX_BY_USER_AND_EXERCISE,
    [username, exerciseName],
    "/one_rep_max",
  );

  const response = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });
  return response.data;
};

export const getOneRepMaxDict = async (
  username: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_ONE_REP_MAX_RECORDS,
    [username],
    "/one_rep_max",
  );
  try {
    const results = await api.get(fullURL, {
      headers: {
        Authorization: accessToken,
      },
    });
    return results.data;
  } catch (error) {
    console.error("Error in getOneRepMaxDict:", error);
    throw error;
  }
};

export const getUserBalance = async (public_key) => {
  const fullURL = buildPath(
    ROUTES.GET_WORKOUT,
    [public_key],
    "/check_balance",
  );
  const results = await api.get(fullURL);
  return results.data.Balance;
};

export const getUserInfo = async (username: string, accessToken: string) => {
  const fullURL = buildPath(ROUTES.GET_REGISTERED_USER, [username]);

  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getUserPassword = async (email) => {
  const fullURL = buildPath(ROUTES.GET_RECOVERY_PASSWORD, [email]);
  const options = {
    headers: {
      ContentType: "application/json",
    },
  };

  const results = await api.get(fullURL, options);

  return handleServerResponse(results.data);
};

export const getWalletAddress = async (
  username: string,
  accessToken: string,
) => {
  const fullURL = buildPath(ROUTES.GET_WALLET_ADDRESS, [username], "/users");
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const loginUser = async (username: string, password: string) => {
  try {
    const fullURL = buildPath(ROUTES.LOGIN_USER, []);

    const response = await api.post(fullURL, { username, password });

    return handleServerResponse(response.data);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      throw new Error(error.response?.data?.message || 'Authentication failed');
    }
    throw error;
  }
};

export const loginUserWithGoogle = async (token: string) => {
  const fullURL = buildPath(ROUTES.LOGIN_USER, []);
  const options = {
    token: token,
  };
  const results = await api.post(fullURL, options);
  
  return results.data;
};

export const payUserForWorkout = async (
  username: string,
  workout_time: string,
  public_key: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.DELETE_WORKOUT_BY_ID,
    [username],
    "/workouts",
  );
  const headers = {
    headers: {
      Authorization: accessToken,
    },
  };
  const options = {
    data: {
      username: username,
      public_key: public_key,
      workout_time: workout_time,
    },
  };

  const results = await api.post(fullURL, options, headers);

  return handleServerResponse(results.data);
};

export const refreshAccessToken = async (refreshToken: string) => {
  try {
    const fullURL = buildPath(ROUTES.REFRESH_TOKEN, []);
    
    // Use direct axios call to avoid interceptor conflicts
    const response = await axios.post(fullURL, { refresh_token: refreshToken }, {
      baseURL: process.env.EXPO_PUBLIC_API_URL,
      headers: {
        'Content-Type': 'application/json',
      },
    });
    
    console.log('Refresh token response:', JSON.stringify(response.data, null, 2));
    
    // Check if the response needs to be processed through handleServerResponse
    const processedResponse = handleServerResponse(response.data);
    
    if (!processedResponse || !processedResponse.access_token) {
      console.error('Invalid refresh token response structure:', processedResponse);
      throw new Error('Invalid refresh token response');
    }
    
    return processedResponse;
  } catch (error) {
    console.error('Refresh token error:', error);
    if (axios.isAxiosError(error)) {
      throw new Error(error.response?.data?.message || 'Token refresh failed');
    }
    throw error;
  }
};

export const setOneRepMax = async (
  username: string,
  exerciseName: string,
  oneRepMax: number,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_ONE_REP_MAX,
    [username, exerciseName],
    "/one_rep_max",
  );

  const options = {
    one_rep_max: oneRepMax.toString(),
  };

  const response = await api.put(fullURL, options, {
    headers: {
      Authorization: accessToken,
    },
  });
  
  return response;
};

export const setWalletAddress = async (
  username: string,
  public_key: string,
  accessToken: string,
) => {
  const fullURL = buildPath(ROUTES.PUT_WALLET_ADDRESS, [username], "/users");

  const options = {
    public_key: public_key,
  };

  const results = await api.put(fullURL, options, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const signupUser = async (
  username: string,
  password: string,
  email: string,
) => {
  try {
    const fullURL = buildPath(ROUTES.SIGNUP_USER, [username]);
    const response = await api.post(fullURL, { password, email });
    return handleServerResponse(response.data);
  } catch (error) {
    if (axios.isAxiosError(error)) {
      throw new Error(error.response?.data?.message || 'Registration failed');
    }
    throw error;
  }
};

export const updateWorkoutTime = async (
  username: string,
  programName: string,
  workoutName: string,
  newTime: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_WORKOUT,
    [username, programName, workoutName],
    "/workouts",
  );

  const options = {
    new_workout_time: newTime,
  };

  const results = await api.put(fullURL, options, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};
