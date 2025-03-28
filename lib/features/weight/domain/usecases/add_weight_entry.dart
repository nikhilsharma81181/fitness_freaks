import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';

/// Params for adding a weight entry manually
class AddWeightEntryParams {
  final double weight;
  final String date;

  AddWeightEntryParams({
    required this.weight,
    required this.date,
  });
}

/// UseCase to add a new weight entry manually
class AddWeightEntry implements UseCase<WeightEntryEntity, AddWeightEntryParams> {
  final WeightRepository repository;

  AddWeightEntry(this.repository);

  @override
  Future<Either<Failure, WeightEntryEntity>> call(AddWeightEntryParams params) async {
    return await repository.addWeightEntry(params.weight, params.date);
  }
}
