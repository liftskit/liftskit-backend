export const ELIXIR_ROUTES = {
  // Authentication
  SIGNIN: "/api/signin",
  SIGNUP: "/api/signup",

  // Users
  USERS: "/api/users",
  USER_BY_ID: "/api/users/:id",
  USER_SEARCH: "/api/users/search",

  // Official Exercises
  OFFICIAL_EXERCISES: "/api/official_exercises",
  OFFICIAL_EXERCISE_BY_ID: "/api/official_exercises/:id",

  // Exercise Roots
  EXERCISE_ROOTS: "/api/exercise_roots",
  EXERCISE_ROOT_BY_ID: "/api/exercise_roots/:id",

  // Exercises
  EXERCISES: "/api/exercises",
  EXERCISE_BY_ID: "/api/exercises/:id",

  // Programs
  PROGRAMS: "/api/programs",
  PROGRAM_BY_ID: "/api/programs/:id",

  // Workouts
  WORKOUTS: "/api/workouts",
  WORKOUT_BY_ID: "/api/workouts/:id",

  // Exercises Performed
  EXERCISES_PERFORMED: "/api/exercises_performed",
  EXERCISE_PERFORMED_BY_ID: "/api/exercises_performed/:id",

  // Workouts Performed
  WORKOUTS_PERFORMED: "/api/workouts_performed",
  WORKOUT_PERFORMED_BY_ID: "/api/workouts_performed/:id",

  // One Rep Maxes
  ONE_REP_MAXES: "/api/one_rep_maxes",
  ONE_REP_MAX_BY_ID: "/api/one_rep_maxes/:id",

  // Tags
  TAGS: "/api/tags",
  TAG_BY_ID: "/api/tags/:id",

  // Rooms (for messaging)
  ROOMS: "/api/rooms",
  ROOM_BY_ID: "/api/rooms/:id",

  // Messages
  MESSAGES: "/api/messages",
  MESSAGE_BY_ID: "/api/messages/:id",
  USER_CONVERSATIONS: "/api/users/:user_id/conversations",
};

// Helper function to build paths with parameters
export const buildElixirPath = (route: string, params: Record<string, string | number> = {}): string => {
  let path = route;
  
  Object.entries(params).forEach(([key, value]) => {
    path = path.replace(`:${key}`, value.toString());
  });
  
  return path;
};
