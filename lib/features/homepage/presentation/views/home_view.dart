// File: lib/features/home/presentation/pages/home_page_tab.dart

import 'dart:ui';

import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/health_metrics_widget.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/sleep_data_widget.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/weight_data_widget.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/workout_activity_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const String userName = "Nikhil Sharma";
    const int currentDay = 10;
    const String currentMonth = "Mar";
    final List<int> workoutDays = [10, 12]; // Days with workouts

    // Demo data for health metrics
    final healthMetrics = [
      const HealthMetric(
        category: "Heart Rate",
        value: "68",
        label: "bpm (resting)",
        icon: CupertinoIcons.heart_fill,
        color: Pallate.accentRed,
      ),
      const HealthMetric(
        category: "Steps",
        value: "9,284",
        label: "steps today",
        icon: CupertinoIcons.arrow_right_circle_fill,
        color: Pallate.accentBlue,
      ),
      const HealthMetric(
        category: "Calories",
        value: "1,248",
        label: "kcal burned",
        icon: CupertinoIcons.flame_fill,
        color: Pallate.accentOrange,
      ),
      const HealthMetric(
        category: "Water",
        value: "1.2L",
        label: "of 2.5L goal",
        icon: CupertinoIcons.drop_fill,
        color: Pallate.vibrantTeal,
      ),
    ];

    // Demo data for sleep stages
    final sleepStages = {
      "Awake": 3.0,
      "REM Sleep": 48.0,
      "Light Sleep": 26.0,
      "Deep Sleep": 23.0,
    };

    // Demo data for weight tracking
    final weightData = [
      82.3,
      81.7,
      81.9,
      81.2,
      80.8,
      80.5,
      80.3,
      79.8,
      79.5,
      78.9,
      78.4,
      78.1,
      77.8,
    ];
    final weightDates = [
      "Mar 1",
      "Mar 3",
      "Mar 5",
      "Mar 7",
      "Mar 9",
      "Mar 11",
      "Mar 13",
      "Mar 15",
      "Mar 17",
      "Mar 19",
      "Mar 21",
      "Mar 23",
      "Mar 25",
    ];

    return Stack(
      children: [
        // Background gradient
        const Positioned.fill(child: BackgroundGradient(tabType: TabType.home)),

        // Content
        SafeArea(
          bottom: false, // For custom tab bar
          child: ListView(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 15, 24, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Welcome text
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Welcome back",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w500,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          userName,
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    // Profile button
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black.withOpacity(0.2),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 0.5,
                        ),
                      ),
                      child: ClipOval(
                        child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                          child: const Center(
                            child: Icon(
                              CupertinoIcons.person_fill,
                              color: Colors.white,
                              size: 28,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Workout activity card
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: WorkoutActivityCard(
                  currentDay: currentDay,
                  currentMonth: currentMonth,
                  workoutDays: workoutDays,
                ),
              ),

              // Weight data widget with line chart
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                child: WeightDataWidget(
                  weightData: weightData,
                  dates: weightDates,
                  currentWeight: 77.8,
                ),
              ),

              // Health metrics grid
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
                child: HealthMetricsWidget(metrics: healthMetrics),
              ),
              // Sleep data widget
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
                child: SleepDataWidget(
                  sleepIndex: 85,
                  sleepStages: sleepStages,
                  weeklyIndices: const [92, 76, 65, 85, 96, 70, 85],
                  weekDays: const ["W", "T", "F", "S", "S", "M", "T"],
                ),
              ),
              SizedBox(height: 100),
            ],
          ),
        ),
      ],
    );
  }
}
