import 'dart:ui';
import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/background_gradient.dart';
import 'package:fitness_freaks/features/homepage/presentation/widgets/glass_card.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FitnessTab extends StatefulWidget {
  const FitnessTab({super.key});

  @override
  State<FitnessTab> createState() => _FitnessTabState();
}

class _FitnessTabState extends State<FitnessTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  String _selectedCategory = 'All';
  final List<String> _categories = [
    'All',
    'Strength',
    'Cardio',
    'Flexibility',
    'HIIT',
    'Recovery',
  ];

  // Sample workout data
  final List<WorkoutItem> _workouts = [
    WorkoutItem(
      name: 'Full Body Strength',
      type: 'Strength',
      duration: 45,
      frequency: '3x week',
      lastUsed: '2 days ago',
    ),
    WorkoutItem(
      name: 'HIIT Cardio Blast',
      type: 'Cardio',
      duration: 30,
      frequency: '2x week',
      lastUsed: 'Yesterday',
    ),
    WorkoutItem(
      name: 'Upper Body Focus',
      type: 'Strength',
      duration: 50,
      frequency: '2x week',
      lastUsed: '1 week ago',
    ),
    WorkoutItem(
      name: 'Core & Flexibility',
      type: 'Flexibility',
      duration: 35,
      frequency: '2x week',
      lastUsed: '3 days ago',
    ),
    WorkoutItem(
      name: 'Leg Day Challenge',
      type: 'Strength',
      duration: 55,
      frequency: '1x week',
      lastUsed: '5 days ago',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    _slideAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutQuint,
    );

    // Start animations after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
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
    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          const Positioned.fill(
            child: BackgroundGradient(tabType: TabType.fitness),
          ),

          // Content
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // App Bar with Title and Notification
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                    child: _buildAppBar(),
                  ),
                ),

                // Action buttons: New Workout & Discover
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _buildActionButtons(),
                  ),
                ),

                // Category filters
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24, bottom: 10),
                    child: _buildCategoryFilters(),
                  ),
                ),

                // "Your Workouts" header with "View All" action
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                    child: _buildSectionHeader('Your Workouts'),
                  ),
                ),

                // Workout list
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final workout = _filteredWorkouts[index];
                    // Create staggered animation for each item
                    final itemDelay = 0.2 + (index * 0.05);

                    return AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        // Only animate if the animation has reached this item's delay
                        final itemProgress = (_slideAnimation.value - itemDelay)
                            .clamp(0.0, 1.0);

                        return Opacity(
                          opacity: itemProgress,
                          child: Transform.translate(
                            offset: Offset(0, 20 * (1 - itemProgress)),
                            child: child,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                        child: _buildWorkoutItem(workout),
                      ),
                    );
                  }, childCount: _filteredWorkouts.length),
                ),

                // Weekly Stats Section
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
                    child: _buildWeeklyStatsSection(),
                  ),
                ),

                // Bottom padding for tab bar
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return AnimatedBuilder(
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
          // Title and subtitle
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Your Fitness',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Energize your day',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.7),
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),

          // Notification bell
          _buildNotificationButton(),
        ],
      ),
    );
  }

  Widget _buildNotificationButton() {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(23),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(12),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  CupertinoIcons.bell_fill,
                  color: Colors.white.withOpacity(0.9),
                  size: 20,
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF25E63), // accentRed
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return AnimatedBuilder(
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
        children: [
          // New Workout Button
          Expanded(
            child: _buildActionButton(
              icon: CupertinoIcons.plus_circle_fill,
              iconColor: const Color(0xFF00E6B3), // vibrantMint
              title: 'New\nWorkout',
              onTap: () {},
            ),
          ),
          const SizedBox(width: 16),
          // Discover Workouts Button
          Expanded(
            child: _buildActionButton(
              icon: CupertinoIcons.search,
              iconColor: const Color(0xFF8C59F2), // accentPurple
              title: 'Discover\nWorkouts',
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return GlassCard(
      transparency: 0.15,
      cornerRadius: 16,
      borderColor: Colors.white.withOpacity(0.12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                iconColor.withOpacity(0.15),
                iconColor.withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * -10),
            child: child,
          ),
        );
      },
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children:
              _categories.map((category) {
                final isSelected = _selectedCategory == category;

                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: _buildCategoryButton(
                    category: category,
                    isSelected: isSelected,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryButton({
    required String category,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient:
              isSelected
                  ? const LinearGradient(
                    colors: [
                      Color(0xFF00E6B3), // vibrantMint
                      Color(0xFF00BFCC), // vibrantTeal
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  )
                  : null,
          color: isSelected ? null : Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color:
                isSelected
                    ? const Color(0xFF00E6B3).withOpacity(0.7)
                    : Colors.white.withOpacity(0.1),
            width: 0.5,
          ),
          boxShadow:
              isSelected
                  ? [
                    BoxShadow(
                      color: const Color(0xFF00E6B3).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                  : null,
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return AnimatedBuilder(
      animation: _fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, (1 - _fadeAnimation.value) * -5),
            child: child,
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              minimumSize: Size.zero,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: const Text(
              'View All',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF00E6B3), // vibrantMint
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutItem(WorkoutItem workout) {
    return GlassCard(
      transparency: 0.15,
      cornerRadius: 16,
      borderColor: Colors.white.withOpacity(0.12),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Workout icon
              _buildWorkoutIcon(workout),
              const SizedBox(width: 14),

              // Workout details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Workout name
                    Text(
                      workout.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Workout meta info
                    Row(
                      children: [
                        // Duration
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.clock_fill,
                              color: Colors.white.withOpacity(0.6),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${workout.duration} min',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 12),

                        // Frequency
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.calendar,
                              color: Colors.white.withOpacity(0.6),
                              size: 12,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              workout.frequency,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Last used info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Last Used',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.white.withOpacity(0.5),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    workout.lastUsed,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutIcon(WorkoutItem workout) {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: _getWorkoutTypeGradient(workout.type),
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        _getWorkoutTypeIcon(workout.type),
        color: Colors.white,
        size: 24,
      ),
    );
  }

  Widget _buildWeeklyStatsSection() {
    return AnimatedBuilder(
      animation: _slideAnimation,
      builder: (context, child) {
        final delay = 0.5;
        final progress = (_slideAnimation.value - delay).clamp(0.0, 1.0);

        return Opacity(
          opacity: progress,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - progress)),
            child: child,
          ),
        );
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Overview',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              // Workouts Completed
              Expanded(
                child: _buildStatCard(
                  value: '5',
                  label: 'Workouts',
                  icon: CupertinoIcons.person_crop_rectangle_fill,
                  color: const Color(0xFF26D98A), // accentGreen
                ),
              ),
              const SizedBox(width: 16),
              // Total Time
              Expanded(
                child: _buildStatCard(
                  value: '3.5',
                  label: 'Hours',
                  icon: CupertinoIcons.clock_fill,
                  color: const Color(0xFF00E6B3), // vibrantMint
                ),
              ),
              const SizedBox(width: 16),
              // Streak
              Expanded(
                child: _buildStatCard(
                  value: '12',
                  label: 'Day Streak',
                  icon: CupertinoIcons.flame_fill,
                  color: const Color(0xFFFF9900), // accentOrange
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String value,
    required String label,
    required IconData icon,
    required Color color,
  }) {
    return GlassCard(
      transparency: 0.15,
      cornerRadius: 16,
      borderColor: Colors.white.withOpacity(0.12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.15), color.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(height: 12),
            // Value
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withOpacity(0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to get workout icon based on type
  IconData _getWorkoutTypeIcon(String type) {
    switch (type) {
      case 'Strength':
        return CupertinoIcons.ant_circle; // or dumbbell
      case 'Cardio':
        return CupertinoIcons.heart_fill;
      case 'HIIT':
        return CupertinoIcons.bolt_fill;
      case 'Flexibility':
        return CupertinoIcons.person_crop_rectangle;
      default:
        return CupertinoIcons.person_crop_rectangle;
    }
  }

  // Helper method to get workout color based on type
  List<Color> _getWorkoutTypeGradient(String type) {
    switch (type) {
      case 'Strength':
        return [Colors.blue, Colors.blue.withOpacity(0.7)];
      case 'Cardio':
        return [
          const Color(0xFFF25E63), // accentRed
          const Color(0xFFFF9900), // accentOrange
        ];
      case 'Flexibility':
        return [
          const Color(0xFF00E6B3), // vibrantMint
          const Color(0xFF00BFcc), // vibrantTeal
        ];
      case 'HIIT':
        return [
          const Color(0xFF8C59F2), // accentPurple
          Colors.blue,
        ];
      default:
        return [
          const Color(0xFF26D98A), // accentGreen
          const Color(0xFF00E6B3), // vibrantMint
        ];
    }
  }

  // Helper method to filter workouts by selected category
  List<WorkoutItem> get _filteredWorkouts {
    if (_selectedCategory == 'All') {
      return _workouts;
    } else {
      return _workouts
          .where((workout) => workout.type == _selectedCategory)
          .toList();
    }
  }
}

class WorkoutItem {
  final String name;
  final String type;
  final int duration;
  final String frequency;
  final String lastUsed;

  WorkoutItem({
    required this.name,
    required this.type,
    required this.duration,
    required this.frequency,
    required this.lastUsed,
  });
}
