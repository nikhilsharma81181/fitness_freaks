import 'package:hive/hive.dart';

part 'token_box.g.dart';

/// Hive model for storing authentication tokens
@HiveType(typeId: 1)
class TokenBox {
  @HiveField(0)
  final String accessToken;

  @HiveField(1)
  final String? refreshToken;

  @HiveField(2)
  final DateTime? expiryTime;

  @HiveField(3)
  final DateTime createdAt;

  TokenBox({
    required this.accessToken,
    this.refreshToken,
    this.expiryTime,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Check if the token is expired
  bool get isExpired {
    if (expiryTime == null) return false;
    return DateTime.now().isAfter(expiryTime!);
  }

  /// Create a copy of this token with updated fields
  TokenBox copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiryTime,
    DateTime? createdAt,
  }) {
    return TokenBox(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiryTime: expiryTime ?? this.expiryTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
