import 'package:fitness_freaks/features/user/domain/entities/workout.dart';

class WorkoutModel extends Workout {
  const WorkoutModel({
    required String id,
    required String name,
    required String description,
    required int difficulty,
    required int durationMinutes,
    required List<ExerciseModel> exercises,
    required String category,
    required String imageUrl,
  }) : super(
          id: id,
          name: name,
          description: description,
          difficulty: difficulty,
          durationMinutes: durationMinutes,
          exercises: exercises,
          category: category,
          imageUrl: imageUrl,
        );

  factory WorkoutModel.fromJson(Map<String, dynamic> json) {
    return WorkoutModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      difficulty: json['difficulty'] ?? 1,
      durationMinutes: json['duration_minutes'] ?? 30,
      exercises: (json['exercises'] as List)
          .map((e) => ExerciseModel.fromJson(e))
          .toList(),
      category: json['category'] ?? 'General',
      imageUrl: json['image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'difficulty': difficulty,
      'duration_minutes': durationMinutes,
      'exercises': (exercises as List<ExerciseModel>)
          .map((e) => e.toJson())
          .toList(),
      'category': category,
      'image_url': imageUrl,
    };
  }
}

class ExerciseModel extends Exercise {
  const ExerciseModel({
    required String id,
    required String name,
    required String description,
    required String imageUrl,
    required String videoUrl,
    required int sets,
    required int reps,
    required int restSeconds,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          videoUrl: videoUrl,
          sets: sets,
          reps: reps,
          restSeconds: restSeconds,
        );

  factory ExerciseModel.fromJson(Map<String, dynamic> json) {
    return ExerciseModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['image_url'] ?? '',
      videoUrl: json['video_url'] ?? '',
      sets: json['sets'] ?? 3,
      reps: json['reps'] ?? 10,
      restSeconds: json['rest_seconds'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url': imageUrl,
      'video_url': videoUrl,
      'sets': sets,
      'reps': reps,
      'rest_seconds': restSeconds,
    };
  }
} 