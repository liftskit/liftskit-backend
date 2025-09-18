import axios from 'axios';
import * as db from './db';

jest.mock('axios', () => ({
  ...jest.requireActual('axios'),
  delete: jest.fn(),
  get: jest.fn(),
  post: jest.fn(),
  put: jest.fn(),
}));

describe('db.js', () => {
  const accessToken = 'mockAccessToken';
  const category = 'category';
  const commentId = 'mockCommentId';
  const commentText = 'mockCommentText';
  const creator = 'mockCreator';
  const date = 'mockDate';
  const description = 'mockDescription';
  const difficulty = 'mockDifficulty';
  const email = 'mockEmail';
  const exerciseList = 'mockExerciseList';
  const exerciseName = 'mockExerciseName';
  const last_workout_complete = 'mockLastWorkoutComplete';
  const newTime = 'mockNewTime';
  const next_workout = 'mockNextWorkout';
  const next_workout_date = 'mockNextWorkoutDate';
  const oneRepMax = 'mockORM';
  const password = 'mockPassword';
  const program_block = 'mockProgramBlock';
  const program_block_name = 'mockProgramName';
  const programName = 'mockProgramName';
  const public_key = 'mockPublicKey';
  const refreshToken = 'mockRefreshToken';
  const tagsList = 'mockTagsList';
  const thumbnail_url = 'mockThumbnailUrl';
  const username = 'mockUsername';
  const workoutDate = 'mockWorkoutDate';
  const workoutId = 'mockWorkoutId';
  const workoutName = 'mockWorkoutName';
  const workoutTime = 'mockWorkoutTime';

  // const url = 'https://liftskit-db.herokuapp.com';
  const url = 'https://s0ipzddydc.execute-api.us-west-2.amazonaws.com/prod';

  beforeEach(() => {
    axios.delete.mockResolvedValue({data: 'mockData'});
    axios.get.mockResolvedValue({data: 'mockData'});
    axios.post.mockResolvedValue({data: 'mockData'});
    axios.put.mockResolvedValue({data: 'mockData'});
  });

  const testDBFunction = async (
    testFunction,
    args,
    options = {},
    testURL,
    method = 'GET',
  ) => {
    const result = testFunction(...args, options);

    if (method === 'POST') {
      expect(axios.post).toHaveBeenCalledWith(testURL);
    } else if (method === 'DELETE') {
      expect(axios.delete).toHaveBeenCalledWith(testURL);
    } else if (method === 'PUT') {
      expect(axios.delete).toHaveBeenCalledWith(testURL);
    } else {
      expect(axios.get).toHaveBeenCalledWith(testURL);
    }
    return result;
  };

  afterEach(jest.resetAllMocks);

  it('should call axios.get from checkBalance', () => {
    const fullURL = `${url}/check_balance/` + public_key;
    testDBFunction(db.checkBalance, [public_key], undefined, fullURL);
  });

  it('should call axios.post from createProgramBlock', () => {
    const fullURL = `${url}/program_block/${username}/${program_block_name}/`;
    const args = [
      username,
      program_block,
      program_block_name,
      description,
      last_workout_complete,
      next_workout,
      next_workout_date,
      accessToken,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        description: description,
        last_workout_complete: last_workout_complete,
        next_workout: next_workout,
        next_workout_date: next_workout_date,
        workouts: program_block,
      },
    };

    testDBFunction(db.createProgramBlock, args, options, fullURL, 'POST');
  });

  it('should call axios.post from createWorkout', async () => {
    const fullURL = `${url}/workouts/${username}/${programName}/${workoutName}/`;
    const args = [
      username,
      programName,
      workoutName,
      exerciseList,
      accessToken,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {exerciseList: exerciseList},
    };

    testDBFunction(db.createWorkout, args, options, fullURL, 'POST');
  });

  it('should call axios.delete from deleteProgramBlock', async () => {
    const fullURL = `${url}/program_block/${username}/${programName}/${workoutName}/`;
    const args = [username, programName, workoutName, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.deleteProgramBlock, args, options, fullURL, 'DELETE');
  });

  it('should call axios.delete from deleteWorkout', async () => {
    const fullURL = `${url}/workouts/${username}/${programName}/${workoutName}/`;
    const args = [username, programName, workoutName, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.deleteWorkout, args, options, fullURL, 'DELETE');
  });

  it('should call axios.get from getAllExercises', async () => {
    const fullURL = `${url}/exercises/`;
    const args = [accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllExercises, args, options, fullURL);
  });

  it('should call axios.get from getAllExercisesPerformed', async () => {
    const fullURL = `${url}/exercises/${username}/`;
    const args = [accessToken, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllExercisesPerformed, args, options, fullURL);
  });

  it('should call axios.get from getAllExercisesPerformedData', async () => {
    const fullURL = `${url}/exercises_performed/${username}/${exerciseName}/`;
    const args = [accessToken, exerciseName, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllExercisesPerformedData, args, options, fullURL);
  });

  it('should call axios.get from getAllProgramBlocks', async () => {
    const fullURL = `${url}/program_block/${username}/`;
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllProgramBlocks, args, options, fullURL);
  });

  it('should call axios.get from getAllTags', () => {
    const fullURL = `${url}/tags/`;
    const args = [accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllTags, args, options, fullURL);
  });

  it('should call axios.get from getAllWorkoutDays', async () => {
    const fullURL = `${url}/workouts_performed/${username}/dates/`;
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getAllWorkoutDays, args, options, fullURL);
  });

  it('should call axios.get from getCommentsOnComment', async () => {
    const fullURL = `${url}/comments/${workoutId}`;
    const args = [accessToken, commentId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getCommentsOnComment, args, options, fullURL);
  });

  it('should call axios.get from getFollowedProgramsList', () => {
    const fullURL = `${url}/users/followed_workouts/programs/${username}/`;
    const args = [accessToken, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getFollowedProgramsList, args, options, fullURL);
  });

  it('should call axios.get from getFollowedProgramWorkouts', () => {
    const fullURL = `${url}/users/followed_workouts/program/workouts/${username}/${programName}/`;
    const args = [accessToken, programName, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getFollowedProgramWorkouts, args, options, fullURL);
  });

  it('should call axios.get from getFollowedWorkoutsNames', () => {
    const fullURL = `${url}/users/followed_workouts/names/${username}/`;
    const args = [accessToken, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getFollowedWorkoutsNames, args, options, fullURL);
  });

  it('should call axios.get from getSelectedSingleWorkout', async () => {
    const fullURL = `${url}/workouts/${username}/${programName}/${workoutName}/`;
    const args = [username, programName, workoutName, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getSelectedSingleWorkout, args, options, fullURL);
  });

  it('should call axios.get from getSelectedSingleWorkout', async () => {
    const fullURL = `${url}/workouts/${username}/${programName}/${workoutName}/`;
    const args = [username, programName, workoutName];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getSelectedSingleWorkout, args, options, fullURL);
  });

  it('should call axios.get from getOneRepMax', async () => {
    const fullURL = `${url}/one_rep_max/${username}/${exerciseName}/`;
    const args = [username, exerciseName];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getOneRepMax, args, options, fullURL);
  });

  it('should call axios.get from getOneRepMaxDict', async () => {
    const fullURL = `${url}/one_rep_max/${username}/`;
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getOneRepMaxDict, args, options, fullURL);
  });

  it('should call axios.get from getProgramBlock', async () => {
    const fullURL = `${url}/program_block/${username}/${program_block_name}/`;
    const args = [username, program_block_name, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getProgramBlock, args, options, fullURL);
  });

  it('should call axios.get from getSelectedDateWorkouts', async () => {
    const fullURL = `${url}/workouts_performed/${username}/`;
    const args = [username, program_block_name, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
        ContentType: 'application/json',
      },
      data: {
        workout_date: workoutDate,
      },
    };

    testDBFunction(db.getSelectedDateWorkouts, args, options, fullURL);
  });

  it('should call axios.get from getSelectedWorkoutDay', async () => {
    const fullURL = `${url}/workouts_performed/${username}/${date}/`;
    const args = [username, date, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
        ContentType: 'application/json',
      },
      data: {
        workout_date: workoutDate,
      },
    };

    testDBFunction(db.getSelectedWorkoutDay, args, options, fullURL);
  });

  it('should call axios.get from getSharedWorkout', async () => {
    const fullURL = `${url}/workouts_shared/workout/${username}/${programName}/${workoutName}/`;
    const args = [accessToken, programName, username, workoutName];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
        ContentType: 'application/json',
      },
      data: {
        workout_date: workoutDate,
      },
    };

    testDBFunction(db.getSharedWorkout, args, options, fullURL);
  });

  it('should call axios.get from getSharedWorkoutById', async () => {
    const fullURL = `${url}/workouts_shared/id/${workoutId}/`;
    const args = [accessToken, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getSharedWorkoutById, args, options, fullURL);
  });

  it('should call axios.get from getSharedWorkoutComments', async () => {
    const fullURL = `${url}/comments/${workoutId}/`;
    const args = [accessToken, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getSharedWorkoutComments, args, options, fullURL);
  });

  it('should call axios.get from getSharedWorkoutLikeCount', async () => {
    const fullURL = `${url}/workouts_shared/likeCount/${workoutId}/`;
    const args = [accessToken, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
        ContentType: 'application/json',
      },
      data: {
        workout_date: workoutDate,
      },
    };

    testDBFunction(db.getSharedWorkoutLikeCount, args, options, fullURL);
  });

  it('should call axios.get from getUserBalance', async () => {
    const fullURL = `${url}/check_balance/` + public_key + '/';
    const args = [username, date, accessToken];
    const options = {};

    testDBFunction(db.getUserBalance, args, options, fullURL);
  });

  it('should call axios.get from getUserInfo', async () => {
    const fullURL = `${url}/register/` + username + '/';
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getUserInfo, args, options, fullURL);
  });

  it('should call axios.get from getUserPassword', async () => {
    const fullURL = `${url}/users/email/${username}/${email}/`;
    const args = [username, accessToken];
    const options = {
      headers: {
        ContentType: 'application/json',
      },
    };

    testDBFunction(db.getUserPassword, args, options, fullURL);
  });

  it('should call axios.get from getUserPrograms', async () => {
    const fullURL = `${url}/users/email/${username}/${email}/`;
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getUserPrograms, args, options, fullURL);
  });

  it('should call axios.get from getUserWorkouts', async () => {
    const fullURL = `${url}/users/email/${username}/${email}/`;
    const args = [username, programName, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getUserWorkouts, args, options, fullURL);
  });

  it('should call axios.get from getWalletAddress', async () => {
    const fullURL = `${url}/users/` + username + '/wallet_address/';
    const args = [username, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getWalletAddress, args, options, fullURL);
  });

  it('should call axios.get from getWorkoutByCreator', async () => {
    const fullURL = `${url}/workouts_shared/username/${creator}/`;
    const args = [accessToken, creator];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getWorkoutByCreator, args, options, fullURL);
  });

  it('should call axios.get from getWorkoutByTags', async () => {
    const fullURL = `${url}/workouts_shared/tags/`;
    const args = [accessToken, tagsList];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getWorkoutByTags, args, options, fullURL);
  });

  it('should call axios.get from getSharedWorkoutByName', async () => {
    const fullURL = `${url}/workouts_shared/name/${workoutName}/`;

    const args = [accessToken, workoutName];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getSharedWorkoutByName, args, options, fullURL);
  });

  it('should call axios.get from getWorkoutByCategory', async () => {
    const fullURL = `${url}/workouts_shared/category/${category}/`;
    const args = [accessToken, category];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.getWorkoutByCategory, args, options, fullURL);
  });

  it('should call axios.post from loginUser', async () => {
    const fullURL = `${url}/login/`;
    const args = [username, accessToken];
    const options = {
      data: {username: username, password: password},
    };

    testDBFunction(db.loginUser, args, options, fullURL, 'POST');
  });

  it('should call axios.post from payUserForWorkout', async () => {
    const fullURL = `${url}/request_payment/`;
    const args = [username, workoutTime, public_key, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        username: username,
        public_key: public_key,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.payUserForWorkout, args, options, fullURL, 'POST');
  });

  it('should call axios.post from postComment', async () => {
    const fullURL = `${url}/comments/${workoutId}/`;

    const args = [accessToken, commentText, username, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        username: username,
        public_key: public_key,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.postComment, args, options, fullURL, 'POST');
  });

  it('should call axios.post from postCurrentWorkout', async () => {
    const fullURL = `${url}/workouts_performed/${username}/`;
    const args = [
      username,
      programName,
      workoutName,
      workoutDate,
      exerciseList,
      workoutTime,
      accessToken,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.postCurrentWorkout, args, options, fullURL, 'POST');
  });

  it('should call axios.post from putUserDislikeComment', async () => {
    const fullURL = `${url}/comments/dislike/${commentId}/${username}/`;

    const args = [accessToken, username, commentId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.putUserDislikeComment, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from putUserDislikeWorkout', async () => {
    const fullURL = `${url}/workouts_shared/dislike/${workoutId}/${username}/`;

    const args = [accessToken, username, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.putUserDislikeWorkout, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from postUserFollowWorkout', async () => {
    const fullURL = `${url}/users/follow_workout/${username}/${workoutId}/`;

    const args = [accessToken, username, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.postUserFollowWorkout, args, options, fullURL, 'POST');
  });

  it('should call axios.put from putCommentOnComment', async () => {
    const fullURL = `${url}/comments/${commentId}`;

    const args = [accessToken, commentId, commentText, username];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        username,
        text: commentText,
      },
    };

    testDBFunction(db.putCommentOnComment, args, options, fullURL, 'PUT');
  });

  it('should call axios.put from putCommentOnSharedWorkout', async () => {
    const fullURL = `${url}/shared_workout/${workoutId}`;

    const args = [accessToken, commentText, username, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        username,
        text: commentText,
      },
    };

    testDBFunction(db.putCommentOnSharedWorkout, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from putUserLikeComment', async () => {
    const fullURL = `${url}/comments/like/${commentId}/${username}/`;

    const args = [accessToken, username, commentId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.putUserLikeComment, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from putUserLikeComment', async () => {
    const fullURL = `${url}/comments/like/${commentId}/${username}/`;

    const args = [accessToken, username, commentId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.putUserLikeComment, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from putUserLikeWorkout', async () => {
    const fullURL = `${url}/workouts_shared/like/${workoutId}/${username}/`;

    const args = [accessToken, username, workoutId];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        program_name: programName,
        workoutName: workoutName,
        workout_date: workoutDate,
        exerciseList: exerciseList,
        workoutTime: workoutTime,
      },
    };

    testDBFunction(db.putUserLikeWorkout, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from refreshAccessToken', async () => {
    const fullURL = `${url}/refresh/`;
    const args = [
      username,
      programName,
      workoutName,
      workoutDate,
      exerciseList,
      workoutTime,
      accessToken,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + refreshToken,
      },
    };

    testDBFunction(db.refreshAccessToken, args, options, fullURL, 'POST');
  });

  it('should call axios.put from setNextWorkout', async () => {
    const fullURL = `${url}/program_block/${username}/${program_block_name}/next_workout/`;
    const args = [
      username,
      program_block_name,
      last_workout_complete,
      next_workout,
      next_workout_date,
      accessToken,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        last_workout_complete: last_workout_complete,
        next_workout: next_workout,
        next_workout_date: next_workout_date,
      },
    };

    testDBFunction(db.setNextWorkout, args, options, fullURL, 'PUT');
  });

  it('should call axios.put from setOneRepMax', async () => {
    const fullURL = `${url}/one_rep_max/${username}/${exerciseName}/`;
    const args = [username, exerciseName, oneRepMax, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        one_rep_max: Number.parseFloat(oneRepMax),
      },
    };

    testDBFunction(db.setOneRepMax, args, options, fullURL, 'PUT');
  });

  it('should call axios.put from setWalletAddress', async () => {
    const fullURL = `${url}/users/` + username + '/wallet_address/';
    const args = [username, public_key, accessToken];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        public_key: public_key,
      },
    };

    testDBFunction(db.setWalletAddress, args, options, fullURL, 'PUT');
  });

  it('should call axios.put from shareWorkout', async () => {
    const fullURL = `${url}/workouts_shared/workout/${username}/${programName}/${workoutName}/`;
    const args = [
      accessToken,
      category,
      description,
      difficulty,
      exerciseList,
      programName,
      tagsList,
      thumbnail_url,
      username,
      workoutName,
    ];
    const options = {
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
      data: {
        public_key: public_key,
      },
    };

    testDBFunction(db.shareWorkout, args, options, fullURL, 'PUT');
  });

  it('should call axios.post from signupUser', async () => {
    const fullURL = `${url}/register/` + username + '/';
    const args = [username, password, email];
    const options = {
      data: {
        password: password,
        email: email,
      },
    };

    testDBFunction(db.signupUser, args, options, fullURL, 'POST');
  });

  it('should call axios.put from updateWorkoutTime', async () => {
    const fullURL = `${url}/workouts/${username}/${programName}/${workoutName}/`;
    const args = [username, password, email];
    const options = {
      data: {new_workout_time: newTime},
      headers: {
        Authorization: 'Bearer ' + accessToken,
      },
    };

    testDBFunction(db.updateWorkoutTime, args, options, fullURL, 'PUT');
  });
});
