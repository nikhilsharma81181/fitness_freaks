import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

class SignInUserParams extends Equatable {
  final String email;
  final String password;

  const SignInUserParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

class SignInUser {
  final UserRepository repository;

  SignInUser(this.repository);

  Future<Either<Failure, User>> call(SignInUserParams params) async {
    return await repository.signInWithEmailAndPassword(
      params.email,
      params.password,
    );
  }
}
