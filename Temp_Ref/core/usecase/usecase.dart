import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import '../error/failures.dart';

/// Base use case interface for all use cases
abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call(Params params);
}

/// No parameters for use cases that don't require parameters
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}
