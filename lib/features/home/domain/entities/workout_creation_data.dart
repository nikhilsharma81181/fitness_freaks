// Workout creation steps
enum WorkoutCreationStep {
  muscleGroup,
  duration,
  exerciseSelection,
  summary,
}

// Workout creation data model
class WorkoutCreationData {
  // Muscle group selection (can be multiple)
  final Set<String> selectedMuscleGroups = <String>{};

  // Duration selection
  int? selectedDuration;

  // Exercise selection
  final Set<String> selectedExercises = <String>{};

  // Clear all data
  void clear() {
    selectedMuscleGroups.clear();
    selectedExercises.clear();
    selectedDuration = null;
  }

  // Validation helpers
  bool get canProceedFromMuscleGroup => selectedMuscleGroups.isNotEmpty;
  bool get canProceedFromDuration => selectedDuration != null;
  bool get canProceedFromExercises => selectedExercises.isNotEmpty;
  bool get isComplete =>
      canProceedFromMuscleGroup &&
      canProceedFromDuration &&
      canProceedFromExercises;

  // Get summary data
  Map<String, dynamic> get summaryData => {
        'muscleGroups': selectedMuscleGroups.toList(),
        'duration': selectedDuration,
        'exercises': selectedExercises.toList(),
        'totalExercises': selectedExercises.length,
      };
}
