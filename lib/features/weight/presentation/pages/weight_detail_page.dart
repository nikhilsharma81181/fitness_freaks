import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class WeightDetailPage extends StatefulWidget {
  const WeightDetailPage({super.key});

  @override
  State<WeightDetailPage> createState() => _WeightDetailPageState();
}

class _WeightDetailPageState extends State<WeightDetailPage>
    with SingleTickerProviderStateMixin {
  int _selectedTimeRangeIndex = 0;
  final List<String> _timeRanges = [
    'Week',
    'Month',
    '3 Months',
    'Year',
    '3 Years'
  ];
  bool _isRefreshing = false;
  late AnimationController _refreshAnimationController;

  // Mock data for the weight entries
  final List<Map<String, dynamic>> _entries = List.generate(
    19,
    (index) => {
      'date': '2 Jun 2025',
      'weight': index == 10
          ? 56.7
          : index == 18
              ? 65.1
              : 63.0 + (index % 7) * 0.3,
    },
  );

  // Mock data for weight chart
  final List<FlSpot> _weightSpots = [
    const FlSpot(0, 63.4),
    const FlSpot(1, 62.1),
    const FlSpot(2, 63.8),
    const FlSpot(3, 62.8),
    const FlSpot(4, 64.1),
    const FlSpot(5, 64.9),
    const FlSpot(6, 65.1),
    const FlSpot(7, 64.5),
    const FlSpot(8, 56.7), // Dramatic drop
    const FlSpot(9, 63.0),
    const FlSpot(10, 61.8),
    const FlSpot(11, 63.5),
    const FlSpot(12, 62.2),
    const FlSpot(13, 63.8),
    const FlSpot(14, 63.3),
    const FlSpot(15, 63.2),
    const FlSpot(16, 63.0),
    const FlSpot(17, 62.8),
    const FlSpot(18, 63.7),
  ];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Custom dark green background
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF0E221E), // Custom dark green
                  const Color(0xFF0A1A17), // Slightly darker for depth
                  Colors.black,
                ],
                center: Alignment.topRight,
                radius: 1.5,
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button, title and refresh button
                _buildHeader(),

                // Time range selector
                _buildTimeRangeSelector(),

                // Main content - scrollable
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 24),

                          // Weight trend section
                          _buildSectionTitle('Weight Trend'),
                          const SizedBox(height: 16),
                          _buildWeightTrendCard(),

                          const SizedBox(height: 32),

                          // Statistics section
                          _buildSectionTitle('Statistics'),
                          const SizedBox(height: 16),
                          _buildStatisticsRow(),

                          const SizedBox(height: 32),

                          // All entries section
                          _buildAllEntriesHeader(),
                          const SizedBox(height: 16),
                          _buildAllEntriesList(),

                          // Bottom padding
                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Back button
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: const Icon(
              CupertinoIcons.back,
              color: Colors.white,
              size: 28,
            ),
          ),

          // Title
          Text(
            'Weight History',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          // Refresh button
          GestureDetector(
            onTap: _onRefresh,
            child: _isRefreshing
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: RotationTransition(
                      turns: _refreshAnimationController,
                      child: const Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  )
                : const Icon(
                    CupertinoIcons.arrow_2_circlepath,
                    color: Colors.white,
                    size: 24,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Time Range',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _timeRanges.length,
              itemBuilder: (context, index) {
                final isSelected = _selectedTimeRangeIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedTimeRangeIndex = index;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: isSelected
                          ? null
                          : Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child: Center(
                      child: Text(
                        _timeRanges[index],
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isSelected ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Widget _buildWeightTrendCard() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            // Current weight and change row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Current weight
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '63.7',
                          style: GoogleFonts.inter(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'kg',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Change
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Change',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          CupertinoIcons.arrow_down,
                          color: AppColors.primaryColor,
                          size: 20,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '0.6 kg',
                          style: GoogleFonts.inter(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),

            // Divider
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Divider(
                color: Colors.white.withOpacity(0.1),
                height: 1,
              ),
            ),

            // Weight chart
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  // Y-axis labels on the right
                  Positioned(
                    top: 0,
                    right: 0,
                    bottom: 0,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '65.1',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '63.0',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '60.9',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '58.8',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        Text(
                          '56.7',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Chart
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: LineChart(
                      LineChartData(
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: 2.5,
                          getDrawingHorizontalLine: (value) {
                            return FlLine(
                              color: Colors.white.withOpacity(0.1),
                              strokeWidth: 1,
                            );
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: false,
                        ),
                        borderData: FlBorderData(show: false),
                        minX: 0,
                        maxX: 18,
                        minY: 56,
                        maxY: 66,
                        lineBarsData: [
                          LineChartBarData(
                            spots: _weightSpots,
                            isCurved: true,
                            color: AppColors.primaryColor,
                            barWidth: 3,
                            isStrokeCapRound: true,
                            dotData: FlDotData(
                              show: true,
                              getDotPainter: (spot, percent, barData, index) {
                                return FlDotCirclePainter(
                                  radius: 3,
                                  color: Colors.white,
                                  strokeColor: AppColors.primaryColor,
                                  strokeWidth: 1,
                                );
                              },
                            ),
                            belowBarData: BarAreaData(
                              show: true,
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  AppColors.primaryColor.withOpacity(0.3),
                                  AppColors.primaryColor.withOpacity(0.1),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        ],
                        lineTouchData: LineTouchData(
                          touchTooltipData: LineTouchTooltipData(
                            tooltipBgColor: Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsRow() {
    return Row(
      children: [
        // Average
        Expanded(
          child: _buildStatCard(
            icon: Icons.scale,
            iconColor: AppColors.primaryColor,
            title: 'Average',
            value: '63.5',
            unit: 'kg',
          ),
        ),
        const SizedBox(width: 12),

        // Highest
        Expanded(
          child: _buildStatCard(
            icon: Icons.arrow_upward,
            iconColor: Colors.red,
            title: 'Highest',
            value: '65.1',
            unit: 'kg',
          ),
        ),
        const SizedBox(width: 12),

        // Lowest
        Expanded(
          child: _buildStatCard(
            icon: Icons.arrow_downward,
            iconColor: AppColors.primaryColor,
            title: 'Lowest',
            value: '56.7',
            unit: 'kg',
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required String unit,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: iconColor,
              size: 28,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  value,
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 2),
                Text(
                  unit,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAllEntriesHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'All Entries',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          '19 records',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white.withOpacity(0.6),
          ),
        ),
      ],
    );
  }

  Widget _buildAllEntriesList() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.1),
            width: 1.0,
          ),
        ),
        child: ListView.separated(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: _entries.length,
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.white.withOpacity(0.1),
              height: 1,
            );
          },
          itemBuilder: (context, index) {
            final entry = _entries[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    entry['date'],
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${entry['weight'].toStringAsFixed(1)} kg',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onRefresh() {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    // Start rotation animation
    _refreshAnimationController.repeat();

    // Simulate refreshing delay
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isRefreshing = false;
      });
      // Stop rotation animation
      _refreshAnimationController.stop();
      _refreshAnimationController.reset();
    });
  }
}
