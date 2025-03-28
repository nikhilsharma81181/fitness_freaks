import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for refreshing the authentication token
class RefreshToken implements UseCase<AuthToken, NoParams> {
  final AuthRepository repository;
  
  RefreshToken(this.repository);
  
  @override
  Future<Either<Failure, AuthToken>> call(NoParams params) async {
    return await repository.refreshToken();
  }
}
