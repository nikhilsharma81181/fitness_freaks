import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

class WeightTrackingWidget extends StatefulWidget {
  const WeightTrackingWidget({Key? key}) : super(key: key);

  @override
  State<WeightTrackingWidget> createState() => _WeightTrackingWidgetState();
}

class _WeightTrackingWidgetState extends State<WeightTrackingWidget>
    with SingleTickerProviderStateMixin {
  bool _isSyncing = false;
  bool _showGraph = false;
  late AnimationController _animationController;

  // Mock data for now
  final List<double> _weightEntries = [
    65.0,
    63.5,
    65.0,
    62.0,
    64.0,
    65.0,
    66.5,
    66.0,
    56.7
  ];
  final List<String> _recentDates = ['Mar 28', 'Mar 28', 'Mar 28'];
  final List<String> _recentWeights = ['56.7 kg', '65.1 kg', '64.3 kg'];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    // Animate chart appearance
    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        _showGraph = true;
      });
      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 25),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.15),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Add button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight Tracking',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    _buildAddButton(),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              // Sync indicator
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 4),
                child: InkWell(
                  onTap: _onSyncTap,
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        color: Colors.white.withOpacity(0.5),
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Tap to sync',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 30),

              // Current weight
              AnimatedOpacity(
                opacity: _showGraph ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showGraph ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: _buildWeightSection(),
                ),
              ),

              const SizedBox(height: 24),

              // Weight chart
              AnimatedOpacity(
                opacity: _showGraph ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showGraph ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: _buildWeightChart(),
                ),
              ),

              const SizedBox(height: 16),

              // Recent entries
              AnimatedOpacity(
                opacity: _showGraph ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showGraph ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          'Recent Entries',
                          style: GoogleFonts.inter(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Recent entry items
                      for (int i = 0; i < _recentDates.length; i++)
                        _buildRecentEntryItem(
                            _recentDates[i], _recentWeights[i]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // View All button
              AnimatedOpacity(
                opacity: _showGraph ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 600),
                curve: Curves.easeOut,
                child: AnimatedSlide(
                  offset: _showGraph ? Offset.zero : const Offset(0, 0.2),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOut,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: _buildViewAllButton(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryColor.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 1.0,
        ),
      ),
      child: Row(
        children: [
          Icon(
            CupertinoIcons.camera_fill,
            color: AppColors.primaryColor,
            size: 18,
          ),
          const SizedBox(width: 8),
          Text(
            'Add',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor,
            ),
          ),
        ],
      ),
    );
  }

  void _onSyncTap() {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    _animationController.repeat();

    // Simulate syncing delay
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        _isSyncing = false;
      });
      _animationController.reset();
    });
  }

  Widget _buildWeightSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Weight',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '56.7',
                    style: GoogleFonts.inter(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'kg',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  CupertinoIcons.arrow_down,
                  color: Colors.red,
                  size: 18,
                ),
                const SizedBox(width: 4),
                Text(
                  '8.4 kg',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightChart() {
    return SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 23),
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
            maxX: 8,
            minY: 55,
            maxY: 70,
            lineBarsData: [
              LineChartBarData(
                spots: _weightEntries.asMap().entries.map((entry) {
                  return FlSpot(entry.key.toDouble(), entry.value);
                }).toList(),
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
    );
  }

  Widget _buildRecentEntryItem(String date, String weight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              date,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Text(
              weight,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildViewAllButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'View All Data',
            style: GoogleFonts.inter(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(
            CupertinoIcons.chevron_right,
            color: Colors.black,
            size: 19,
          ),
        ],
      ),
    );
  }
}
