import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import { ROUTES } from "./routes";
import api from "./axios-client";

export const getAllExercisesPerformed = async (
  accessToken: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_EXERCISES_PERFORMED,
    [username],
    "/exercises_performed",
  );
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};

export const getAllExercisesPerformedData = async (
  accessToken: string,
  exerciseName: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_EXERCISES_PERFORMED_BY_NAME,
    [username, exerciseName],
    "/exercises_performed",
  );
  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};
