import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';

/// Params for uploading weight from image
class UploadWeightFromImageParams {
  final String imageBase64;

  UploadWeightFromImageParams({required this.imageBase64});
}

/// UseCase to upload a weight entry with an image
class UploadWeightFromImage implements UseCase<WeightEntryEntity, UploadWeightFromImageParams> {
  final WeightRepository repository;

  UploadWeightFromImage(this.repository);

  @override
  Future<Either<Failure, WeightEntryEntity>> call(UploadWeightFromImageParams params) async {
    return await repository.uploadWeightFromImage(params.imageBase64);
  }
}
