import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignInWithGoogle {
  final UserRepository repository;

  SignInWithGoogle(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
