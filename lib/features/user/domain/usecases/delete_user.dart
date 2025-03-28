import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/user_repository.dart';

/// Use case for deleting the user
class DeleteUser implements UseCase<void, NoParams> {
  final UserRepository repository;
  
  DeleteUser(this.repository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.deleteUser();
  }
}
