import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:fitness_freaks/features/user/domain/repositories/user_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:equatable/equatable.dart';

class SignUpUserParams extends Equatable {
  final String email;
  final String password;
  final String name;

  const SignUpUserParams({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object> get props => [email, password, name];
}

class SignUpUser {
  final UserRepository repository;

  SignUpUser(this.repository);

  Future<Either<Failure, User>> call(SignUpUserParams params) async {
    return await repository.signUpWithEmailAndPassword(
      params.email,
      params.password,
      params.name,
    );
  }
}
