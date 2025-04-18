import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';

/// UseCase to get cached weight entries
class GetCachedWeightEntries implements UseCase<List<WeightEntryEntity>, NoParams> {
  final WeightRepository repository;

  GetCachedWeightEntries(this.repository);

  @override
  Future<Either<Failure, List<WeightEntryEntity>>> call(NoParams params) async {
    return await repository.getCachedWeightEntries();
  }
}
