import 'dart:ui';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/diet/presentation/pages/diet_detail_page.dart';

class DietView extends StatefulWidget {
  const DietView({super.key});

  @override
  State<DietView> createState() => _DietViewState();
}

class _DietViewState extends State<DietView> with TickerProviderStateMixin {
  bool _isRefreshing = false;
  late AnimationController _refreshAnimationController;
  late AnimationController _waterAnimationController;
  late AnimationController _calorieAnimationController;

  // Water intake tracking
  int _waterGlasses = 6;
  final int _waterGoal = 8;

  // Calorie tracking
  final int _caloriesConsumed = 1847;
  final int _calorieGoal = 2200;
  final int _caloriesRemaining = 353;

  // Macro tracking
  final Map<String, Map<String, dynamic>> _macros = {
    'protein': {
      'current': 98,
      'goal': 140,
      'color': const Color(0xFF00B3BF),
      'icon': CupertinoIcons.heart_fill,
    },
    'carbs': {
      'current': 142,
      'goal': 180,
      'color': const Color(0xFF05E5B3),
      'icon': CupertinoIcons.leaf_arrow_circlepath,
    },
    'fat': {
      'current': 58,
      'goal': 70,
      'color': const Color(0xFFFF9500),
      'icon': CupertinoIcons.drop_fill,
    },
  };

  // Recent meals
  final List<Map<String, dynamic>> _recentMeals = [
    {
      'name': 'Breakfast',
      'time': '8:30 AM',
      'calories': 420,
      'icon': CupertinoIcons.sunrise_fill,
      'color': const Color(0xFFFF9500),
      'foods': ['Oatmeal with berries', 'Greek yogurt', 'Coffee'],
    },
    {
      'name': 'Lunch',
      'time': '1:15 PM',
      'calories': 650,
      'icon': CupertinoIcons.sun_max_fill,
      'color': const Color(0xFF05E5B3),
      'foods': ['Grilled chicken salad', 'Quinoa', 'Avocado'],
    },
    {
      'name': 'Snack',
      'time': '4:00 PM',
      'calories': 180,
      'icon': CupertinoIcons.hexagon_fill,
      'color': const Color(0xFF8059E6),
      'foods': ['Protein shake', 'Banana'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _waterAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _calorieAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Start calorie animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calorieAnimationController.forward();
    });
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    _waterAnimationController.dispose();
    _calorieAnimationController.dispose();
    super.dispose();
  }

