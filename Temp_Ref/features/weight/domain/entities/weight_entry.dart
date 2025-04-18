import 'package:equatable/equatable.dart';

/// Entity representing a weight entry in the domain layer
class WeightEntryEntity extends Equatable {
  /// Unique identifier for the weight entry
  final int? id;
  
  /// ID of the user this weight entry belongs to
  final int? userId;
  
  /// Weight value in kg
  final double weight;
  
  /// Base64 encoded image (optional)
  final String? image;
  
  /// ISO 8601 formatted date string when the weight was recorded
  final String date;
  
  /// ISO 8601 formatted date string when the entry was created
  final String? createdAt;
  
  /// ISO 8601 formatted date string when the entry was last updated
  final String? updatedAt;

  const WeightEntryEntity({
    this.id,
    this.userId,
    required this.weight,
    this.image,
    required this.date,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory constructor for creating a weight entry
  factory WeightEntryEntity.create({
    int? id,
    int? userId,
    required double weight,
    String? image,
    required String date,
    String? createdAt,
    String? updatedAt,
  }) {
    return WeightEntryEntity(
      id: id,
      userId: userId,
      weight: weight,
      image: image,
      date: date,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  /// Get Date object from ISO string
  DateTime get dateObject => DateTime.parse(date);
  
  /// Formatted date for display (e.g., "Jan 15, 2023")
  String get formattedDate {
    final dateTime = dateObject;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year}';
  }
  
  /// Short date format (e.g., "Jan 15")
  String get shortDate {
    final dateTime = dateObject;
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }
  
  /// Create a copy of this weight entry with updated fields
  WeightEntryEntity copyWith({
    int? id,
    int? userId,
    double? weight,
    String? image,
    String? date,
    String? createdAt,
    String? updatedAt,
  }) {
    return WeightEntryEntity(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      weight: weight ?? this.weight,
      image: image ?? this.image,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    weight,
    image,
    date,
    createdAt,
    updatedAt,
  ];
}
