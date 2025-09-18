import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import { ROUTES } from "./routes";
import api from "./axios-client";

export const getAllExercises = async (accessToken: string) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_EXERCISE_ROOTS_OFFICIAL,
    [],
    "/exercises",
  );

  const results = await api.get(fullURL, {
    headers: {
      Authorization: accessToken,
    },
  });

  return handleServerResponse(results.data);
};
