import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/auth_repository.dart';

/// Use case for signing out
class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;
  
  SignOut(this.repository);
  
  @override
  Future<Either<Failure, void>> call(NoParams params) async {
    return await repository.signOut();
  }
}