  void _onRefresh() {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
    });

    _refreshAnimationController.repeat();

    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isRefreshing = false;
      });
      _refreshAnimationController.stop();
      _refreshAnimationController.reset();
    });
  }

  void _addWaterGlass() {
    if (_waterGlasses < _waterGoal) {
      HapticFeedback.lightImpact();
      setState(() {
        _waterGlasses++;
      });
      _waterAnimationController.forward().then((_) {
        _waterAnimationController.reverse();
      });
    }
  }

  void _removeWaterGlass() {
    if (_waterGlasses > 0) {
      HapticFeedback.lightImpact();
      setState(() {
        _waterGlasses--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Column(
        children: [
          // Header
          _buildHeader(),

          // Main content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // Daily Calorie Overview
                    _buildCalorieOverview(),

                    const SizedBox(height: 20),

                    // Quick Actions Row
                    _buildQuickActions(),

                    const SizedBox(height: 20),

                    // Macro Distribution
                    _buildMacroDistribution(),

                    const SizedBox(height: 20),

                    // Recent Meals
                    _buildRecentMeals(),

                    const SizedBox(height: 140),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nutrition',
                style: GoogleFonts.inter(
                  fontSize: 32,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Track your daily nutrition goals',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: _onRefresh,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Center(
                child: _isRefreshing
                    ? SizedBox(
                        width: 18,
                        height: 18,
                        child: RotationTransition(
                          turns: _refreshAnimationController,
                          child: const Icon(
                            CupertinoIcons.arrow_2_circlepath,
                            color: Colors.white,
                            size: 14,
                          ),
                        ),
                      )
                    : const Icon(
                        CupertinoIcons.arrow_2_circlepath,
                        color: Colors.white,
                        size: 14,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalorieOverview() {
    final calorieProgress = _caloriesConsumed / _calorieGoal;
    final waterProgress = _waterGlasses / _waterGoal;

    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.glassBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppColors.glassBorder,
              width: 1.5,
            ),
          ),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Daily Progress',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  Row(
                    children: [
                      // Calorie percentage
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.vibrantMint.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: AppColors.vibrantMint.withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${(calorieProgress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppColors.vibrantMint,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Water percentage
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00B3BF).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF00B3BF).withOpacity(0.3),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          '${(waterProgress * 100).toInt()}%',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00B3BF),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Apple Watch Style Rings
              AnimatedBuilder(
                animation: _calorieAnimationController,
                builder: (context, child) {
                  return GestureDetector(
                    onTap: () {
                      // Tap to add water glass
                      _addWaterGlass();
                    },
                    onLongPress: () {
                      // Long press to remove water glass
                      _removeWaterGlass();
                    },
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: Stack(
                        children: [
                          // Custom Paint for dual rings
                          CustomPaint(
                            size: const Size(200, 200),
                            painter: AppleWatchRingsPainter(
                              calorieProgress: calorieProgress *
                                  _calorieAnimationController.value,
                              waterProgress: waterProgress *
                                  _calorieAnimationController.value,
                              calorieColor: AppColors.vibrantMint,
                              waterColor: const Color(0xFF00B3BF),
                            ),
                          ),
                          // Center content
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Calories
                                Text(
                                  '$_caloriesConsumed',
                                  style: GoogleFonts.inter(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  'calories',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.7),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Water
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      CupertinoIcons.drop_fill,
                                      color: const Color(0xFF00B3BF),
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$_waterGlasses / $_waterGoal',
                                      style: GoogleFonts.inter(
                                        fontSize: 14,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Legend
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Calories legend
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: AppColors.vibrantMint,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calories',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            'Goal: $_calorieGoal',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  // Water legend
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF00B3BF),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Water',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                          Text(
                            'Goal: $_waterGoal glasses',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        // Scan Food
        Expanded(
          child: _buildQuickActionCard(
            icon: CupertinoIcons.camera_fill,
            title: 'Scan Food',
            subtitle: 'Use camera',
            color: AppColors.vibrantMint,
            onTap: () {
              _showScanFoodModal();
            },
          ),
        ),

        const SizedBox(width: 12),

        // Log Meal
        Expanded(
          child: _buildQuickActionCard(
            icon: CupertinoIcons.add_circled_solid,
            title: 'Log Meal',
            subtitle: 'Add manually',
            color: const Color(0xFF8059E6),
            onTap: () {
              _showAddMealModal();
            },
          ),
        ),

        const SizedBox(width: 12),

        // View History
        Expanded(
          child: _buildQuickActionCard(
            icon: CupertinoIcons.chart_bar_alt_fill,
            title: 'History',
            subtitle: 'Past meals',
            color: const Color(0xFF00B3BF),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const DietDetailPage(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
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
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 20,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMacroDistribution() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.vibrantMint.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      CupertinoIcons.chart_pie_fill,
                      color: AppColors.vibrantMint,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Macro Distribution',
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Macro rows
              ..._macros.entries.map((entry) {
                final macroName = entry.key;
                final macroData = entry.value;
                final current = macroData['current'] as int;
                final goal = macroData['goal'] as int;
                final color = macroData['color'] as Color;
                final icon = macroData['icon'] as IconData;
                final progress = current / goal;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMacroRow(
                      name: macroName.toUpperCase(),
                      current: current,
                      goal: goal,
                      progress: progress,
                      color: color,
                      icon: icon,
                    ),
                    if (macroName != _macros.keys.last)
                      const SizedBox(height: 12),
                  ],
                );
              }).toList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMacroRow({
    required String name,
    required int current,
    required int goal,
    required double progress,
    required Color color,
    required IconData icon,
  }) {
    return Column(
      children: [
        // Header row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Text(
                  name,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            Text(
              '${current}g / ${goal}g',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        // Progress bar - properly aligned from left
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 8,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  height: 8,
                  width: constraints.maxWidth * progress.clamp(0.0, 1.0),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildRecentMeals() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Meals',
              style: GoogleFonts.inter(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const DietDetailPage(),
                  ),
                );
              },
              child: Text(
                'View All',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.vibrantMint,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 16),

        // Meals list
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.glassBackground,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.glassBorder,
                  width: 1.5,
                ),
              ),
              child: Column(
                children: _recentMeals.asMap().entries.map((entry) {
                  final index = entry.key;
                  final meal = entry.value;
                  final isLast = index == _recentMeals.length - 1;

                  return _buildMealItem(meal, isLast);
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMealItem(Map<String, dynamic> meal, bool isLast) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: isLast
            ? null
            : Border(
                bottom: BorderSide(
                  color: Colors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
      ),
      child: Row(
        children: [
          // Meal icon
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: (meal['color'] as Color).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                meal['icon'] as IconData,
                color: meal['color'] as Color,
                size: 24,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Meal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name and time
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal['name'],
                      style: GoogleFonts.inter(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      meal['time'],
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 4),

                // Calories
                Text(
                  '${meal['calories']} calories',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: meal['color'] as Color,
                  ),
                ),

                const SizedBox(height: 8),

                // Foods
                Text(
                  (meal['foods'] as List<String>).join(' • '),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.6),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddMealModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Add Meal',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),

                // Meal type options
                _buildMealTypeOption('Breakfast', CupertinoIcons.sunrise_fill,
                    const Color(0xFFFF9500)),
                _buildMealTypeOption('Lunch', CupertinoIcons.sun_max_fill,
                    const Color(0xFF05E5B3)),
                _buildMealTypeOption('Dinner', CupertinoIcons.moon_stars_fill,
                    const Color(0xFF00B3BF)),
                _buildMealTypeOption('Snack', CupertinoIcons.hexagon_fill,
                    const Color(0xFF8059E6)),

                const SizedBox(height: 16),

                // Cancel button
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeOption(String name, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$name logging coming soon!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.black.withOpacity(0.8),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 20,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    name,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: Colors.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showScanFoodModal() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.glassBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(
                color: AppColors.glassBorder,
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 20),

                // Title
                Text(
                  'Scan Food',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Choose how to scan your food',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 24),

                // Scan options
                _buildScanOption(
                  'Barcode Scanner',
                  'Scan product barcode',
                  CupertinoIcons.qrcode_viewfinder,
                  AppColors.vibrantMint,
                ),
                _buildScanOption(
                  'Food Recognition',
                  'Take photo of your meal',
                  CupertinoIcons.camera_fill,
                  const Color(0xFF8059E6),
                ),
                _buildScanOption(
                  'Receipt Scanner',
                  'Scan restaurant receipt',
                  CupertinoIcons.doc_text_viewfinder,
                  const Color(0xFF00B3BF),
                ),

                const SizedBox(height: 16),

                // Cancel button
                Container(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      backgroundColor: Colors.white.withOpacity(0.1),
                    ),
                    child: Text(
                      'Cancel',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanOption(
      String title, String subtitle, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          icon,
                          color: color,
                          size: 14,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$title coming soon!',
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                backgroundColor: Colors.black.withOpacity(0.8),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                margin: const EdgeInsets.all(16),
              ),
            );
          },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 24,
                    color: color,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: Colors.white.withOpacity(0.4),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Custom painter for circular progress
class CircularProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;

  CircularProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    const startAngle = -pi / 2;
    final sweepAngle = 2 * pi * progress;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Custom painter for Apple Watch style dual rings
class AppleWatchRingsPainter extends CustomPainter {
  final double calorieProgress;
  final double waterProgress;
  final Color calorieColor;
  final Color waterColor;

  AppleWatchRingsPainter({
    required this.calorieProgress,
    required this.waterProgress,
    required this.calorieColor,
    required this.waterColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 12.0;
    const ringGap = 8.0;

    // Outer ring (Calories) - larger radius
    final outerRadius = (size.width - strokeWidth) / 2;
    final outerPaint = Paint()
      ..color = calorieColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Outer ring background
    final outerBackgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    // Inner ring (Water) - smaller radius
    final innerRadius = outerRadius - strokeWidth - ringGap;
    final innerPaint = Paint()
      ..color = waterColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Inner ring background
    final innerBackgroundPaint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    const startAngle = -pi / 2; // Start from top

    // Draw background rings
    canvas.drawCircle(center, outerRadius, outerBackgroundPaint);
    canvas.drawCircle(center, innerRadius, innerBackgroundPaint);

    // Draw progress rings
    // Outer ring (Calories)
    final outerSweepAngle = 2 * pi * calorieProgress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: outerRadius),
      startAngle,
      outerSweepAngle,
      false,
      outerPaint,
    );

    // Inner ring (Water)
    final innerSweepAngle = 2 * pi * waterProgress.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: innerRadius),
      startAngle,
      innerSweepAngle,
      false,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
