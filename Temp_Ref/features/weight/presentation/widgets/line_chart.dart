import 'package:flutter/material.dart';
import 'package:fitness_freaks/features/weight/domain/entities/weight_entry.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

/// A custom line chart for weight data visualization
class WeightLineChart extends StatefulWidget {
  final List<WeightEntryEntity> entries;
  final Color lineColor;
  final Color gradientColor;
  final bool showDots;
  final bool animate;
  final Function(WeightEntryEntity)? onDotTap;

  const WeightLineChart({
    Key? key,
    required this.entries,
    this.lineColor = Colors.tealAccent,
    this.gradientColor = Colors.teal,
    this.showDots = true,
    this.animate = true,
    this.onDotTap,
  }) : super(key: key);

  @override
  State<WeightLineChart> createState() => _WeightLineChartState();
}

class _WeightLineChartState extends State<WeightLineChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  // Tooltip state
  WeightEntryEntity? _selectedEntry;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();

    // Setup animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    );

    if (widget.animate) {
      _animationController.forward();
    } else {
      _animationController.value = 1.0;
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(WeightLineChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset animation if data changes
    if (oldWidget.entries != widget.entries) {
      _animationController.reset();
      if (widget.animate) {
        _animationController.forward();
      } else {
        _animationController.value = 1.0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.entries.isEmpty) {
      return const Center(
        child: Text(
          'No weight data available',
          style: TextStyle(color: Colors.white70),
        ),
      );
    }

    // Sort entries by date (oldest first for chart)
    final sortedEntries = List<WeightEntryEntity>.from(widget.entries)
      ..sort((a, b) => a.dateObject.compareTo(b.dateObject));

    // Find min and max values for Y-axis
    double minWeight =
        sortedEntries.map((e) => e.weight).reduce((a, b) => a < b ? a : b);
    double maxWeight =
        sortedEntries.map((e) => e.weight).reduce((a, b) => a > b ? a : b);

    // Add some padding to min/max
    final range = maxWeight - minWeight;
    minWeight = minWeight - (range * 0.1);
    maxWeight = maxWeight + (range * 0.1);

    // Ensure we don't go negative
    minWeight = minWeight < 0 ? 0 : minWeight;

    return Stack(
      children: [
        AnimatedBuilder(
          animation: _animation,
          builder: (context, _) {
            return LineChart(
              LineChartData(
                gridData: _buildGridData(),
                titlesData: _buildTitlesData(sortedEntries),
                borderData: _buildBorderData(),
                minX: 0,
                maxX: sortedEntries.length - 1.0,
                minY: minWeight,
                maxY: maxWeight,
                lineTouchData: _buildLineTouchData(sortedEntries),
                lineBarsData: [
                  _buildLineChartBarData(sortedEntries, _animation.value),
                ],
              ),
            );
          },
        ),

        // Custom tooltip
        if (_selectedEntry != null && _tapPosition != null)
          Positioned(
            left: _tapPosition!.dx - 75,
            top: _tapPosition!.dy - 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    DateFormat('MMM d, yyyy')
                        .format(_selectedEntry!.dateObject),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_selectedEntry!.weight.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: widget.lineColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  FlGridData _buildGridData() {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: 5,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: Colors.white10,
          strokeWidth: 1,
        );
      },
    );
  }

  FlTitlesData _buildTitlesData(List<WeightEntryEntity> entries) {
    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 30,
          getTitlesWidget: (value, meta) {
            // Show labels for first, middle, and last entries
            final index = value.toInt();
            if (index == 0 ||
                index == entries.length - 1 ||
                index == (entries.length ~/ 2)) {
              final date = entries[index].dateObject;
              final label = DateFormat('MMM d').format(date);
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white60,
                    fontSize: 10,
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          reservedSize: 40,
          getTitlesWidget: (value, meta) {
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Text(
                value.toInt().toString(),
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 10,
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(showTitles: false),
      ),
    );
  }

  FlBorderData _buildBorderData() {
    return FlBorderData(
      show: true,
      border: Border(
        bottom: BorderSide(color: Colors.white24, width: 1),
        left: BorderSide(color: Colors.white24, width: 1),
      ),
    );
  }

  LineTouchData _buildLineTouchData(List<WeightEntryEntity> entries) {
    return LineTouchData(
      enabled: true,
      touchTooltipData: LineTouchTooltipData(
        tooltipPadding: EdgeInsets.zero,
        tooltipMargin: 8,
        // getTooltipItems: (_) {}, // We're using custom tooltip
      ),
      touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
        if (event is FlTapUpEvent &&
            touchResponse != null &&
            touchResponse.lineBarSpots != null) {
          final spotIndex = touchResponse.lineBarSpots!.first.spotIndex;
          setState(() {
            _selectedEntry = entries[spotIndex];
            _tapPosition = event.localPosition;
          });

          if (widget.onDotTap != null) {
            widget.onDotTap!(entries[spotIndex]);
          }
        }
      },
      handleBuiltInTouches: true,
    );
  }

  LineChartBarData _buildLineChartBarData(
      List<WeightEntryEntity> entries, double animationValue) {
    final spots = <FlSpot>[];

    for (int i = 0; i < entries.length; i++) {
      if (i < entries.length * animationValue) {
        spots.add(FlSpot(i.toDouble(), entries[i].weight));
      }
    }

    return LineChartBarData(
      spots: spots,
      isCurved: true,
      curveSmoothness: 0.35,
      color: widget.lineColor,
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: widget.showDots,
        getDotPainter: (spot, percent, barData, index) {
          return FlDotCirclePainter(
            radius: 5,
            color: Colors.white,
            strokeWidth: 2,
            strokeColor: widget.lineColor,
          );
        },
      ),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          colors: [
            widget.gradientColor.withOpacity(0.4),
            widget.gradientColor.withOpacity(0.0),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
