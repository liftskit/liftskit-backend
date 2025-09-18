
export const ROUTES = {
  HOME: "/",
  PROTECTED: "/protected",

  // Comment
  DELETE_COMMENT: "/delete/:comment_id",
  PUT_COMMENT_DISLIKE: "/dislike/:comment_id/:username",
  PUT_COMMENT_LIKE: "/like/:comment_id/:username",
  GET_COMMENTS_FOR_COMMENT: "/comments/:comment_id",
  PUT_COMMENT_FOR_COMMENT: "/comments/:comment_id",

  // EXERCISE PERFORMED
  GET_EXERCISE_INFO: "/:username/:exercise_name/",
  GET_ALL_EXERCISES_PERFORMED: "/:username/exercises_performed",
  GET_ALL_EXERCISES_PERFORMED_BY_NAME: "/:username/exercises_performed/:exercise_name",

  // EXERCISES
  GET_ALL_EXERCISES_PERFORMED_NAMES: "/exercise_names/:username",
  GET_EXERCISE_BY_NAME: "/:exercise_name",
  POST_EXERCISE_BY_NAME: "/:exercise_name",
  GET_ALL_EXERCISE_ROOTS_OFFICIAL: "/official",
  DELETE_EXERCISE_ROOT_OFFICIAL: "/official",
  PUT_EXERCISE_ROOT_OFFICIAL: "/official",

  // MEMBERSHIP
  DELETE_MEMBERSHIP: "/memberships/:address",
  GET_ALL_MEMBERSHIPS: "/all_members",
  GET_MEMBERSHIP_BY_ADDRESS: "/memberships/:address",
  PUT_MEMBERSHIP: "/memberships",
  UPDATE_MEMBERSHIP: "/memberships/:address",

  // MISC
  DELETE_REGISTERED_USER: "/register/:username",
  GET_PAID_TODAY: "/paid_today",
  GET_REGISTERED_USER: "/register/:username",
  POST_PAID_TODAY: "/paid_today",
  LOGIN_USER: "/login",
  LOGOUT_USER: "/logout",
  SIGNUP_USER: "/register/:username",
  PUT_BANUSER: "/ban_user/:email",
  PUT_BLACKLIST_USER: "/blacklist_user/:email",
  GET_RECOVERY_PASSWORD: "/forgot_password/:email",
  PUT_TOGGLE_SUBSCRIPTION: "/toggle_subscription/:email",
  REFRESH_TOKEN: "/refresh",

  // ONE REP MAX
  GET_ALL_ONE_REP_MAX_RECORDS: "/:username",
  GET_ONE_REP_MAX_BY_USER_AND_EXERCISE: "/:username/:exercise_name",
  PUT_ONE_REP_MAX: "/:username/:exercise_name",

  // PROGRAM BLOCK
  DELETE_PROGRAM_BLOCK: "/:username/:program_block_name",
  GET_ALL_PROGRAM_BLOCKS: "/:username",
  GET_PROGRAM_BLOCK: "/:username/:program_block_name",
  POST_NEXT_WORKOUT: "/:username/:program_block_name/next_workout",
  POST_PROGRAM_BLOCK: "/:username/:program_block_name",
  POST_RESET: "/:username/:program_block_name/reset",

  // PROGRAM
  GET_ALL_PROGRAMS: "/:username",

  // TAG
  GET_ALL_TAGS: "/",
  GET_TAG_BY_NAME: "/:tag_name",
  PUT_TAG: "/:tag_name",

  // USER
  GET_ALL_FOLLOWED_PROGRAM_NAMES: "/followed_workouts/programs/:username",
  GET_ALL_FOLLOWED_PROGRAMS_WORKOUTS: "/followed_workouts/program/workouts/:username/:program_name",
  GET_FOLLOW_SHARED_WORKOUTS: "/followed_workouts/:username/:shared_workout_id",
  GET_USER_BY_EMAIL: "/email/:email",
  GET_WALLET_ADDRESS: "/:username/wallet_address",
  PUT_WALLET_ADDRESS: "/:username/wallet_address",
  LIST_ALL_USERS: "/all",
  POST_FOLLOW_SHARED_WORKOUTS: "/followed_workouts/:username/:shared_workout_id",

  // WORKOUT_ PERFORMED
  GET_ALL_WORKOUT_DATES_FOR_USER: "/:username/dates",
  GET_ALL_WORKOUTS_FOR_USER_ON_DATE: "/:username/:date",
  GET_ALL_WORKOUTS_FOR_USER: "/:username/all",
  POST_WORKOUT_PERFORMED: "/:username",

  // WORKOUT_SHARED
  GET_ALL_SHARED_WORKOUT_USERNAMES: "/all/users",
  GET_ALL_SHARED_WORKOUTS: "/all",
  GET_SHARED_WORKOUT_BY_CATEGORY: "/category/:category",
  GET_SHARED_WORKOUT_BY_DIFFICULTY: "/difficulty/:difficulty",
  GET_SHARED_WORKOUT_BY_ID: "/id/:workout_id",
  GET_SHARED_WORKOUT_BY_INFO: "/info",
  GET_SHARED_WORKOUT_BY_NAME: "/name/:workout_name",
  GET_SHARED_WORKOUT_BY_TAGS: "/tags",
  GET_SHARED_WORKOUT_BY_USERNAME: "/username/:username",
  GET_SHARED_WORKOUT_COMMENTS: "/comments/:workout_id/:username",
  PUT_SHARED_WORKOUT_COMMENT: "/comments/:workout_id",
  PUT_SHARED_WORKOUT_DISLIKE: "/dislike/:workout_id/:username",
  PUT_SHARED_WORKOUT_LIKE: "/like/:workout_id/:username",
  PUT_SHARED_WORKOUT: "/workout/:username/:program_name/:workout_name",

  // WORKOUT
  DELETE_PROGRAM: "/:username/:program_name",
  DELETE_WORKOUT_BY_ID: "/:workoutId",
  GET_WORKOUT_BY_ID: "/id/:workout_id",
  GET_WORKOUT: "/:username/:program_name/:workout_name",
  GET_WORKOUTS_BY_PROGRAM_NAME: "/:username/:program_name",
  POST_WORKOUT: "/:username/:program_name/:workout_name",
  PUT_PROGRAM: "/:username/:program_name",
  PUT_WORKOUT: "/:username/:program_name/:workout_name",
};
