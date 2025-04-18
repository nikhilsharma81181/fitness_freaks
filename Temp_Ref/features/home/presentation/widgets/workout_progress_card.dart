import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/colors.dart';
import 'glass_card.dart';

/// Card showing weekly workout progress
class WorkoutProgressCard extends StatelessWidget {
  const WorkoutProgressCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get current date
    final now = DateTime.now();
    final currentDay = now.day;

    // Example active workout days (can be replaced with actual data)
    final activeWorkoutDays = [now.day, now.day - 2, now.day - 4];

    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with date and dropdown
          _buildHeader(now),

          const SizedBox(height: 20),

          // Week day indicators
          _buildWeekDayIndicators(now, currentDay, activeWorkoutDays),

          const SizedBox(height: 20),

          // Previous weeks indicator
          _buildPreviousWeeksIndicator(),
        ],
      ),
    );
  }

  Widget _buildHeader(DateTime now) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Date and title
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              DateFormat('EEEE, MMM d').format(now),
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              'Workout Activity',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // Dropdown menu
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 0.5,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: 'This Week',
              icon: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white70,
              ),
              dropdownColor: Colors.grey[850],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.white,
              ),
              onChanged: (String? newValue) {
                // Handle dropdown change
              },
              items: <String>['This Week', 'Last Week', 'This Month']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekDayIndicators(
      DateTime now, int currentDay, List<int> activeWorkoutDays) {
    // Calculate the first day of the week (Monday)
    final firstDayOfWeek = now.subtract(Duration(days: now.weekday - 1));

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(7, (index) {
        // Get the day of the month for this weekday
        final date = firstDayOfWeek.add(Duration(days: index));
        final day = date.day;
        final weekday =
            DateFormat('E').format(date)[0]; // First letter of weekday

        final isActive = activeWorkoutDays.contains(day);

        return _buildDayIndicator(
          day: day.toString(),
          weekday: weekday,
          isActive: isActive,
          isToday: day == currentDay,
        );
      }),
    );
  }

  Widget _buildDayIndicator({
    required String day,
    required String weekday,
    required bool isActive,
    required bool isToday,
  }) {
    return Container(
      width: 40,
      height: 64,
      decoration: BoxDecoration(
        color: isActive
            ? AppColors.vibrantMint.withOpacity(0.25)
            : Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive
              ? AppColors.vibrantMint.withOpacity(0.7)
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            weekday,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.white : Colors.white70,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            day,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreviousWeeksIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Previous Weeks',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(12, (index) {
            return Container(
              width: 10,
              height: 7,
              margin: const EdgeInsets.only(right: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.accent1.withOpacity(0.7),
                    AppColors.accent1,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(2),
              ),
            );
          }),
        ),
      ],
    );
  }
}
