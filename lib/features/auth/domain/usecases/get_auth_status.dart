import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for getting the current authentication status
class GetAuthStatus implements UseCase<bool, NoParams> {
  final AuthRepository repository;
  
  GetAuthStatus(this.repository);
  
  @override
  Future<Either<Failure, bool>> call(NoParams params) async {
    return await repository.isAuthenticated();
  }
}
