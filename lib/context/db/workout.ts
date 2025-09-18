import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import { ROUTES } from "./routes";
import api from "./axios-client";

export const createWorkout = async (
  username: string,
  programName: string,
  workoutName: string,
  exerciseList: object[],
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.POST_WORKOUT,
    [username, programName, workoutName],
    "/workouts",
  );

  const options = {
    exerciseList,
  };

  const results = await api.put(fullURL, options, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const deleteWorkout = async (workoutId: string, accessToken: string) => {
  const fullURL = buildPath(
    ROUTES.DELETE_WORKOUT_BY_ID,
    [workoutId],
    "/workouts",
  );

  const results = await api.delete(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getSelectedSingleWorkoutByName = async (
  username: string,
  programName: string,
  workoutName: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_WORKOUT,
    [username, programName, workoutName],
    "/workouts",
  );
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getSelectedSingleWorkout = async (
  accessToken: string,
  workout_id: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_WORKOUT_BY_ID,
    [workout_id],
    "/workouts",
  );
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getUserPrograms = async (
  username: string,
  accessToken: string,
) => {
  const fullURL = buildPath(ROUTES.GET_ALL_PROGRAMS, [username], "/programs");

  const results = await api.get(fullURL, {
    headers: {
      Authorization: "Bearer " + accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getUserWorkouts = async (
  username: string,
  program_name: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_WORKOUTS_BY_PROGRAM_NAME,
    [username, program_name],
    "/workouts",
  );
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};
