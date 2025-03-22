import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';

class SignOutUser {
  final UserRepository repository;

  SignOutUser(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
