import 'dart:ui';
import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class SleepDataWidget extends StatelessWidget {
  final int sleepIndex;
  final Map<String, double> sleepStages;
  final List<int> weeklyIndices;
  final List<String> weekDays;

  const SleepDataWidget({
    Key? key,
    required this.sleepIndex,
    required this.sleepStages,
    required this.weeklyIndices,
    required this.weekDays,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      cornerRadius: 28,
      transparency: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Sleep quality index
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Sleep Index",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.info_outline,
                        color: Colors.white.withOpacity(0.7),
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        sleepIndex.toString(),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        "Sleep Index",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              // Date chip
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Text(
                  "Today",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Weekly progress bars
          SizedBox(
            height: 140,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(weeklyIndices.length, (index) {
                return _buildWeekdayBar(
                  day: weekDays[index],
                  value: weeklyIndices[index],
                  isToday: index == weekDays.length - 1, // Assume last is today
                );
              }),
            ),
          ),

          const SizedBox(height: 24),

          // Sleep stages
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sleep Stage",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 16),
              ...sleepStages.entries.map((entry) {
                return _buildSleepStageRow(
                  stage: entry.key,
                  percentage: entry.value,
                );
              }).toList(),
              const SizedBox(height: 10),
              Divider(color: Colors.white.withOpacity(0.2), height: 24),

              // Restless period
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    Text(
                      "Restless Period • ",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                    Text(
                      "6",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeekdayBar({
    required String day,
    required int value,
    required bool isToday,
  }) {
    final double height = 20 + (value / 100 * 70);
    final Color barColor =
        isToday ? Colors.white : Pallate.sleepTeal.withOpacity(0.7);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 28,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: barColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          day,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isToday ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value.toString(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.w400,
            color: isToday ? Colors.white : Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildSleepStageRow({
    required String stage,
    required double percentage,
  }) {
    final Color barColor = _getSleepStageColor(stage);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              stage,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: Colors.black.withOpacity(0.2),
              ),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      Container(
                        width: constraints.maxWidth * (percentage / 100),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: barColor,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              "${percentage.toInt()}%",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getSleepStageColor(String stage) {
    switch (stage.toLowerCase()) {
      case 'awake':
        return Colors.white.withOpacity(0.8);
      case 'rem sleep':
        return Pallate.sleepTeal;
      case 'light sleep':
        return Pallate.accentGreen;
      case 'deep sleep':
        return Pallate.accentBlue;
      default:
        return Pallate.vibrantMint;
    }
  }
}
