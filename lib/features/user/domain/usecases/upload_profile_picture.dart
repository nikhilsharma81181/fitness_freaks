import 'dart:io';
import 'package:fpdart/fpdart.dart';

import '../../../../core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import '../entities/user.dart';
import '../repositories/user_repository.dart';

/// Use case for uploading a profile picture
class UploadProfilePicture implements UseCase<UserEntity, File> {
  final UserRepository repository;

  UploadProfilePicture(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(File file) async {
    return await repository.uploadProfilePicture(file);
  }
}
