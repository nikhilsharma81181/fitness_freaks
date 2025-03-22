import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class WorkoutActivityCard extends StatelessWidget {
  final int currentDay;
  final String currentMonth;
  final List<int> workoutDays;

  const WorkoutActivityCard({
    Key? key,
    required this.currentDay,
    required this.currentMonth,
    required this.workoutDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final weekDays = ["M", "T", "W", "T", "F", "S", "S"];
    final dayNumbers = List.generate(7, (index) => currentDay - 3 + index);
    double width = MediaQuery.of(context).size.width;

    // Derive responsive sizes based on screen width
    final titleFontSize = width * 0.06; // 24 on normal screens
    final subtitleFontSize = width * 0.04; // 16 on normal screens
    final smallFontSize = width * 0.035; // 14 on normal screens
    final dayIndicatorSize = width * 0.11; // ~45 on normal screens
    final dayTextSize = width * 0.035; // ~14 on normal screens
    final dayNumberSize = width * 0.042; // ~17 on normal screens

    return GlassCard(
      cornerRadius: 28,
      transparency: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Date and title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Monday, $currentMonth $currentDay",
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Workout Activity",
                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              // This Week dropdown
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: width * 0.04, // ~16 on normal screens
                  vertical: width * 0.025, // ~10 on normal screens
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Row(
                  children: [
                    Text(
                      "This Week",
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white.withOpacity(0.7),
                      size: width * 0.05, // ~20 on normal screens
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.08), // ~32 on normal screens
          // Day indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (index) {
              final day = dayNumbers[index];
              final isActive = workoutDays.contains(day);

              return Container(
                width: dayIndicatorSize,
                height:
                    dayIndicatorSize *
                    1.55, // maintain aspect ratio ~70 on normal screens
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color:
                      isActive
                          ? Pallate.vibrantMint.withOpacity(0.2)
                          : Colors.black.withOpacity(0.3),
                  border:
                      isActive
                          ? Border.all(color: Pallate.vibrantMint, width: 1.4)
                          : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      weekDays[index],
                      style: TextStyle(
                        fontSize: dayTextSize,
                        fontWeight: FontWeight.w500,
                        color:
                            isActive
                                ? Colors.white
                                : Colors.white.withOpacity(0.5),
                      ),
                    ),
                    SizedBox(height: width * 0.01), // ~4 on normal screens
                    Text(
                      day.toString(),
                      style: TextStyle(
                        fontSize: dayNumberSize,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          SizedBox(height: width * 0.07), // ~28 on normal screens
          // Previous Weeks
          Row(
            children: [
              Text(
                "Previous Weeks",
                style: TextStyle(
                  fontSize: smallFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.5),
                ),
              ),
              SizedBox(width: width * 0.03), // ~12 on normal screens
              Row(
                children: List.generate(
                  12,
                  (index) => Container(
                    margin: EdgeInsets.only(
                      right: width * 0.01,
                    ), // ~4 on normal screens
                    width: width * 0.03, // ~12 on normal screens
                    height: width * 0.02, // ~8 on normal screens
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.5),
                      gradient: LinearGradient(
                        colors: [
                          Pallate.vibrantMint,
                          Pallate.vibrantMint.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
