import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  final int fitnessLevel;
  final List<String> goals;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImageUrl,
    required this.fitnessLevel,
    required this.goals,
  });

  @override
  List<Object> get props => [
    id,
    name,
    email,
    profileImageUrl,
    fitnessLevel,
    goals,
  ];
}
