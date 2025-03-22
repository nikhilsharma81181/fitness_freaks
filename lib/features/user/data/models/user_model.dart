import 'package:fitness_freaks/features/user/domain/entities/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;

class UserModel extends User {
  const UserModel({
    required String id,
    required String name,
    required String email,
    required String profileImageUrl,
    required int fitnessLevel,
    required List<String> goals,
  }) : super(
         id: id,
         name: name,
         email: email,
         profileImageUrl: profileImageUrl,
         fitnessLevel: fitnessLevel,
         goals: goals,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'] ?? '',
      fitnessLevel: json['fitness_level'] ?? 1,
      goals: List<String>.from(json['goals'] ?? []),
    );
  }

  factory UserModel.fromFirebase(firebase_auth.User firebaseUser) {
    return UserModel(
      id: firebaseUser.uid,
      name: firebaseUser.displayName ?? 'New User',
      email: firebaseUser.email ?? '',
      profileImageUrl: firebaseUser.photoURL ?? '',
      fitnessLevel: 1, // Default value
      goals: [], // Default empty goals
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profile_image_url': profileImageUrl,
      'fitness_level': fitnessLevel,
      'goals': goals,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    int? fitnessLevel,
    List<String>? goals,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      goals: goals ?? this.goals,
    );
  }
}
