import 'dart:ui';
import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_card.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:image_picker/image_picker.dart';

class WeightDataWidget extends StatefulWidget {
  final List<double> weightData;
  final List<String> dates;
  final double currentWeight;
  final String unit;

  const WeightDataWidget({
    Key? key,
    required this.weightData,
    required this.dates,
    required this.currentWeight,
    this.unit = 'kg',
  }) : super(key: key);

  @override
  State<WeightDataWidget> createState() => _WeightDataWidgetState();
}

class _WeightDataWidgetState extends State<WeightDataWidget>
    with SingleTickerProviderStateMixin {
  List<Color> gradientColors = [Pallate.vibrantMint, Pallate.accentBlue];

  bool showAvg = false;
  List<FlSpot> spots = [];
  List<FlSpot> animatedSpots = [];

  // For touchedIndex tracking
  LineChartBarData? touchedBarData;
  int touchedIndex = -1;

  // Animation controllers
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Convert weight data to FlSpots
    spots = List.generate(
      widget.weightData.length,
      (index) => FlSpot(index.toDouble(), widget.weightData[index]),
    );

    // Initialize empty spots for animation
    animatedSpots = [];

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );

    // Simulate loading
    Future.delayed(const Duration(milliseconds: 600), () {
      setState(() {
        _isLoading = false;
      });
      _startAnimation();
    });
  }

  void _startAnimation() {
    _animationController.forward();

    // Animate spots appearing one by one
    for (int i = 0; i < spots.length; i++) {
      Future.delayed(Duration(milliseconds: 100 + (i * 50)), () {
        if (mounted) {
          setState(() {
            if (i < spots.length) {
              animatedSpots.add(spots[i]);
            }
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get screen width for responsive sizing
    double width = MediaQuery.of(context).size.width;

    // Derive responsive font sizes
    final titleFontSize = width * 0.05; // ~20 on normal screens
    final subtitleFontSize = width * 0.04; // ~16 on normal screens
    final weightFontSize = width * 0.09; // ~36 on normal screens
    final unitFontSize = width * 0.045; // ~18 on normal screens
    final smallFontSize = width * 0.035; // ~14 on normal screens
    final tinyFontSize = width * 0.03; // ~12 on normal screens

    return GlassCard(
      cornerRadius: 28,
      transparency: 0.9,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with weight information
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _fadeAnimation.value) * -20),
                  child: child,
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current weight display
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Current Weight",
                      style: TextStyle(
                        fontSize: subtitleFontSize,
                        fontWeight: FontWeight.w400,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: width * 0.01), // ~4 on normal screens
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.currentWeight.toString(),
                          style: TextStyle(
                            fontSize: weightFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: width * 0.01), // ~4 on normal screens
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: width * 0.015,
                          ), // ~6 on normal screens
                          child: Text(
                            widget.unit,
                            style: TextStyle(
                              fontSize: unitFontSize,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Camera button
                _buildCameraButton(context, width),
              ],
            ),
          ),

          SizedBox(height: width * 0.06), // ~24 on normal screens
          // Buttons to toggle between view modes
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset((1 - _fadeAnimation.value) * 50, 0),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.only(
                right: width * 0.025,
              ), // ~10 on normal screens
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      setState(() {
                        showAvg = !showAvg;
                      });
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:
                          showAvg
                              ? Pallate.accentGreen.withOpacity(0.2)
                              : Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: BorderSide(
                          color:
                              showAvg
                                  ? Pallate.accentGreen
                                  : Colors.transparent,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Text(
                      'Show Average',
                      style: TextStyle(
                        color:
                            showAvg
                                ? Pallate.accentGreen
                                : Colors.white.withOpacity(0.6),
                        fontSize: tinyFontSize,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: width * 0.02), // ~8 on normal screens
          // Weight trend line chart
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _slideAnimation.value) * 30),
                  child: child,
                ),
              );
            },
            child: SizedBox(
              height: width * 0.5, // ~200 on normal screens
              child:
                  _isLoading
                      ? _buildShimmerLoading()
                      : Stack(
                        children: [
                          // Chart
                          LineChart(
                            showAvg
                                ? _avgData()
                                : _mainData(width, tinyFontSize),
                            duration: const Duration(milliseconds: 350),
                            curve: Curves.easeInOutCubic,
                          ),

                          // Optional overlay elements
                          if (!showAvg &&
                              touchedIndex >= 0 &&
                              touchedIndex < widget.dates.length)
                            Positioned(
                              top: 0,
                              right: width * 0.05, // ~20 on normal screens
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal:
                                      width * 0.03, // ~12 on normal screens
                                  vertical:
                                      width * 0.015, // ~6 on normal screens
                                ),
                                decoration: BoxDecoration(
                                  color: Pallate.cardBackground.withOpacity(
                                    0.7,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                    width: 0.5,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      widget.dates[touchedIndex],
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: tinyFontSize,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    SizedBox(
                                      height: width * 0.005,
                                    ), // ~2 on normal screens
                                    Text(
                                      '${widget.weightData[touchedIndex]} ${widget.unit}',
                                      style: TextStyle(
                                        color: gradientColors[0],
                                        fontSize: smallFontSize,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
            ),
          ),

          SizedBox(height: width * 0.04), // ~16 on normal screens
          // Month label
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _fadeAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, (1 - _fadeAnimation.value) * 20),
                  child: child,
                ),
              );
            },
            child: Center(
              child: Text(
                "This Month",
                style: TextStyle(
                  fontSize: smallFontSize,
                  fontWeight: FontWeight.w500,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerLoading() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Shimmer effect for chart
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ShimmerLoadingEffect(),
          ),
        ),
        // Shimmer effect for bottom labels
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            5,
            (index) => Container(
              width: 25,
              height: 10,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _mainData([double width = 400, double fontSize = 12]) {
    // Calculate min and max values with padding
    final minY =
        (widget.weightData.reduce((curr, next) => curr < next ? curr : next) -
            2);
    final maxY =
        (widget.weightData.reduce((curr, next) => curr > next ? curr : next) +
            2);

    // Ensure we have valid spots
    if (animatedSpots.isEmpty) {
      // If no valid spots, create a default spot to prevent the error
      animatedSpots = [
        FlSpot(0, widget.weightData.isNotEmpty ? widget.weightData[0] : 0),
      ];
    }

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
            dashArray: [5, 5], // Make lines dashed
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (widget.dates.length / 5).ceil().toDouble(),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < widget.dates.length) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: width * 0.02,
                  ), // ~8 on normal screens
                  child: Text(
                    widget.dates[value.toInt()],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 40,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (widget.weightData.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Pallate.cardBackground.withOpacity(0.8),
          tooltipRoundedRadius: 12,
          tooltipPadding: const EdgeInsets.all(8),
          tooltipBorder: BorderSide(
            color: Colors.white.withOpacity(0.2),
            width: 1,
          ),
          getTooltipItems: (List<LineBarSpot> touchedSpots) {
            return touchedSpots.map((spot) {
              final index = spot.x.toInt();
              final value = widget.weightData[index];
              return LineTooltipItem(
                '${value.toStringAsFixed(1)} ${widget.unit}',
                TextStyle(
                  color: gradientColors[0],
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 1.2,
                ),
                children: [
                  TextSpan(
                    text: '\n${widget.dates[index]}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.normal,
                      fontSize: fontSize,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
        touchCallback: (FlTouchEvent event, LineTouchResponse? touchResponse) {
          setState(() {
            if (event is FlPanEndEvent ||
                event is FlPointerExitEvent ||
                touchResponse == null ||
                touchResponse.lineBarSpots == null ||
                touchResponse.lineBarSpots!.isEmpty) {
              touchedIndex = -1;
              touchedBarData = null;
            } else {
              touchedIndex = touchResponse.lineBarSpots![0].x.toInt();
              touchedBarData = touchResponse.lineBarSpots![0].bar;
            }
          });
        },
        handleBuiltInTouches: true,
        getTouchedSpotIndicator: (barData, spotIndexes) {
          return spotIndexes.map((spotIndex) {
            return TouchedSpotIndicatorData(
              FlLine(
                color: Colors.white.withOpacity(0.3),
                strokeWidth: 2,
                dashArray: [3, 3], // Make line dashed
              ),
              FlDotData(
                getDotPainter: (spot, percent, barData, index) {
                  return FlDotCirclePainter(
                    radius: 6,
                    color: Colors.white,
                    strokeWidth: 2,
                    strokeColor: gradientColors[0],
                  );
                },
              ),
            );
          }).toList();
        },
      ),
      lineBarsData: [
        LineChartBarData(
          spots: animatedSpots, // Use animated spots for progressive drawing
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          barWidth: 3,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: gradientColors[1],
                strokeWidth: 1,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                gradientColors[0].withOpacity(0.3),
                gradientColors[1].withOpacity(0.1),
                Colors.transparent,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
    );
  }

  LineChartData _avgData() {
    double width = MediaQuery.of(context).size.width;
    final fontSize = width * 0.03; // ~12 on normal screens

    // Calculate average weight
    double avgWeight =
        widget.weightData.reduce((a, b) => a + b) / widget.weightData.length;

    // Create a flat line at the average value
    final List<FlSpot> avgSpots = List.generate(
      widget.weightData.length,
      (index) => FlSpot(index.toDouble(), avgWeight),
    );

    // Ensure we have at least one spot
    if (avgSpots.isEmpty) {
      avgSpots.add(FlSpot(0, avgWeight));
    }

    // Calculate min and max values with padding
    final minY =
        (widget.weightData.reduce((curr, next) => curr < next ? curr : next) -
            2);
    final maxY =
        (widget.weightData.reduce((curr, next) => curr > next ? curr : next) +
            2);

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        horizontalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.white.withOpacity(0.1),
            strokeWidth: 1,
            dashArray: [5, 5],
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: (widget.dates.length / 5).ceil().toDouble(),
            getTitlesWidget: (value, meta) {
              if (value.toInt() >= 0 && value.toInt() < widget.dates.length) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: width * 0.02,
                  ), // ~8 on normal screens
                  child: Text(
                    widget.dates[value.toInt()],
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                      fontSize: fontSize,
                    ),
                  ),
                );
              }
              return const SizedBox();
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 2,
            getTitlesWidget: (value, meta) {
              if (value.toInt() == avgWeight.round()) {
                // Highlight the average value
                return Text(
                  '${value.toInt()} (avg)',
                  style: TextStyle(
                    color: Pallate.accentGreen,
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                  ),
                  textAlign: TextAlign.left,
                );
              }
              return Text(
                value.toInt().toString(),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontWeight: FontWeight.w400,
                  fontSize: fontSize,
                ),
                textAlign: TextAlign.left,
              );
            },
            reservedSize: 60,
          ),
        ),
      ),
      lineTouchData: const LineTouchData(enabled: false),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: (widget.weightData.length - 1).toDouble(),
      minY: minY,
      maxY: maxY,
      lineBarsData: [
        LineChartBarData(
          spots: animatedSpots, // Use animated spots for progressive drawing
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.3),
              Colors.white.withOpacity(0.15),
            ],
          ),
          barWidth: 2,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [Colors.white.withOpacity(0.1), Colors.transparent],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        // Average line
        LineChartBarData(
          spots: avgSpots.sublist(
            0,
            (animatedSpots.length / spots.length * avgSpots.length)
                .round()
                .clamp(0, avgSpots.length),
          ),
          isCurved: false,
          color: Pallate.accentGreen,
          barWidth: 2.5,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false),
          dashArray: [4, 4], // Make the average line dashed
        ),
      ],
    );
  }

  Widget _buildCameraButton(BuildContext context, double width) {
    final buttonFontSize = width * 0.035; // ~14 on normal screens

    return GestureDetector(
      onTap: () async {
        final ImagePicker picker = ImagePicker();
        await picker.pickImage(source: ImageSource.camera);
      },
      child: Container(
        padding: EdgeInsets.all(width * 0.03), // ~12 on normal screens
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Pallate.accentBlue.withOpacity(0.2),
          border: Border.all(
            color: Pallate.accentBlue.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.camera_alt_rounded,
              color: Colors.white.withOpacity(0.9),
              size: width * 0.05, // ~20 on normal screens
            ),
            SizedBox(width: width * 0.02), // ~8 on normal screens
            Text(
              "Add Weight",
              style: TextStyle(
                fontSize: buttonFontSize,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Shimmer loading effect
class ShimmerLoadingEffect extends StatefulWidget {
  const ShimmerLoadingEffect({Key? key}) : super(key: key);

  @override
  State<ShimmerLoadingEffect> createState() => _ShimmerLoadingEffectState();
}

class _ShimmerLoadingEffectState extends State<ShimmerLoadingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController.unbounded(vsync: this)
      ..repeat(min: -0.5, max: 1.5, period: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerController,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                Colors.transparent,
                Colors.white.withOpacity(0.1),
                Colors.transparent,
              ],
              stops: const [0.0, 0.5, 1.0],
              begin: Alignment(_shimmerController.value - 1, 0),
              end: Alignment(_shimmerController.value + 1, 0),
            ).createShader(bounds);
          },
          child: CustomPaint(
            painter: ShimmerChartPainter(),
            size: Size.infinite,
          ),
        );
      },
    );
  }
}

class ShimmerChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white.withOpacity(0.1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final path = Path();

    // Create a wavy path to simulate a chart line
    path.moveTo(0, size.height * 0.7);

    for (int i = 0; i < 10; i++) {
      final x = size.width * (i / 10);
      final nextX = size.width * ((i + 1) / 10);
      final yVariation = (i % 2 == 0) ? 0.6 : 0.4;
      path.quadraticBezierTo(
        x + (nextX - x) / 2,
        size.height * yVariation,
        nextX,
        size.height * 0.5,
      );
    }

    canvas.drawPath(path, paint);

    // Draw horizontal lines to simulate grid
    final gridPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1;

    for (int i = 1; i < 5; i++) {
      final y = size.height * (i / 5);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
