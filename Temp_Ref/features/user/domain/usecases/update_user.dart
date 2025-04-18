import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for updating the user
class UpdateUser implements UseCase<UserEntity, UserEntity> {
  final UserRepository repository;

  UpdateUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(UserEntity user) async {
    return await repository.updateUser(user);
  }
}
