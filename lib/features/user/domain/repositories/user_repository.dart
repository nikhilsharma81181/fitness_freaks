import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract class UserRepository {
  /// Gets the current user profile
  Future<Either<Failure, User>> getCurrentUser();

  /// Updates the user profile
  Future<Either<Failure, User>> updateUser(User user);

  /// Signs user in with email and password
  Future<Either<Failure, User>> signInWithEmailAndPassword(
    String email,
    String password,
  );

  /// Signs user up with email and password
  Future<Either<Failure, User>> signUpWithEmailAndPassword(
    String email,
    String password,
    String name,
  );

  /// Signs user out
  Future<Either<Failure, void>> signOut();

  /// Signs user in with Google
  Future<Either<Failure, User>> signInWithGoogle();
}
