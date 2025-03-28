import 'dart:developer';

import 'package:dio/dio.dart';

import '../../../../../core/constant/endpoints/endpoints.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/network_error_mapper.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/auth_token_model.dart';

abstract class AuthRemoteDataSource {
  /// Refresh token
  Future<AuthTokenModel> refreshToken(String refreshToken);
  
  /// Sign out
  Future<void> signOut();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;
  
  AuthRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<AuthTokenModel> refreshToken(String refreshToken) async {
    try {
      final response = await _apiClient.post(
        Endpoint.refreshToken,
        data: {'refreshToken': refreshToken},
      );
      
      log("Token refresh response: ${response.data}");
      
      if (response.data['token'] != null) {
        return AuthTokenModel.fromJson(response.data);
      } else {
        throw  ServerException('Failed to refresh token');
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }
  
  @override
  Future<void> signOut() async {
    try {
      await _apiClient.post(Endpoint.logout);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        // Already logged out or token expired, which is fine
        return;
      }
      throw handleDioException(e);
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
