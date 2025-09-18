import { buildPath } from "@/utilities/build-path/build-path";
import { handleServerResponse } from "./handle-server-response";
import { ROUTES } from "./routes";
import api from "./axios-client";

export const getAllTags = async (accessToken: string) => {
  const fullURL = buildPath(ROUTES.GET_ALL_TAGS, [], "/tags");
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getCommentsOnComment = async (
  accessToken: string,
  commentId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT_COMMENT,
    [commentId],
    "/comments",
  );

  const results = await api.put(fullURL);

  return handleServerResponse(results.data);
};

export const getFollowedProgramsList = async (
  accessToken: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_FOLLOWED_PROGRAM_NAMES,
    [username],
    "/users",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getFollowedProgramWorkouts = async (
  accessToken: string,
  programName: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_ALL_FOLLOWED_PROGRAMS_WORKOUTS,
    [username, programName],
    "/users",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getFollowedWorkoutsNames = async (
  accessToken: string,
  username: string,
) => {
  const fullURL = buildPath(ROUTES.DELETE_COMMENT, [username], "/users");
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getSharedWorkout = async (
  accessToken: string,
  programName: string,
  username: string,
  workoutName: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_NAME,
    [username, programName, workoutName],
    "/shared_workout",
  );

  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getSharedWorkoutById = async (
  accessToken: string,
  workoutId: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_ID,
    [workoutId],
    "/shared_workout",
  );
  const headers = {
    headers: {
      Authorization: accessToken,
    },
  };

  const results = await api.get(fullURL, headers);

  return handleServerResponse(results.data);
};

export const getSharedWorkoutComments = async (
  accessToken: string,
  workoutId: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_COMMENTS,
    [workoutId, username],
    "/shared_workout",
  );

  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getWorkoutByCategory = async (
  accessToken: string,
  category: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_CATEGORY,
    [category],
    "/shared_workout",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getWorkoutByCreator = async (
  accessToken: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_USERNAME,
    [username],
    "/shared_workout",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getSharedWorkoutByName = async (
  accessToken: string,
  workoutName: string,
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_NAME,
    [workoutName],
    "/shared_workout",
  );
  const results = await api.get(fullURL);

  return handleServerResponse(results.data);
};

export const getWorkoutByTags = async (
  accessToken: string,
  tagsList: string[],
) => {
  const fullURL = buildPath(
    ROUTES.GET_SHARED_WORKOUT_BY_TAGS,
    [],
    "/shared_workout",
  );
  const options = {
    tag_list: tagsList,
  };

  const results = await api.post(fullURL, options);

  return handleServerResponse(results.data);
};

export const postUserFollowWorkout = async (
  accessToken: string,
  username: string,
  workoutId: string,
) => {
  const fullURL = buildPath(
    ROUTES.POST_FOLLOW_SHARED_WORKOUTS,
    [username, workoutId],
    "/users",
  );
  const results = await api.post(
    fullURL,
    {},
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

// TODO - putCommentOnComment
export const putCommentOnComment = async (
  accessToken: string,
  commentId: string,
  commentText: string,
  username: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT_COMMENT,
    [commentId],
    "/comments",
  );

  const results = await api.put(
    fullURL,
    {
      username,
      text: commentText,
    },
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

// TODO - putCommentOnSharedWorkout
export const putCommentOnSharedWorkout = async (
  accessToken: string,
  commentText: string,
  username: string,
  workoutId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT_COMMENT,
    [workoutId],
    "/shared_workout",
  );

  const results = await api.put(
    fullURL,
    {
      username,
      text: commentText,
    },
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

export const putUserDislikeComment = async (
  accessToken: string,
  username: string,
  commentId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_COMMENT_DISLIKE,
    [commentId, username],
    "/comments",
  );

  const results = await api.put(
    fullURL,
    {},
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

export const putUserDislikeWorkout = async (
  accessToken: string,
  username: string,
  workoutId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT_DISLIKE,
    [workoutId, username],
    "/shared_workout",
  );
  const results = await api.put(
    fullURL,
    {},
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

export const putUserLikeComment = async (
  accessToken: string,
  username: string,
  commentId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_COMMENT_LIKE,
    [commentId, username],
    "/comments",
  );

  const results = await api.put(
    fullURL,
    {},
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

export const putUserLikeWorkout = async (
  accessToken: string,
  username: string,
  workoutId: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT_LIKE,
    [workoutId, username],
    "/shared_workout",
  );
  const results = await api.put(
    fullURL,
    {},
    {
      headers: {
        Authorization: accessToken,
      },
    },
  );

  return handleServerResponse(results.data);
};

export const shareWorkout = async (
  accessToken: string,
  category: string,
  description: string,
  difficulty: string,
  exerciseList: object,
  programName: string,
  tagsList: string[],
  thumbnail_url: string,
  username: string,
  workoutName: string,
) => {
  const fullURL = buildPath(
    ROUTES.PUT_SHARED_WORKOUT,
    [username, programName, workoutName],
    "/shared_workout",
  );

  const options = {
    category,
    description,
    difficulty,
    exercise_list: exerciseList,
    tags: tagsList,
    thumbnail_url,
  };

  const results = await api.put(fullURL, options);

  return handleServerResponse(results.data);
};
