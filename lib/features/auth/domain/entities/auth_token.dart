import 'package:equatable/equatable.dart';

/// Entity representing authentication tokens
class AuthToken extends Equatable {
  final String accessToken;
  final String? refreshToken;
  final DateTime? expiryTime;
  final DateTime createdAt;

  AuthToken({
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

  /// Create a copy with updated fields
  AuthToken copyWith({
    String? accessToken,
    String? refreshToken,
    DateTime? expiryTime,
    DateTime? createdAt,
  }) {
    return AuthToken(
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiryTime: expiryTime ?? this.expiryTime,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [accessToken, refreshToken, expiryTime, createdAt];
}
