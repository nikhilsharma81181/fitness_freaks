import 'package:hive/hive.dart';

import '../../../features/user/domain/entities/user.dart';

part 'user_box.g.dart';

/// Hive model for storing user data
@HiveType(typeId: 2)
class UserBox {
  @HiveField(0)
  final String? fullName;

  @HiveField(1)
  final String? address;

  @HiveField(2)
  final String? country;

  @HiveField(3)
  final String? profilePhoto;

  @HiveField(4)
  final String? email;

  @HiveField(5)
  final String? phoneNumber;

  @HiveField(6)
  final DateTime? dateOfBirth;

  @HiveField(7)
  final int? gender;

  @HiveField(8)
  final bool isActive;

  @HiveField(9)
  final DateTime lastUpdated;

  UserBox({
    this.fullName,
    this.address,
    this.country,
    this.profilePhoto,
    this.email,
    this.phoneNumber,
    this.dateOfBirth,
    this.gender,
    this.isActive = true,
    DateTime? lastUpdated,
  }) : lastUpdated = lastUpdated ?? DateTime.now();

  /// Convert from domain entity
  factory UserBox.fromEntity(UserEntity user) {
    return UserBox(
      fullName: user.fullName,
      address: user.address,
      country: user.country,
      profilePhoto: user.profilePhoto,
      email: user.email,
      phoneNumber: user.phoneNumber,
      dateOfBirth: user.dateOfBirth,
      gender: user.gender?.index,
      isActive: user.isActive,
    );
  }

  /// Convert to domain entity
  UserEntity toEntity() {
    Gender? genderEnum;
    if (gender != null) {
      genderEnum = Gender.values[gender!];
    }

    return UserEntity(
      fullName: fullName,
      address: address,
      country: country,
      profilePhoto: profilePhoto,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: genderEnum,
      isActive: isActive,
    );
  }
}
