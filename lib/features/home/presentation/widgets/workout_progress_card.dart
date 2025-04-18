import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class WorkoutProgressCard extends StatelessWidget {
  final List<String> weekDays = ["M", "T", "W", "T", "F", "S", "S"];
  final int currentDay;
  final List<bool> activeWorkoutDays;

  WorkoutProgressCard({
    Key? key,
    required this.currentDay,
    required this.activeWorkoutDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get the current date for the display
    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, MMM d');
    final formattedDate = dateFormatter.format(now);

    return EnhancedGlassCard(
      cornerRadius: 28,
      transparency: 0.8,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    formattedDate,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Workout Activity",
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // Dropdown menu
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withOpacity(0.05),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      "This Week",
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      size: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // Week day indicators with enhanced styling
          buildWeeklyCalendar(),

          const SizedBox(height: 25),

          // Previous weeks indicator
          buildWeeklyProgress(),
        ],
      ),
    );
  }

  Widget buildWeeklyCalendar() {
    final firstDayOfWeek =
        currentDay - 3; // starting from 3 days before current day

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        final day = firstDayOfWeek + index;
        final isActive = activeWorkoutDays[index];
        final isToday = index == 3; // Assuming the 3rd day is today

        return Container(
          width: 44,
          height: 67,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive
                ? AppColors.primaryColor.withOpacity(0.25)
                : Colors.black.withOpacity(0.2),
            border: Border.all(
              color: isActive
                  ? AppColors.primaryColor.withOpacity(0.7)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                weekDays[index],
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color:
                      isActive ? Colors.white : Colors.white.withOpacity(0.5),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "$day",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget buildWeeklyProgress() {
    return Row(
      children: [
        Text(
          "Previous Weeks",
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.5),
          ),
        ),
        const SizedBox(width: 10),
        Row(
          children: List.generate(
            12,
            (index) => Container(
              margin: const EdgeInsets.only(right: 4),
              width: 12,
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                gradient: LinearGradient(
                  colors: [
                    AppColors.primaryColor.withOpacity(0.6),
                    AppColors.primaryColor,
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
