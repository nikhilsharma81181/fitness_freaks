import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

class WorkoutHistoryCard extends StatelessWidget {
  final List<Map<String, dynamic>> recentWorkouts;
  final VoidCallback? onViewAllTap;

  const WorkoutHistoryCard({
    Key? key,
    required this.recentWorkouts,
    this.onViewAllTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppColors.vibrantMint.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          CupertinoIcons.clock_fill,
                          color: AppColors.vibrantMint,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Recent Workouts',
                            style: GoogleFonts.inter(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${recentWorkouts.length} completed',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.6),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (onViewAllTap != null)
                    GestureDetector(
                      onTap: onViewAllTap,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.15),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          'View All',
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              const SizedBox(height: 16),

              // Recent workouts list
              if (recentWorkouts.isEmpty)
                _buildEmptyState()
              else
                ...recentWorkouts
                    .take(3)
                    .map((workout) => _buildWorkoutItem(workout)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.clock,
            size: 40,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Text(
            'No workouts completed yet',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Start your first workout to see your history here!',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.white.withOpacity(0.5),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(Map<String, dynamic> workout) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Workout icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (workout['color'] as Color? ?? AppColors.primaryColor)
                  .withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              workout['icon'] as IconData? ?? CupertinoIcons.flame_fill,
              color: workout['color'] as Color? ?? AppColors.primaryColor,
              size: 18,
            ),
          ),

          const SizedBox(width: 12),

          // Workout details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  workout['name'] ?? 'Unknown Workout',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      size: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      workout['duration'] ?? '0 min',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(
                      CupertinoIcons.calendar,
                      size: 12,
                      color: Colors.white.withOpacity(0.6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      workout['completedAt'] ?? 'Today',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Completion indicator
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppColors.vibrantMint.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              CupertinoIcons.checkmark,
              color: AppColors.vibrantMint,
              size: 14,
            ),
          ),
        ],
      ),
    );
  }
}
