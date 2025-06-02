import 'dart:ui';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fl_chart/fl_chart.dart';

class DietDetailPage extends StatefulWidget {
  const DietDetailPage({super.key});

  @override
  State<DietDetailPage> createState() => _DietDetailPageState();
}

class _DietDetailPageState extends State<DietDetailPage>
    with TickerProviderStateMixin {
  // UI state
  int _selectedTimeRangeIndex = 1; // default to Week
  int _selectedMealTypeIndex = 0; // default to All Meals
  bool _isRefreshing = false;
  bool _showSortOptions = false;
  String _sortOrder = 'Newest First';
  late List<String> _sortOptions = [
    'Newest First',
    'Oldest First',
    'Highest Calories',
    'Lowest Calories'
  ];

  // Animation controllers
  late AnimationController _refreshAnimationController;
  late AnimationController _macroAnimationController;
  late AnimationController _sortDropdownAnimationController;
  late AnimationController _mealListAnimationController;

  // Dropdown animation
  late Animation<double> _dropdownAnimation;
  late Animation<double> _dropdownOpacityAnimation;

  // Meal list animations
  late Animation<double> _mealListAnimation;

  // Macro animations
  late Animation<double> _proteinAnimation;
  late Animation<double> _carbsAnimation;
  late Animation<double> _fatAnimation;

  // Current macro values for animation
  double _currentProtein = 0.0;
  double _currentCarbs = 0.0;
  double _currentFat = 0.0;

  // Filter options
  final List<String> _timeRanges = ['Today', 'Week', 'Month', '3 Months'];
  final List<String> _mealTypes = [
    'All Meals',
    'Breakfast',
    'Lunch',
    'Dinner',
    'Snack'
  ];

  // Mock data
  final List<Map<String, dynamic>> _mealEntries = [
    {
      'type': 'Breakfast',
      'calories': 450,
      'date': '2 Jun 2025',
      'protein': 25,
      'carbs': 35,
      'fat': 15,
      'icon': CupertinoIcons.sunrise_fill,
      'color': const Color(0xFFFF9500), // Orange
    },
    {
      'type': 'Lunch',
      'calories': 650,
      'date': '2 Jun 2025',
      'protein': 40,
      'carbs': 50,
      'fat': 20,
      'icon': CupertinoIcons.sun_max_fill,
      'color': const Color(0xFF05E5B3), // Green
    },
    {
      'type': 'Dinner',
      'calories': 550,
      'date': '2 Jun 2025',
      'protein': 35,
      'carbs': 40,
      'fat': 18,
      'icon': CupertinoIcons.moon_stars_fill,
      'color': const Color(0xFF00B3BF), // Teal
    },
    {
      'type': 'Snack',
      'calories': 200,
      'date': '2 Jun 2025',
      'protein': 10,
      'carbs': 15,
      'fat': 8,
      'icon': CupertinoIcons.hexagon_fill,
      'color': const Color(0xFF8059E6), // Purple
    },
    {
      'type': 'Breakfast',
      'calories': 400,
      'date': '2 Jun 2025',
      'protein': 22,
      'carbs': 30,
      'fat': 14,
      'icon': CupertinoIcons.sunrise_fill,
      'color': const Color(0xFFFF9500), // Orange
    },
  ];

  @override
  void initState() {
    super.initState();
    _refreshAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _macroAnimationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _sortDropdownAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _mealListAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    // Initialize dropdown animations
    _dropdownAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sortDropdownAnimationController,
      curve: Curves.easeInOut,
    ));

    _dropdownOpacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _sortDropdownAnimationController,
      curve: Curves.easeInOut,
    ));

    // Initialize meal list animation
    _mealListAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _mealListAnimationController,
      curve: Curves.easeInOut,
    ));

    _proteinAnimation = Tween<double>(begin: 0.0, end: 25.0).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _carbsAnimation = Tween<double>(begin: 0.0, end: 35.0).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );
    _fatAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Initialize with default values
    _updateMacroAnimations();

    // Start meal list animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _mealListAnimationController.forward();
    });
  }

  void _changeSortOrder(String newSortOrder) {
    if (_sortOrder != newSortOrder) {
      // Animate out current list
      _mealListAnimationController.reverse().then((_) {
        setState(() {
          _sortOrder = newSortOrder;
        });
        // Animate in new sorted list
        _mealListAnimationController.forward();
      });
    }

    // Close dropdown with animation
    _sortDropdownAnimationController.reverse().then((_) {
      setState(() {
        _showSortOptions = false;
      });
    });
  }

  void _updateMacroAnimations() {
    // Calculate new macro values based on current filters
    final filteredMeals = _selectedMealTypeIndex == 0
        ? _mealEntries
        : _mealEntries
            .where((meal) => meal['type'] == _mealTypes[_selectedMealTypeIndex])
            .toList();

    final int daysInPeriod = _selectedTimeRangeIndex == 0
        ? 1
        : _selectedTimeRangeIndex == 1
            ? 7
            : _selectedTimeRangeIndex == 2
                ? 30
                : 90;

    final totalProtein =
        filteredMeals.fold(0, (sum, entry) => sum + (entry['protein'] as int));
    final totalCarbs =
        filteredMeals.fold(0, (sum, entry) => sum + (entry['carbs'] as int));
    final totalFat =
        filteredMeals.fold(0, (sum, entry) => sum + (entry['fat'] as int));

    final newProtein = totalProtein / daysInPeriod;
    final newCarbs = totalCarbs / daysInPeriod;
    final newFat = totalFat / daysInPeriod;

    // Update animation targets
    _proteinAnimation = Tween<double>(
      begin: _currentProtein,
      end: newProtein,
    ).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _carbsAnimation = Tween<double>(
      begin: _currentCarbs,
      end: newCarbs,
    ).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _fatAnimation = Tween<double>(
      begin: _currentFat,
      end: newFat,
    ).animate(
      CurvedAnimation(
        parent: _macroAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    // Reset and start animation
    _macroAnimationController.reset();
    _macroAnimationController.forward().then((_) {
      // Update current values after animation completes
      _currentProtein = newProtein;
      _currentCarbs = newCarbs;
      _currentFat = newFat;
    });
  }

  @override
  void dispose() {
    _refreshAnimationController.dispose();
    _macroAnimationController.dispose();
    _sortDropdownAnimationController.dispose();
    _mealListAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background gradient
          _buildBackground(),

          // Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with back button, title and add button
                _buildHeader(),

                // Main scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Time range selector
                          _buildTimeRangeSelector(),

                          // Meal type filter
                          _buildMealTypeFilter(),

                          const SizedBox(height: 20),

                          // Nutrition summary section
                          _buildNutritionSummary(),

                          const SizedBox(height: 24),

                          // Macro distribution section
                          AnimatedBuilder(
                            animation: _macroAnimationController,
                            builder: (context, child) {
                              return _buildMacroDistribution();
                            },
                          ),

                          const SizedBox(height: 24),

                          // All entries section
                          _buildAllEntries(),

                          // Bottom padding
                          const SizedBox(height: 24),
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

  Widget _buildBackground() {
    return Stack(
      children: [
        // Base black background
        Container(
          color: Colors.black,
        ),

        // Radial gradient in top right
        Positioned(
          top: 0,
          right: 50,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [
                  const Color(0xFF05E5B3).withOpacity(0.3), // Green accent
                  const Color(0xFF00B3BF).withOpacity(0.15), // Teal accent
                  Colors.transparent,
                ],
                center: Alignment.topRight,
                radius: 1.2,
              ),
            ),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
              child: Container(color: Colors.transparent),
            ),
          ),
        ),

        // Glass-like overlay for subtle effect
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.white.withOpacity(0.01),
            ),
          ),
        ),
      ],
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
            'Nutrition History',
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),

          // Add button
          GestureDetector(
            onTap: () {
              // Future functionality to add meal manually
            },
            child: const Icon(
              CupertinoIcons.plus,
              color: Colors.white,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRangeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Time Range',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 36,
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
                  _updateMacroAnimations();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF05E5B3)
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(
                      _timeRanges[index],
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
    );
  }

  Widget _buildMealTypeFilter() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Text(
            'Meal Type',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(
          height: 36,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _mealTypes.length,
            itemBuilder: (context, index) {
              final isSelected = _selectedMealTypeIndex == index;
              Color selectedColor;

              // Choose appropriate color based on meal type
              switch (index) {
                case 0: // All meals
                  selectedColor = const Color(0xFF05E5B3); // Green
                  break;
                case 1: // Breakfast
                  selectedColor = const Color(0xFFFF9500); // Orange
                  break;
                case 2: // Lunch
                  selectedColor = const Color(0xFF05E5B3); // Green
                  break;
                case 3: // Dinner
                  selectedColor = const Color(0xFF00B3BF); // Teal
                  break;
                case 4: // Snack
                  selectedColor = const Color(0xFF8059E6); // Purple
                  break;
                default:
                  selectedColor = const Color(0xFF05E5B3);
              }

              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedMealTypeIndex = index;
                  });
                  _updateMacroAnimations();
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? selectedColor
                        : Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(18),
                    border: isSelected
                        ? null
                        : Border.all(color: Colors.white.withOpacity(0.1)),
                  ),
                  child: Center(
                    child: Text(
                      _mealTypes[index],
                      style: GoogleFonts.inter(
                        fontSize: 13,
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
    );
  }

  Widget _buildNutritionSummary() {
    // Calculate total calories
    final totalCalories =
        _mealEntries.fold(0, (sum, entry) => sum + (entry['calories'] as int));

    // Calculate daily average (for the selected time range)
    final int daysInPeriod = _selectedTimeRangeIndex == 0
        ? 1
        : _selectedTimeRangeIndex == 1
            ? 7
            : _selectedTimeRangeIndex == 2
                ? 30
                : 90;
    final dailyAverage = totalCalories / daysInPeriod;

    // Get filtered meal count based on selected meal type
    final filteredMeals = _selectedMealTypeIndex == 0
        ? _mealEntries
        : _mealEntries
            .where((meal) => meal['type'] == _mealTypes[_selectedMealTypeIndex])
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Nutrition Summary',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Calories card
            Expanded(
              child: _buildSummaryCard(
                title: 'Calories',
                value: totalCalories.toDouble(),
                unit: 'cal',
                icon: CupertinoIcons.flame_fill,
                color: const Color(0xFFFF9500), // Orange
              ),
            ),
            const SizedBox(width: 8),

            // Daily average card
            Expanded(
              child: _buildSummaryCard(
                title: 'Daily Avg',
                value: dailyAverage,
                unit: 'cal',
                icon: CupertinoIcons.chart_bar_fill,
                color: const Color(0xFF05E5B3), // Green
              ),
            ),
            const SizedBox(width: 8),

            // Meal count card
            Expanded(
              child: _buildSummaryCard(
                title: 'Meals',
                value: filteredMeals.length.toDouble(),
                unit: 'total',
                icon: Icons.dining_outlined,
                color: const Color(0xFF00B3BF), // Teal
                showDecimals: false,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required double value,
    required String unit,
    required IconData icon,
    required Color color,
    bool showDecimals = true,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: 20,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 3),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                showDecimals
                    ? value.toStringAsFixed(1)
                    : value.toInt().toString(),
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                unit,
                style: GoogleFonts.inter(
                  fontSize: 9,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroDistribution() {
    // Use animated values from the animations
    final avgProtein = _proteinAnimation.value;
    final avgCarbs = _carbsAnimation.value;
    final avgFat = _fatAnimation.value;

    // Goal values - hardcoded for now
    const proteinGoal = 140.0;
    const carbsGoal = 180.0;
    const fatGoal = 70.0;

    // Calculate percentages for pie chart
    final totalMacros = avgProtein + avgCarbs + avgFat;
    final proteinPercentage = totalMacros > 0 ? avgProtein / totalMacros : 0.32;
    final carbsPercentage = totalMacros > 0 ? avgCarbs / totalMacros : 0.45;
    final fatPercentage = totalMacros > 0 ? avgFat / totalMacros : 0.23;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Macro Distribution',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1.0,
              ),
            ),
            child: Column(
              children: [
                // Header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Average Daily Macros',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      'Goal Completion',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Protein progress
                _buildMacroProgressRow(
                  name: 'Protein',
                  current: avgProtein,
                  target: proteinGoal,
                  color: const Color(0xFF00B3BF), // Teal blue
                ),
                const SizedBox(height: 10),

                // Carbs progress
                _buildMacroProgressRow(
                  name: 'Carbs',
                  current: avgCarbs,
                  target: carbsGoal,
                  color: const Color(0xFF05E5B3), // Green
                ),
                const SizedBox(height: 10),

                // Fat progress
                _buildMacroProgressRow(
                  name: 'Fat',
                  current: avgFat,
                  target: fatGoal,
                  color: const Color(0xFFFF9500), // Orange
                ),
                const SizedBox(height: 40),

                // Pie chart with legend
                Row(
                  children: [
                    // Pie chart
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Stack(
                        children: [
                          CustomPaint(
                            size: const Size(120, 120),
                            painter: MacroPieChartPainter(
                              proteinPercentage: proteinPercentage,
                              carbsPercentage: carbsPercentage,
                              fatPercentage: fatPercentage,
                            ),
                          ),
                          // Center hole with glass effect
                          Center(
                            child: Container(
                              width: 56,
                              height: 56,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.5),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 16),

                    // Legend
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegendItem(
                            color: const Color(0xFF00B3BF),
                            name: 'Protein',
                            percent: '32%',
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            color: const Color(0xFF05E5B3),
                            name: 'Carbs',
                            percent: '45%',
                          ),
                          const SizedBox(height: 12),
                          _buildLegendItem(
                            color: const Color(0xFFFF9500),
                            name: 'Fat',
                            percent: '23%',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMacroProgressRow({
    required String name,
    required double current,
    required double target,
    required Color color,
  }) {
    final progress = current / target;
    final percentage = (progress * 100).toInt();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Row(
              children: [
                Text(
                  '${current.toInt()}g / ${target.toInt()}g',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: Colors.white.withOpacity(0.7),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '$percentage%',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 6),
        // Progress bar
        Stack(
          children: [
            // Background track
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            // Filled portion with gradient
            Container(
              height: 6,
              width: MediaQuery.of(context).size.width *
                  progress *
                  0.8, // 0.8 factor for padding
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    color,
                    color.withOpacity(0.7),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegendItem({
    required Color color,
    required String name,
    required String percent,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 10),
        Text(
          name,
          style: GoogleFonts.inter(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const Spacer(),
        Text(
          percent,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildAllEntries() {
    // Get filtered entries
    final filteredMeals = _selectedMealTypeIndex == 0
        ? _mealEntries
        : _mealEntries
            .where((meal) => meal['type'] == _mealTypes[_selectedMealTypeIndex])
            .toList();

    // Sort entries based on selected sort order
    List<Map<String, dynamic>> sortedMeals = List.from(filteredMeals);
    switch (_sortOrder) {
      case 'Newest First':
        // Already sorted by default
        break;
      case 'Oldest First':
        sortedMeals = sortedMeals.reversed.toList();
        break;
      case 'Highest Calories':
        sortedMeals.sort(
            (a, b) => (b['calories'] as int).compareTo(a['calories'] as int));
        break;
      case 'Lowest Calories':
        sortedMeals.sort(
            (a, b) => (a['calories'] as int).compareTo(b['calories'] as int));
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and sort control
        Row(
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
            Row(
              children: [
                // Sort dropdown button
                GestureDetector(
                  onTap: () {
                    if (_showSortOptions) {
                      _sortDropdownAnimationController.reverse().then((_) {
                        setState(() {
                          _showSortOptions = false;
                        });
                      });
                    } else {
                      setState(() {
                        _showSortOptions = true;
                      });
                      _sortDropdownAnimationController.forward();
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _sortOrder,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.8),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          _showSortOptions
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                          color: Colors.white.withOpacity(0.8),
                          size: 12,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${sortedMeals.length} meals',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: Colors.white.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ],
        ),

        // Sort options dropdown
        if (_showSortOptions)
          AnimatedBuilder(
            animation: _sortDropdownAnimationController,
            builder: (context, child) {
              return Transform.scale(
                scale: _dropdownAnimation.value,
                alignment: Alignment.topRight,
                child: Opacity(
                  opacity: _dropdownOpacityAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1.0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _sortOptions.map((option) {
                        return GestureDetector(
                          onTap: () {
                            _changeSortOrder(option);
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: _sortOrder == option
                                  ? Colors.white.withOpacity(0.1)
                                  : Colors.transparent,
                              border: Border(
                                bottom: BorderSide(
                                  color: option != _sortOptions.last
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.transparent,
                                  width: 0.5,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  option,
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                                if (_sortOrder == option)
                                  const Icon(
                                    CupertinoIcons.check_mark,
                                    color: Color(0xFF05E5B3),
                                    size: 16,
                                  ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              );
            },
          ),

        const SizedBox(height: 16),

        // Entries list
        AnimatedBuilder(
          animation: _mealListAnimationController,
          builder: (context, child) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  children: sortedMeals.asMap().entries.map((entry) {
                    final index = entry.key;
                    final meal = entry.value;

                    // Create staggered animation for each item
                    final itemAnimation = Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(
                      CurvedAnimation(
                        parent: _mealListAnimationController,
                        curve: Interval(
                          (index * 0.1).clamp(0.0, 0.6),
                          ((index * 0.1) + 0.4).clamp(0.4, 1.0),
                          curve: Curves.easeOutBack,
                        ),
                      ),
                    );

                    final slideAnimation = Tween<Offset>(
                      begin: const Offset(0.3, 0),
                      end: Offset.zero,
                    ).animate(
                      CurvedAnimation(
                        parent: _mealListAnimationController,
                        curve: Interval(
                          (index * 0.1).clamp(0.0, 0.6),
                          ((index * 0.1) + 0.4).clamp(0.4, 1.0),
                          curve: Curves.easeOutCubic,
                        ),
                      ),
                    );

                    return SlideTransition(
                      position: slideAnimation,
                      child: FadeTransition(
                        opacity: itemAnimation,
                        child: Transform.scale(
                          scale: itemAnimation.value,
                          child: _buildMealEntryItem(meal),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMealEntryItem(Map<String, dynamic> meal) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          // Meal type icon
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (meal['color'] as Color).withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                meal['icon'] as IconData,
                color: meal['color'] as Color,
                size: 22,
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Meal details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Meal type and date
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      meal['type'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      meal['date'] as String,
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        color: Colors.white.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Calories and macros
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${meal['calories']} cal',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'P: ${meal['protein']}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: const Color(0xFF00B3BF),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'C: ${meal['carbs']}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: const Color(0xFF05E5B3),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'F: ${meal['fat']}',
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            color: const Color(0xFFFF9500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Custom painter for the macro pie chart
class MacroPieChartPainter extends CustomPainter {
  final double proteinPercentage;
  final double carbsPercentage;
  final double fatPercentage;

  MacroPieChartPainter({
    required this.proteinPercentage,
    required this.carbsPercentage,
    required this.fatPercentage,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final strokeWidth = 20.0;

    // Calculate the angles
    final proteinAngle = proteinPercentage * 2 * pi;
    final carbsAngle = carbsPercentage * 2 * pi;
    final fatAngle = fatPercentage * 2 * pi;

    // Setup paint for protein slice
    final proteinPaint = Paint()
      ..color = const Color(0xFF00B3BF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Setup paint for carbs slice
    final carbsPaint = Paint()
      ..color = const Color(0xFF05E5B3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Setup paint for fat slice
    final fatPaint = Paint()
      ..color = const Color(0xFFFF9500)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt;

    // Draw protein slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2, // Start from top
      proteinAngle,
      false,
      proteinPaint,
    );

    // Draw carbs slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2 + proteinAngle,
      carbsAngle,
      false,
      carbsPaint,
    );

    // Draw fat slice
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth / 2),
      -pi / 2 + proteinAngle + carbsAngle,
      fatAngle,
      false,
      fatPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
