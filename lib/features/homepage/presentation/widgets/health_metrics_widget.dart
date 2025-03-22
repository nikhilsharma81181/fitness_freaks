import 'dart:ui';
import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';

class HealthMetricsWidget extends StatelessWidget {
  final List<HealthMetric> metrics;

  const HealthMetricsWidget({Key? key, required this.metrics})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    double width = MediaQuery.of(context).size.width;

    // Derive responsive font sizes
    final titleFontSize = width * 0.05; // ~20 on normal screens
    final subtitleFontSize = width * 0.035; // ~14 on normal screens
    final valueFontSize = width * 0.055; // ~22 on normal screens
    final smallFontSize = width * 0.03; // ~12 on normal screens
    final tinyFontSize = width * 0.025; // ~10 on normal screens

    return GlassCard(
      cornerRadius: 28,
      transparency: 0.85,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Title
              Text(
                "Health Metrics",
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              // Settings icon
              Container(
                width: width * 0.09, // ~36 on normal screens
                height: width * 0.09, // ~36 on normal screens
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.3),
                ),
                child: Center(
                  child: Icon(
                    Icons.settings_outlined,
                    color: Colors.white.withOpacity(0.9),
                    size: width * 0.05, // ~20 on normal screens
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: width * 0.06), // ~24 on normal screens
          // Metrics Grid
          SizedBox(
            height:
                metrics.length <= 2
                    ? width *
                        0.25 // ~100 on normal screens
                    : width * 0.6, // ~240 on normal screens
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: width * 0.04, // ~16 on normal screens
                mainAxisSpacing: width * 0.04, // ~16 on normal screens
                childAspectRatio: 1.5,
              ),
              itemCount: metrics.length,
              itemBuilder: (context, index) {
                return _buildMetricCard(
                  metrics[index],
                  width,
                  smallFontSize,
                  tinyFontSize,
                  valueFontSize,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    HealthMetric metric,
    double width,
    double smallFontSize,
    double tinyFontSize,
    double valueFontSize,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.black.withOpacity(0.3),
        border: Border.all(color: metric.color.withOpacity(0.5), width: 1),
      ),
      padding: EdgeInsets.all(width * 0.03), // ~12 on normal screens
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon and category
          Row(
            children: [
              Container(
                width: width * 0.08, // ~32 on normal screens
                height: width * 0.08, // ~32 on normal screens
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: metric.color.withOpacity(0.2),
                ),
                child: Center(
                  child: Icon(
                    metric.icon,
                    color: metric.color,
                    size: width * 0.045,
                  ), // ~18 on normal screens
                ),
              ),
              SizedBox(width: width * 0.02), // ~8 on normal screens
              Text(
                metric.category.toUpperCase(),
                style: TextStyle(
                  fontSize: tinyFontSize,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withOpacity(0.6),
                  letterSpacing: 0.5,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),

          // Value and label
          Padding(
            padding: EdgeInsets.only(
              left: width * 0.01,
            ), // ~4 on normal screens
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  metric.value,
                  style: TextStyle(
                    fontSize: valueFontSize,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: width * 0.005), // ~2 on normal screens
                Text(
                  metric.label,
                  style: TextStyle(
                    fontSize: smallFontSize,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class HealthMetric {
  final String category;
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const HealthMetric({
    required this.category,
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });
}
