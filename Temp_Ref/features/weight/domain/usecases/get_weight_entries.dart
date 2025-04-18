import 'package:fpdart/fpdart.dart';
import 'package:fitness_freaks/core/error/failures.dart';
import 'package:fitness_freaks/core/usecase/usecase.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fitness_freaks/features/weight/domain/repositories/weight_repository.dart';

/// UseCase to get all weight entries for the current user
class GetWeightEntries implements UseCase<List<WeightEntryEntity>, NoParams> {
  final WeightRepository repository;

  GetWeightEntries(this.repository);

  @override
  Future<Either<Failure, List<WeightEntryEntity>>> call(NoParams params) async {
    return await repository.getWeightEntries();
  }
}
