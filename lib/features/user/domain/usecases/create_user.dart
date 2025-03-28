import 'package:fitness_freaks/core/usecase/usecase.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for creating a new user
class CreateUser implements UseCase<UserEntity, UserEntity> {
  final UserRepository repository;

  CreateUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await repository.createUser(user);
  }
}
