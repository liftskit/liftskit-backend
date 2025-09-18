import axios from "axios";
import { ROUTES } from "./routes";
import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import api from "./axios-client";

export const getAllWorkoutDays = async (
  username: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_WORKOUT_DATES_FOR_USER,
    [username],
    "/workouts_performed",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const postCurrentWorkout = async (
  username: string,
  programName: string,
  workoutName: string,
  workoutDate: string,
  exerciseList: object,
  workoutTime: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.POST_WORKOUT_PERFORMED,
    [username],
    "/workouts_performed",
  );

  const options = {
    programName,
    workoutName,
    workoutDate,
    exerciseList: exerciseList,
    workoutTime,
  };

  const results = await api.post(fullURL, options);

  return handleServerResponse(results.data);
};

export const getSelectedDateWorkouts = async (
  username: string,
  workoutDate: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_WORKOUTS_FOR_USER_ON_DATE,
    [username, workoutDate],
    "/workouts_performed",
  );

  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getSelectedWorkoutDay = async (
  username: string,
  date: string,
  accessToken: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_WORKOUTS_FOR_USER_ON_DATE,
    [username, date],
    "/workouts_performed",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};
