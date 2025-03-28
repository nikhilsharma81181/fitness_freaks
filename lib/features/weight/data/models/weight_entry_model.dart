import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';

/// Model class for weight entry data from API
class WeightEntryModel extends WeightEntryEntity {
  const WeightEntryModel({
    super.id,
    super.userId,
    required super.weight,
    super.image,
    required super.date,
    super.createdAt,
    super.updatedAt,
  });

  /// Factory constructor from JSON
  factory WeightEntryModel.fromJson(Map<String, dynamic> json) {
    return WeightEntryModel(
      id: json['id'],
      userId: json['userId'],
      weight: json['weight']?.toDouble() ?? 0.0,
      image: json['image'],
      date: json['date'] ?? DateTime.now().toIso8601String(),
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'weight': weight,
      'image': image,
      'date': date,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  /// Convert domain entity to model
  factory WeightEntryModel.fromEntity(WeightEntryEntity entity) {
    return WeightEntryModel(
      id: entity.id,
      userId: entity.userId,
      weight: entity.weight,
      image: entity.image,
      date: entity.date,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}

/// Model for weight response from API
class WeightDataResponseModel {
  final bool success;
  final List<WeightEntryModel> data;

  WeightDataResponseModel({
    required this.success,
    required this.data,
  });

  factory WeightDataResponseModel.fromJson(Map<String, dynamic> json) {
    return WeightDataResponseModel(
      success: json['success'] ?? false,
      data: (json['data'] as List?)
          ?.map((entry) => WeightEntryModel.fromJson(entry))
          .toList() ?? [],
    );
  }
}

/// Model for upload weight response
class UploadWeightResponseModel {
  final bool success;
  final WeightEntryModel data;

  UploadWeightResponseModel({
    required this.success,
    required this.data,
  });

  factory UploadWeightResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadWeightResponseModel(
      success: json['success'] ?? false,
      data: WeightEntryModel.fromJson(json['data']),
    );
  }
}
