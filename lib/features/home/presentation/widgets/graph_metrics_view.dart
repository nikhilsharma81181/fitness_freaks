import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';
import 'glass_card.dart';

/// Widget displaying activity metrics in a horizontal scrollable view
class GraphMetricsView extends StatefulWidget {
  const GraphMetricsView({Key? key}) : super(key: key);

  @override
  State<GraphMetricsView> createState() => _GraphMetricsViewState();
}

class _GraphMetricsViewState extends State<GraphMetricsView> {
  // Sample data for the graphs
  final List<double> heartRateData = [
    65,
    68,
    72,
    78,
    68,
    65,
    62,
    64,
    68,
    70,
    68,
    65
  ];
  final List<double> sleepData = [7.5, 6.8, 7.2, 8.1, 6.5, 7.0, 7.8];
  final List<double> calorieData = [350, 420, 380, 450, 510, 420, 400];
  final List<double> activeMinutes = [45, 60, 30, 75, 65, 40, 55];

  // Selected time period
  String selectedPeriod = 'Week';
  final List<String> periods = ['Day', 'Week', 'Month', 'Year'];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with period selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Activity Metrics',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Period picker
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPeriod,
                    icon: const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white70,
                      size: 16,
                    ),
                    dropdownColor: Colors.grey[850],
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                    underline: null,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    onChanged: (String? newValue) {
                      if (newValue != null) {
                        setState(() {
                          selectedPeriod = newValue;
                        });
                      }
                    },
                    items:
                        periods.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Metrics graphs in a scrollable horizontal container
        SizedBox(
          height: 250,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            children: [
              // Heart Rate Graph
              _buildMetricCard(
                title: 'Heart Rate',
                value: '68',
                unit: 'bpm',
                color: AppColors.accent3,
                iconData: Icons.favorite,
                data: heartRateData,
              ),

              const SizedBox(width: 16),

              // Active Minutes Graph
              _buildMetricCard(
                title: 'Active Minutes',
                value: '55',
                unit: 'min',
                color: AppColors.accent2,
                iconData: Icons.local_fire_department,
                data: activeMinutes,
              ),

              const SizedBox(width: 16),

              // Calories Graph
              _buildMetricCard(
                title: 'Calories',
                value: '420',
                unit: 'kcal',
                color: AppColors.secondary,
                iconData: Icons.bolt,
                data: calorieData,
              ),

              const SizedBox(width: 16),

              // Sleep Graph
              _buildMetricCard(
                title: 'Sleep',
                value: '7.5',
                unit: 'hrs',
                color: AppColors.accent1,
                iconData: Icons.nightlight_round,
                data: sleepData,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required IconData iconData,
    required List<double> data,
  }) {
    final double maxValue =
        data.reduce((curr, next) => curr > next ? curr : next);

    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon and title row
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    iconData,
                    color: color,
                    size: 16,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Value display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            // Graph
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(data.length, (index) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Container(
                        height: (data[index] / maxValue) * 70,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              color.withOpacity(0.7),
                              color,
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 8),

            // Day indicators
            Row(
              children: List.generate(data.length, (index) {
                return Expanded(
                  child: Text(
                    selectedPeriod == 'Week'
                        ? ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index % 7]
                        : (index + 1).toString(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white54,
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
