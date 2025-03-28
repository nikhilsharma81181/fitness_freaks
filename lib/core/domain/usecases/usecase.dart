import 'package:equatable/equatable.dart';

import '../entities/either.dart';
import '../failures/failure.dart';

/// A base abstract class for all use cases in the application.
///
/// [Type] is the return type of the use case.
/// [Params] is the input parameters for the use case.
abstract class UseCase<Type, Params> {
  /// Call method to be implemented by concrete use cases.
  /// This makes a use case callable like a function.
  Future<Either<Failure, Type>> call(Params params);
}

/// Utility class for use cases that don't require any parameters.
class NoParams extends Equatable {
  @override
  List<Object> get props => [];
}

/// Utility class for use cases that require ID parameter.
class IdParams extends Equatable {
  final String id;

  const IdParams({required this.id});

  @override
  List<Object> get props => [id];
}

/// Utility class for use cases that require paging parameters.
class PagingParams extends Equatable {
  final int page;
  final int pageSize;

  const PagingParams({
    this.page = 1,
    this.pageSize = 20,
  });

  @override
  List<Object> get props => [page, pageSize];
}

/// Utility class for use cases that require filtering parameters.
class FilterParams extends Equatable {
  final Map<String, dynamic> filters;

  const FilterParams({
    this.filters = const {},
  });

  @override
  List<Object> get props => [filters];
}

/// A base abstract class for stream-based use cases.
abstract class StreamUseCase<Type, Params> {
  /// Call method to be implemented by concrete use cases.
  Stream<Either<Failure, Type>> call(Params params);
}
