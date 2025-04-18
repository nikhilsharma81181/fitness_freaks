import 'dart:developer' as developer;

import '../../domain/entities/user.dart';

/// User model for data layer operations
class UserModel extends UserEntity {
  UserModel({
    super.fullName,
    super.address,
    super.country,
    super.profilePhoto,
    super.email,
    super.phoneNumber,
    super.dateOfBirth,
    super.gender,
    super.isActive,
  }) {
    developer.log("Creating UserModel instance. Date of birth: $dateOfBirth");
  }
  
  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    developer.log("Creating UserModel from JSON: $json");
    
    Gender? gender;
    if (json['gender'] != null) {
      try {
        gender = Gender.values.firstWhere(
          (e) => e.toString() == 'Gender.${json['gender']}',
        );
      } catch (e) {
        developer.log('Error parsing gender: $e');
      }
    }
    
    final model = UserModel(
      fullName: json['fullName'],
      address: json['address'],
      country: json['country'],
      profilePhoto: json['profilePhoto'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(json['dateOfBirth'])
          : null,
      gender: gender,
      isActive: json['isActive'] ?? true,
    );
    
    developer.log("Created UserModel. Date of birth: ${model.dateOfBirth}");
    
    return model;
  }
  
  /// Convert to JSON
  Map<String, dynamic> toJson() {
    developer.log("Converting UserModel to JSON. Date of birth: $dateOfBirth");
    
    final json = {
      'fullName': fullName,
      'address': address,
      'country': country,
      'profilePhoto': profilePhoto,
      'email': email,
      'phoneNumber': phoneNumber,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'gender': gender?.toString().split('.').last,
      'isActive': isActive,
    };
    
    // Remove null values
    json.removeWhere((key, value) => value == null);
    
    developer.log("Final JSON: $json");
    
    return json;
  }
  
  /// Create a copy of this model with updated fields
  UserModel copyWith({
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
    return UserModel(
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
}
