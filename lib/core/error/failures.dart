import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  
  const Failure({this.message = 'An unexpected error occurred'});
  
  @override
  List<Object> get props => [message];
}

// General failures
class ServerFailure extends Failure {
  const ServerFailure({String message = 'Server failure occurred'}) 
    : super(message: message);
}

class CacheFailure extends Failure {
  const CacheFailure({String message = 'Cache failure occurred'}) 
    : super(message: message);
}

class NetworkFailure extends Failure {
  const NetworkFailure({String message = 'Network failure occurred'}) 
    : super(message: message);
}
