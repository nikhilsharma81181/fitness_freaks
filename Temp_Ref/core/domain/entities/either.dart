/// Note: This is a simplified Either implementation.
/// In a real project, consider using the fpdart package which provides a more robust
/// implementation with additional utility methods.
///
/// A type that represents a value of one of two possible types (a disjoint union).
/// Instances of [Either] are either an instance of [Left] or [Right].
///
/// [Left] is typically used for failures.
/// [Right] is typically used for successes.
abstract class Either<L, R> {
  const Either();

  /// Returns true if this is a [Left], false otherwise.
  bool get isLeft;

  /// Returns true if this is a [Right], false otherwise.
  bool get isRight;

  /// If this is a [Left], returns the left value.
  /// Otherwise throws an [Exception].
  L get left;

  /// If this is a [Right], returns the right value.
  /// Otherwise throws an [Exception].
  R get right;

  /// Maps the right value using the given function.
  Either<L, T> map<T>(T Function(R right) f);

  /// Maps the left value using the given function.
  Either<T, R> mapLeft<T>(T Function(L left) f);

  /// Folds the [Either] into a single value by applying either
  /// [ifLeft] or [ifRight] depending on the type.
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight);
}

/// The left side of an [Either]. Typically used for failures.
class Left<L, R> extends Either<L, R> {
  final L value;
  const Left(this.value);

  @override
  bool get isLeft => true;

  @override
  bool get isRight => false;

  @override
  L get left => value;

  @override
  R get right => throw Exception('Cannot get right value from Left');

  @override
  Either<L, T> map<T>(T Function(R right) f) {
    return Left<L, T>(value);
  }

  @override
  Either<T, R> mapLeft<T>(T Function(L left) f) {
    return Left<T, R>(f(value));
  }

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifLeft(value);
  }

  @override
  bool operator ==(Object other) {
    return other is Left && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Left($value)';
}

/// The right side of an [Either]. Typically used for successes.
class Right<L, R> extends Either<L, R> {
  final R value;
  const Right(this.value);

  @override
  bool get isLeft => false;

  @override
  bool get isRight => true;

  @override
  L get left => throw Exception('Cannot get left value from Right');

  @override
  R get right => value;

  @override
  Either<L, T> map<T>(T Function(R right) f) {
    return Right<L, T>(f(value));
  }

  @override
  Either<T, R> mapLeft<T>(T Function(L left) f) {
    return Right<T, R>(value);
  }

  @override
  T fold<T>(T Function(L left) ifLeft, T Function(R right) ifRight) {
    return ifRight(value);
  }

  @override
  bool operator ==(Object other) {
    return other is Right && other.value == value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Right($value)';
}
