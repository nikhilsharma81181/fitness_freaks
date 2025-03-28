import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for getting the current user
class GetUser implements UseCase<UserEntity, NoParams> {
  final UserRepository repository;
  
  GetUser(this.repository);
  
  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.getUser();
  }
}
