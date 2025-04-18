import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:fitness_freaks/core/constant/endpoints/endpoints.dart';
import 'package:fitness_freaks/core/constants/endpoints.dart';
import 'package:fitness_freaks/core/error/exceptions.dart';
import 'package:fitness_freaks/features/weight/data/datasources/weight_remote_data_source.dart';
import 'package:fitness_freaks/features/weight/data/models/weight_entry_model.dart';

/// Implementation of the remote data source for weight entries
class WeightRemoteDataSourceImpl implements WeightRemoteDataSource {
  final Dio dio;

  WeightRemoteDataSourceImpl({required this.dio});

  @override
  Future<WeightEntryModel> addWeightEntry(double weight, String date) async {
    try {
      final response = await dio.post(
        Endpoint.weights,
        data: {
          'weight': weight,
          'date': date,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return WeightEntryModel.fromJson(response.data['data']);
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to add weight entry',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<WeightEntryModel>> getWeightEntries() async {
    try {
      final response = await dio.get(Endpoint.weights);

      if (response.statusCode == 200) {
        final responseModel = WeightDataResponseModel.fromJson(response.data);
        return responseModel.data;
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to fetch weight entries',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<WeightEntryModel> uploadWeightFromImage(String imageBase64) async {
    try {
      final response = await dio.post(
        Endpoint.weightUpload,
        data: {
          'imageBase64': imageBase64,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final uploadResponse = UploadWeightResponseModel.fromJson(response.data);
        return uploadResponse.data;
      } else {
        throw ServerException(
          response.data['message'] ?? 'Failed to upload weight image',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data?['message'] ?? 'Network error occurred',
      );
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
