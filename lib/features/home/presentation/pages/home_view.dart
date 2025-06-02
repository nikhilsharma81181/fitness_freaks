import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/workout_progress_card.dart';
import 'package:fitness_freaks_flutter/features/weight/presentation/widgets/weight_tracking_widget.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/diet_tracking_widget.dart';
import 'package:fitness_freaks_flutter/features/weight/presentation/pages/weight_detail_page.dart';
import 'package:fitness_freaks_flutter/features/diet/presentation/pages/diet_detail_page.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    const String userName = "Nikhil Sharma";
    final List<bool> workoutDays = [
      false,
      false,
      false,
      true,
      false,
      true,
      false
    ]; // M T W T F S S

    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Top welcome section
          _buildWelcomeHeader(userName),

          // Scrollable content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),

                    // Workout activity card - using the new component
                    WorkoutProgressCard(
                      currentDay: 10, // Example: current day is 10th
                      activeWorkoutDays: workoutDays,
                    ),

                    const SizedBox(height: 16),

                    // Weight tracking widget
                    WeightTrackingWidget(
                      onViewAllTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const WeightDetailPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 16),

                    // Diet tracking widget
                    DietTrackingWidget(
                      onViewAllTap: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => const DietDetailPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 150),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeHeader(String userName) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                userName,
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.5,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Center(
                  child: Icon(
                    CupertinoIcons.person_fill,
                    color: Colors.white.withOpacity(0.9),
                    size: 24,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
