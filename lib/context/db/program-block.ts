import axios from "axios";
import { ROUTES } from "./routes";
import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import api from "./axios-client";

export const createProgramBlock = async (
  username: string,
  program_block: object,
  program_block_name: string,
  description: string,
  last_workout_complete: string,
  next_workout: object,
  next_workout_date: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.POST_PROGRAM_BLOCK,
    [username, program_block_name],
    "/program_block",
  );
  const options = {
    description: description,
    last_workout_complete: last_workout_complete,
    next_workout: next_workout,
    next_workout_date: next_workout_date,
    workouts: program_block,
  };

  const results = await api.post(fullURL, options);

  return handleServerResponse(results.data);
};

export const deleteProgramBlock = async (
  username: string,
  programName: string,
  workoutName: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.DELETE_PROGRAM_BLOCK,
    [username, programName, workoutName],
    "/program_block",
  );

  const results = await api.delete(fullURL);

  return handleServerResponse(results.data);
};

export const getAllProgramBlocks = async (
  username: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_PROGRAM_BLOCKS,
    [username],
    "/worprogram_blockkouts",
  );
  const results = await api.post(fullURL);

  return handleServerResponse(results.data);
};

export const getProgramBlock = async (
  username: string,
  program_block_name: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_PROGRAM_BLOCK,
    [username, program_block_name],
    "/program_block",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const setNextWorkout = async (
  username: string,
  program_block_name: string,
  last_workout_complete: string,
  next_workout: string,
  next_workout_date: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.POST_NEXT_WORKOUT,
    [username, program_block_name],
    "/program_block",
  );

  const options = {
    data: {
      last_workout_complete: last_workout_complete,
      next_workout: next_workout,
      next_workout_date: next_workout_date,
    },
  };

  const response = await api.put(fullURL, options);
  return response.data;
};
