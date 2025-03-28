import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import '../../../../../core/constant/endpoints/endpoints.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/error/network_error_mapper.dart';
import '../../../../../core/network/api_client.dart';
import '../../models/user_model.dart';

abstract class UserRemoteDataSource {
  /// Create a new user
  Future<UserModel> createUser(UserModel user);
  
  /// Get current user
  Future<UserModel> getUser();
  
  /// Update user
  Future<UserModel> updateUser(UserModel user);
  
  /// Upload profile picture
  Future<UserModel> uploadProfilePicture(File imageFile);
  
  /// Delete user
  Future<void> deleteUser();
}

class UserRemoteDataSourceImpl implements UserRemoteDataSource {
  final ApiClient _apiClient;
  
  UserRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<UserModel> createUser(UserModel user) async {
    try {
      final Map<String, dynamic> data = {
        "fullName": user.fullName,
        "email": user.email == "" ? null : user.email,
        "phoneNumber": user.phoneNumber == "" ? null : user.phoneNumber,
        "profilePhoto": user.profilePhoto,
      };
      
      log('Creating user with data: ${data.toString()}');
      
      final response = await _apiClient.post(
        Endpoint.createUser,
        data: data,
      );
      
      log('Create user response: ${response.data.toString()}');
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else {
        throw ServerException(
          'Failed to create user: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      log('DioException in createUser: ${e.message}');
      throw handleDioException(e);
    } catch (e) {
      log('Unexpected error in createUser: $e');
      throw ServerException('An unexpected error occurred: $e');
    }
  }
  
  @override
  Future<UserModel> getUser() async {
    try {
      final response = await _apiClient.get(Endpoint.getUser);
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException('User not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to get user: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
  
  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      log("Updating user with data: ${user.toJson()}");
      
      final response = await _apiClient.put(
        Endpoint.updateUser,
        data: user.toJson(),
      );
      
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException('User not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to update user: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
  
  @override
  Future<UserModel> uploadProfilePicture(File imageFile) async {
    try {
      String fileName = imageFile.path.split('/').last;
      
      FormData formData = FormData.fromMap({
        "image": await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });
      
      Response response = await _apiClient.post(
        Endpoint.uploadProfilePicture,
        data: formData,
      );
      
      if (response.statusCode == 200) {
        log('Profile picture uploaded successfully!');
        return UserModel.fromJson(response.data);
      } else if (response.statusCode == 404) {
        throw ServerException('User not found', statusCode: 404);
      } else {
        throw ServerException(
          'Failed to upload profile picture: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
  
  @override
  Future<void> deleteUser() async {
    try {
      final response = await _apiClient.delete(Endpoint.deleteUser);
      
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw ServerException(
          'Failed to delete user: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioException(e);
    } catch (e) {
      throw ServerException('An unexpected error occurred: $e');
    }
  }
}
