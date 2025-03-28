import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'models/token_box.dart';
import 'models/user_box.dart';

/// Class for initializing Hive and registering adapters
class HiveSetup {
  /// Initialize Hive and register all adapters
  static Future<void> initialize() async {
    try {
      // Initialize Hive with a directory
      final appDocumentDirectory = await getApplicationDocumentsDirectory();
      await Hive.initFlutter(appDocumentDirectory.path);

      // Register adapters
      Hive.registerAdapter(TokenBoxAdapter());
      Hive.registerAdapter(UserBoxAdapter());

      debugPrint('Hive initialized with adapters');
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      // Handle initialization error
      rethrow;
    }
  }
}

/// Adapter for TokenBox
class TokenBoxAdapter extends TypeAdapter<TokenBox> {
  @override
  final int typeId = 1;

  @override
  TokenBox read(BinaryReader reader) {
    final accessToken = reader.readString();
    final hasRefreshToken = reader.readBool();
    final refreshToken = hasRefreshToken ? reader.readString() : null;
    final hasExpiryTime = reader.readBool();
    final expiryTime = hasExpiryTime 
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) 
        : null;
    final createdAt = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return TokenBox(
      accessToken: accessToken,
      refreshToken: refreshToken,
      expiryTime: expiryTime,
      createdAt: createdAt,
    );
  }

  @override
  void write(BinaryWriter writer, TokenBox obj) {
    writer.writeString(obj.accessToken);
    writer.writeBool(obj.refreshToken != null);
    if (obj.refreshToken != null) {
      writer.writeString(obj.refreshToken!);
    }
    writer.writeBool(obj.expiryTime != null);
    if (obj.expiryTime != null) {
      writer.writeInt(obj.expiryTime!.millisecondsSinceEpoch);
    }
    writer.writeInt(obj.createdAt.millisecondsSinceEpoch);
  }
}

/// Adapter for UserBox
class UserBoxAdapter extends TypeAdapter<UserBox> {
  @override
  final int typeId = 2;

  @override
  UserBox read(BinaryReader reader) {
    final hasFullName = reader.readBool();
    final fullName = hasFullName ? reader.readString() : null;
    
    final hasAddress = reader.readBool();
    final address = hasAddress ? reader.readString() : null;
    
    final hasCountry = reader.readBool();
    final country = hasCountry ? reader.readString() : null;
    
    final hasProfilePhoto = reader.readBool();
    final profilePhoto = hasProfilePhoto ? reader.readString() : null;
    
    final hasEmail = reader.readBool();
    final email = hasEmail ? reader.readString() : null;
    
    final hasPhoneNumber = reader.readBool();
    final phoneNumber = hasPhoneNumber ? reader.readString() : null;
    
    final hasDateOfBirth = reader.readBool();
    final dateOfBirth = hasDateOfBirth 
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) 
        : null;
    
    final hasGender = reader.readBool();
    final gender = hasGender ? reader.readInt() : null;
    
    final isActive = reader.readBool();
    final lastUpdated = DateTime.fromMillisecondsSinceEpoch(reader.readInt());

    return UserBox(
      fullName: fullName,
      address: address,
      country: country,
      profilePhoto: profilePhoto,
      email: email,
      phoneNumber: phoneNumber,
      dateOfBirth: dateOfBirth,
      gender: gender,
      isActive: isActive,
      lastUpdated: lastUpdated,
    );
  }

  @override
  void write(BinaryWriter writer, UserBox obj) {
    writer.writeBool(obj.fullName != null);
    if (obj.fullName != null) {
      writer.writeString(obj.fullName!);
    }
    
    writer.writeBool(obj.address != null);
    if (obj.address != null) {
      writer.writeString(obj.address!);
    }
    
    writer.writeBool(obj.country != null);
    if (obj.country != null) {
      writer.writeString(obj.country!);
    }
    
    writer.writeBool(obj.profilePhoto != null);
    if (obj.profilePhoto != null) {
      writer.writeString(obj.profilePhoto!);
    }
    
    writer.writeBool(obj.email != null);
    if (obj.email != null) {
      writer.writeString(obj.email!);
    }
    
    writer.writeBool(obj.phoneNumber != null);
    if (obj.phoneNumber != null) {
      writer.writeString(obj.phoneNumber!);
    }
    
    writer.writeBool(obj.dateOfBirth != null);
    if (obj.dateOfBirth != null) {
      writer.writeInt(obj.dateOfBirth!.millisecondsSinceEpoch);
    }
    
    writer.writeBool(obj.gender != null);
    if (obj.gender != null) {
      writer.writeInt(obj.gender!);
    }
    
    writer.writeBool(obj.isActive);
    writer.writeInt(obj.lastUpdated.millisecondsSinceEpoch);
  }
}
