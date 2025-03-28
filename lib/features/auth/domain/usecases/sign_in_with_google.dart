import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/auth_token.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing in with Google
class SignInWithGoogle implements UseCase<AuthToken, NoParams> {
  final GoogleAuthRepository repository;
  
  SignInWithGoogle(this.repository);
  
  @override
  Future<Either<Failure, AuthToken>> call(NoParams params) async {
    return await repository.signInWithGoogle();
  }
}
