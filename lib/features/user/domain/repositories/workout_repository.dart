import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/entities/workout.dart';
import 'package:fpdart/fpdart.dart';

abstract class WorkoutRepository {
  /// Gets a list of all workouts
  Future<Either<Failure, List<Workout>>> getWorkouts();
  
  /// Gets a specific workout by ID
  Future<Either<Failure, Workout>> getWorkoutById(String id);
  
  /// Gets workouts by category
  Future<Either<Failure, List<Workout>>> getWorkoutsByCategory(String category);
  
  /// Gets favorite workouts
  Future<Either<Failure, List<Workout>>> getFavoriteWorkouts();
  
  /// Adds workout to favorites
  Future<Either<Failure, bool>> addToFavorites(String workoutId);
  
  /// Removes workout from favorites
  Future<Either<Failure, bool>> removeFromFavorites(String workoutId);
} 