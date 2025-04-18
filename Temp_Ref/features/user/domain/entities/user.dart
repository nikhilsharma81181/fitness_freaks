import 'package:equatable/equatable.dart';

/// Gender enum for user profile
enum Gender {
  MALE,
  FEMALE,
}

/// User entity representing a user in the domain layer
class UserEntity extends Equatable {
  final String? fullName;
  final String? address;
  final String? country;
  final String? profilePhoto;
  final String? email;
  final String? phoneNumber;
  final DateTime? dateOfBirth;
  final Gender? gender;
  final bool isActive;
  
  const UserEntity({
    this.fullName,
    this.address,
    this.country,
    this.profilePhoto,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.isActive = true,
  });
  
  /// Factory constructor for creating a new user
  factory UserEntity.create({
    String? fullName,
    String? address,
    String? country,
    String? profilePhoto,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Gender? gender,
    bool isActive = true,
  }) {
    return UserEntity(
      fullName: fullName,
      address: address,
      country: country,
      profilePhoto: profilePhoto,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      isActive: isActive,
    );
  }
  
  /// Create a copy of this user with updated fields
  UserEntity copyWith({
    String? fullName,
    String? address,
    String? country,
    String? profilePhoto,
    String? email,
    String? phoneNumber,
    DateTime? dateOfBirth,
    Gender? gender,
    bool? isActive,
  }) {
    return UserEntity(
      fullName: fullName ?? this.fullName,
      address: address ?? this.address,
      country: country ?? this.country,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      isActive: isActive ?? this.isActive,
    );
  }
  
  @override
  List<Object?> get props => [
    fullName,
    address,
    country,
    profilePhoto,
    email,
    phoneNumber,
    dateOfBirth,
    gender,
    isActive,
  ];
}
