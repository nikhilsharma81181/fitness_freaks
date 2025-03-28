import 'package:flutter/foundation.dart';
import '../../domain/entities/auth_token.dart';

/// Model for authentication tokens in the data layer
class AuthTokenModel extends AuthToken {
  AuthTokenModel({
    required super.accessToken,
    super.refreshToken,
    super.expiryTime,
    super.createdAt,
  });

  /// Create from JSON
  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    DateTime? expiryTime;

    if (json['expiresIn'] != null) {
      // If expiresIn is provided as seconds
      final expiresInSeconds = json['expiresIn'] is int
          ? json['expiresIn'] as int
          : int.tryParse(json['expiresIn'].toString()) ?? 0;

      if (expiresInSeconds > 0) {
        expiryTime = DateTime.now().add(Duration(seconds: expiresInSeconds));
      }
    } else if (json['expiryTime'] != null) {
      // If expiryTime is provided as ISO string
      try {
        expiryTime = DateTime.parse(json['expiryTime'].toString());
      } catch (e) {
        debugPrint('Error parsing expiryTime: $e');
      }
    }

    return AuthTokenModel(
      accessToken: json['token'] != null
          ? json['token'].toString()
          : (json['accessToken'] ?? '').toString(),
      refreshToken: json['refreshToken']?.toString(),
      expiryTime: expiryTime,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'].toString())
          : DateTime.now(),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'expiryTime': expiryTime?.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create a copy with updated fields
  @override
  AuthTokenModel copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiryTime,
    DateTime? createdAt,
  }) {
    return AuthTokenModel(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiryTime: expiryTime ?? this.expiryTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
