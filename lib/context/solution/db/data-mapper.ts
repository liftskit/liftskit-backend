import {
  ElixirUser,
} from './types/auth';
import {
  User,
} from './types/user';
import {
  ElixirExerciseRoot,
  ElixirExercise,
  ElixirExercisePerformed,
  ExerciseRoot,
  Exercise,
  ExercisePerformed,
} from './types/exercise';
import {
  ElixirWorkout,
  ElixirWorkoutPerformed,
  Workout,
  WorkoutPerformed,
} from './types/workout';
import {
  ElixirProgram,
  Program,
} from './types/program';
import {
  ElixirOneRepMax,
  OneRepMax,
} from './types/one-rep-max';

export class DataMapper {
  // Convert Elixir User to frontend User
  static mapUser(elixirUser: ElixirUser): User {
    return {
      id: elixirUser.id.toString(),
      username: elixirUser.username,
      email: elixirUser.email,
    };
  }

  // Convert Elixir ExerciseRoot to frontend ExerciseRoot
  static mapExerciseRoot(elixirExerciseRoot: ElixirExerciseRoot): ExerciseRoot {
    return {
      id: elixirExerciseRoot.id.toString(),
      name: elixirExerciseRoot.name,
      _type: elixirExerciseRoot._type,
    };
  }

  // Convert Elixir Exercise to frontend Exercise
  static mapExercise(elixirExercise: ElixirExercise): Exercise {
    return {
      id: elixirExercise.id.toString(),
      orm_percent: elixirExercise.orm_percent,
      reps: elixirExercise.reps,
      sets: elixirExercise.sets,
      time: elixirExercise.time,
      weight: elixirExercise.weight,
      is_superset: elixirExercise.is_superset,
      exercise_root: this.mapExerciseRoot(elixirExercise.exercise_root),
      workout_id: elixirExercise.workout_id.toString(),
    };
  }

  // Convert Elixir Workout to frontend Workout
  static mapWorkout(elixirWorkout: ElixirWorkout): Workout {
    return {
      id: elixirWorkout.id.toString(),
      name: elixirWorkout.name,
      best_workout_time: elixirWorkout.best_workout_time,
      program_id: elixirWorkout.program_id.toString(),
      exercises: elixirWorkout.exercises.map(ex => this.mapExercise(ex)),
    };
  }

  // Convert Elixir Program to frontend Program
  static mapProgram(elixirProgram: ElixirProgram): Program {
    return {
      id: elixirProgram.id.toString(),
      name: elixirProgram.name,
      user_id: elixirProgram.user_id.toString(),
    };
  }

  // Convert Elixir ExercisePerformed to frontend ExercisePerformed
  static mapExercisePerformed(elixirExercisePerformed: ElixirExercisePerformed): ExercisePerformed {
    return {
      id: elixirExercisePerformed.id.toString(),
      exercise_root_id: elixirExercisePerformed.exercise_root_id.toString(),
      workout_performed_id: elixirExercisePerformed.workout_performed_id.toString(),
      sets: elixirExercisePerformed.sets,
      reps: elixirExercisePerformed.reps,
      weight: elixirExercisePerformed.weight,
      time: elixirExercisePerformed.time,
      orm_percent: elixirExercisePerformed.orm_percent,
      exercise_root: this.mapExerciseRoot(elixirExercisePerformed.exercise_root),
    };
  }

  // Convert Elixir WorkoutPerformed to frontend WorkoutPerformed
  static mapWorkoutPerformed(elixirWorkoutPerformed: ElixirWorkoutPerformed): WorkoutPerformed {
    return {
      id: elixirWorkoutPerformed.id.toString(),
      user_id: elixirWorkoutPerformed.user_id.toString(),
      workout_id: elixirWorkoutPerformed.workout_id.toString(),
      date: elixirWorkoutPerformed.date,
      exercises_performed: elixirWorkoutPerformed.exercises_performed.map(ex => this.mapExercisePerformed(ex)),
    };
  }

  // Convert Elixir OneRepMax to frontend OneRepMax
  static mapOneRepMax(elixirOneRepMax: ElixirOneRepMax): OneRepMax {
    return {
      id: elixirOneRepMax.id.toString(),
      user_id: elixirOneRepMax.user_id.toString(),
      exercise_root_id: elixirOneRepMax.exercise_root_id.toString(),
      weight: elixirOneRepMax.weight,
      exercise_root: this.mapExerciseRoot(elixirOneRepMax.exercise_root),
    };
  }

  // Convert arrays of Elixir entities to frontend arrays
  static mapUsers(elixirUsers: ElixirUser[]): User[] {
    return elixirUsers.map(user => this.mapUser(user));
  }

  static mapExerciseRoots(elixirExerciseRoots: ElixirExerciseRoot[]): ExerciseRoot[] {
    return elixirExerciseRoots.map(root => this.mapExerciseRoot(root));
  }

  static mapExercises(elixirExercises: ElixirExercise[]): Exercise[] {
    return elixirExercises.map(ex => this.mapExercise(ex));
  }

  static mapWorkouts(elixirWorkouts: ElixirWorkout[]): Workout[] {
    return elixirWorkouts.map(workout => this.mapWorkout(workout));
  }

  static mapPrograms(elixirPrograms: ElixirProgram[]): Program[] {
    return elixirPrograms.map(program => this.mapProgram(program));
  }

  static mapExercisesPerformed(elixirExercisesPerformed: ElixirExercisePerformed[]): ExercisePerformed[] {
    return elixirExercisesPerformed.map(ex => this.mapExercisePerformed(ex));
  }

  static mapWorkoutsPerformed(elixirWorkoutsPerformed: ElixirWorkoutPerformed[]): WorkoutPerformed[] {
    return elixirWorkoutsPerformed.map(workout => this.mapWorkoutPerformed(workout));
  }

  static mapOneRepMaxes(elixirOneRepMaxes: ElixirOneRepMax[]): OneRepMax[] {
    return elixirOneRepMaxes.map(orm => this.mapOneRepMax(orm));
  }
}
