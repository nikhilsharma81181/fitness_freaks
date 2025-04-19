import 'package:flutter/material.dart';

// Gender enum
enum Gender {
  male,
  female,
  other,
}

// Measurement units enum
enum MeasurementUnits {
  metric,
  imperial,
}

// Fitness goal enum with description and icon
class FitnessGoal {
  final String id;
  final String name;
  final String description;
  final String iconName;

  const FitnessGoal({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FitnessGoal &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Predefined fitness goals
  static const loseWeight = FitnessGoal(
    id: 'lose_weight',
    name: 'Lose Weight',
    description: 'Reduce body fat and achieve a healthier weight',
    iconName: 'scale',
  );

  static const buildMuscle = FitnessGoal(
    id: 'build_muscle',
    name: 'Build Muscle',
    description: 'Increase strength and muscle mass',
    iconName: 'fitness_center',
  );

  static const improveEndurance = FitnessGoal(
    id: 'improve_endurance',
    name: 'Improve Endurance',
    description: 'Enhance cardio fitness and stamina',
    iconName: 'directions_run',
  );

  static const increaseFlexibility = FitnessGoal(
    id: 'increase_flexibility',
    name: 'Increase Flexibility',
    description: 'Improve mobility and reduce stiffness',
    iconName: 'self_improvement',
  );

  static const stressReduction = FitnessGoal(
    id: 'stress_reduction',
    name: 'Stress Reduction',
    description: 'Improve mental wellbeing through exercise',
    iconName: 'spa',
  );

  static const healthyLifestyle = FitnessGoal(
    id: 'healthy_lifestyle',
    name: 'Healthy Lifestyle',
    description: 'Create sustainable healthy habits',
    iconName: 'favorite',
  );

  // Get all goals as a list
  static List<FitnessGoal> get allGoals => [
        loseWeight,
        buildMuscle,
        improveEndurance,
        increaseFlexibility,
        stressReduction,
        healthyLifestyle,
      ];
}

// Onboarding steps enum
enum OnboardingStep {
  personalInfo,
  fitnessGoals,
  experienceLevel,
  workoutPreferences,
  dietaryInfo,
  summary,
}

// Experience level enum with descriptions
class ExperienceLevel {
  final int level;
  final String name;
  final String description;

  const ExperienceLevel({
    required this.level,
    required this.name,
    required this.description,
  });

  // Beginner level
  static const beginner = ExperienceLevel(
    level: 1,
    name: 'Beginner',
    description: 'New to fitness or returning after a long break',
  );

  // Novice level
  static const novice = ExperienceLevel(
    level: 2,
    name: 'Novice',
    description: 'Some experience with regular workouts',
  );

  // Intermediate level
  static const intermediate = ExperienceLevel(
    level: 3,
    name: 'Intermediate',
    description: 'Consistent training for 6+ months',
  );

  // Advanced level
  static const advanced = ExperienceLevel(
    level: 4,
    name: 'Advanced',
    description: 'Experienced with focused training for 1+ years',
  );

  // Expert level
  static const expert = ExperienceLevel(
    level: 5,
    name: 'Expert',
    description: 'Highly experienced with multiple years of training',
  );

  // Get all levels as a list
  static List<ExperienceLevel> get allLevels => [
        beginner,
        novice,
        intermediate,
        advanced,
        expert,
      ];

  // Get level by value
  static ExperienceLevel fromLevel(int level) {
    return allLevels.firstWhere(
      (e) => e.level == level,
      orElse: () => intermediate,
    );
  }
}

// Workout frequency enum
enum WorkoutFrequency {
  oneToTwo,
  threeToFour,
  fiveToSix,
  daily,
}

// Workout location enum
enum WorkoutLocation {
  home,
  gym,
  outdoors,
  mixed,
}

// Workout duration enum
enum WorkoutDuration {
  lessThan30Min,
  thirtyToSixtyMin,
  sixtyToNinetyMin,
  moreThan90Min,
}

// Equipment availability enum
enum EquipmentAvailability {
  none,
  minimal,
  moderate,
  full,
}

// Diet type enum
enum DietType {
  standard,
  vegetarian,
  vegan,
  pescatarian,
  ketogenic,
  paleo,
}

// Meal preference enum
enum MealPreference {
  twoToThree,
  threeToFive,
  fivePlus,
}

// Dietary restriction class with description
class DietaryRestriction {
  final String id;
  final String name;
  final String description;
  final String iconName;

  const DietaryRestriction({
    required this.id,
    required this.name,
    required this.description,
    required this.iconName,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DietaryRestriction &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  // Predefined dietary restrictions
  static const glutenFree = DietaryRestriction(
    id: 'gluten_free',
    name: 'Gluten Free',
    description: 'Avoid foods containing gluten (wheat, barley, rye)',
    iconName: 'no_meals',
  );

  static const lactoseIntolerant = DietaryRestriction(
    id: 'lactose_intolerant',
    name: 'Lactose Intolerant',
    description: 'Avoid or limit dairy products containing lactose',
    iconName: 'no_drinks',
  );

  static const nutAllergy = DietaryRestriction(
    id: 'nut_allergy',
    name: 'Nut Allergy',
    description: 'Avoid foods containing nuts and tree nuts',
    iconName: 'dangerous',
  );

  static const lowSodium = DietaryRestriction(
    id: 'low_sodium',
    name: 'Low Sodium',
    description: 'Limit salt intake for heart health or blood pressure',
    iconName: 'restaurant',
  );

  static const lowSugar = DietaryRestriction(
    id: 'low_sugar',
    name: 'Low Sugar',
    description: 'Limit added sugar intake for health or weight management',
    iconName: 'cookie',
  );

  // Get all restrictions as a list
  static List<DietaryRestriction> get allRestrictions => [
        glutenFree,
        lactoseIntolerant,
        nutAllergy,
        lowSodium,
        lowSugar,
      ];
}

// User onboarding data model
class UserOnboardingData {
  // Personal info
  int? age;
  Gender gender;
  MeasurementUnits units;
  double? height; // cm for metric, inches for imperial
  double? weight; // kg for metric, lbs for imperial

  // Goals and preferences
  List<FitnessGoal> fitnessGoals;
  ExperienceLevel experienceLevel; // Now using the ExperienceLevel class

  // Workout preferences
  WorkoutFrequency workoutFrequency;
  WorkoutLocation workoutLocation;
  WorkoutDuration workoutDuration;
  EquipmentAvailability equipmentAvailability;
  List<int> preferredWorkoutDays; // 0 = Monday, 6 = Sunday

  // Dietary preferences
  DietType dietType;
  MealPreference mealPreference;
  List<DietaryRestriction> dietaryRestrictions;
  int? dailyCalorieTarget; // Optional calorie target
  double? dailyProteinTarget; // Optional protein target in grams

  Set<String> completedSteps;

  // Constructor with defaults
  UserOnboardingData({
    this.age,
    this.gender = Gender.male,
    this.units = MeasurementUnits.metric,
    this.height,
    this.weight,
    List<FitnessGoal>? fitnessGoals,
    ExperienceLevel? experienceLevel,
    WorkoutFrequency? workoutFrequency,
    WorkoutLocation? workoutLocation,
    WorkoutDuration? workoutDuration,
    EquipmentAvailability? equipmentAvailability,
    List<int>? preferredWorkoutDays,
    DietType? dietType,
    MealPreference? mealPreference,
    List<DietaryRestriction>? dietaryRestrictions,
    this.dailyCalorieTarget,
    this.dailyProteinTarget,
    Set<String>? completedSteps,
  })  : fitnessGoals = fitnessGoals ?? [],
        experienceLevel = experienceLevel ?? ExperienceLevel.intermediate,
        workoutFrequency = workoutFrequency ?? WorkoutFrequency.threeToFour,
        workoutLocation = workoutLocation ?? WorkoutLocation.mixed,
        workoutDuration = workoutDuration ?? WorkoutDuration.thirtyToSixtyMin,
        equipmentAvailability =
            equipmentAvailability ?? EquipmentAvailability.minimal,
        preferredWorkoutDays =
            preferredWorkoutDays ?? [1, 3, 5], // Default to M/W/F
        dietType = dietType ?? DietType.standard,
        mealPreference = mealPreference ?? MealPreference.threeToFive,
        dietaryRestrictions = dietaryRestrictions ?? [],
        completedSteps = completedSteps ?? {};

  // Calculate BMI if height and weight are available
  double? get bmi {
    if (height == null || weight == null) return null;

    if (units == MeasurementUnits.metric) {
      // Metric: weight(kg) / height(m)²
      final heightInMeters = height! / 100;
      return weight! / (heightInMeters * heightInMeters);
    } else {
      // Imperial: (weight(lb) / height(in)²) * 703
      return (weight! / (height! * height!)) * 703;
    }
  }

  // Mark a step as completed
  void completeStep(OnboardingStep step) {
    completedSteps.add(step.toString());
  }

  // Check if a step is completed
  bool isStepCompleted(OnboardingStep step) {
    return completedSteps.contains(step.toString());
  }

  // Convert between units
  void convertToMetric() {
    if (units == MeasurementUnits.imperial) {
      if (height != null) {
        // Convert inches to cm
        height = height! * 2.54;
      }
      if (weight != null) {
        // Convert lbs to kg
        weight = weight! * 0.453592;
      }
      units = MeasurementUnits.metric;
    }
  }

  void convertToImperial() {
    if (units == MeasurementUnits.metric) {
      if (height != null) {
        // Convert cm to inches
        height = height! / 2.54;
      }
      if (weight != null) {
        // Convert kg to lbs
        weight = weight! / 0.453592;
      }
      units = MeasurementUnits.imperial;
    }
  }

  // Copy with new values
  UserOnboardingData copyWith({
    int? age,
    Gender? gender,
    MeasurementUnits? units,
    double? height,
    double? weight,
    List<FitnessGoal>? fitnessGoals,
    ExperienceLevel? experienceLevel,
    WorkoutFrequency? workoutFrequency,
    WorkoutLocation? workoutLocation,
    WorkoutDuration? workoutDuration,
    EquipmentAvailability? equipmentAvailability,
    List<int>? preferredWorkoutDays,
    DietType? dietType,
    MealPreference? mealPreference,
    List<DietaryRestriction>? dietaryRestrictions,
    int? dailyCalorieTarget,
    double? dailyProteinTarget,
    Set<String>? completedSteps,
  }) {
    return UserOnboardingData(
      age: age ?? this.age,
      gender: gender ?? this.gender,
      units: units ?? this.units,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      fitnessGoals: fitnessGoals ?? List.from(this.fitnessGoals),
      experienceLevel: experienceLevel ?? this.experienceLevel,
      workoutFrequency: workoutFrequency ?? this.workoutFrequency,
      workoutLocation: workoutLocation ?? this.workoutLocation,
      workoutDuration: workoutDuration ?? this.workoutDuration,
      equipmentAvailability:
          equipmentAvailability ?? this.equipmentAvailability,
      preferredWorkoutDays:
          preferredWorkoutDays ?? List.from(this.preferredWorkoutDays),
      dietType: dietType ?? this.dietType,
      mealPreference: mealPreference ?? this.mealPreference,
      dietaryRestrictions:
          dietaryRestrictions ?? List.from(this.dietaryRestrictions),
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyProteinTarget: dailyProteinTarget ?? this.dailyProteinTarget,
      completedSteps: completedSteps ?? Set.from(this.completedSteps),
    );
  }
}
