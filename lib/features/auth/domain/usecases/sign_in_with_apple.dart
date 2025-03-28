import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with Apple
class SignInWithApple implements UseCase<AuthToken, NoParams> {
  final AppleAuthRepository repository;
  
  SignInWithApple(this.repository);
  
  @override
  Future<Either<Failure, AuthToken>> call(NoParams params) async {
    return await repository.signInWithApple();
  }
}
