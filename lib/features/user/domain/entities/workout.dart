import 'package:equatable/equatable.dart';

class Workout extends Equatable {
  final String id;
  final String name;
  final String description;
  final int difficulty;
  final int durationMinutes;
  final List<Exercise> exercises;
  final String category;
  final String imageUrl;

  const Workout({
    required this.id,
    required this.name,
    required this.description,
    required this.difficulty,
    required this.durationMinutes,
    required this.exercises,
    required this.category,
    required this.imageUrl,
  });

  @override
  List<Object> get props => [
    id, 
    name, 
    description, 
    difficulty, 
    durationMinutes, 
    exercises,
    category,
    imageUrl,
  ];
}

class Exercise extends Equatable {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String videoUrl;
  final int sets;
  final int reps;
  final int restSeconds;

  const Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.videoUrl,
    required this.sets,
    required this.reps,
    required this.restSeconds,
  });

  @override
  List<Object> get props => [
    id, 
    name, 
    description, 
    imageUrl, 
    videoUrl, 
    sets, 
    reps, 
    restSeconds,
  ];
} 