import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import '../widgets/background_gradient.dart';
import 'workout_session_page.dart';

class DiscoverWorkoutsPage extends StatefulWidget {
  const DiscoverWorkoutsPage({super.key});

  @override
  State<DiscoverWorkoutsPage> createState() => _DiscoverWorkoutsPageState();
}

class _DiscoverWorkoutsPageState extends State<DiscoverWorkoutsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';

  final List<String> _filterTabs = [
    'All',
    'Chest',
    'Back',
    'Biceps',
    'Triceps',
    'Shoulders',
    'Legs',
    'Core'
  ];

  // Sample public workouts from different users
  final List<Map<String, dynamic>> _publicWorkouts = [
    {
      'name': 'Beast Mode Chest',
      'description': 'Intense chest workout for mass',
      'exercises': [
        'Barbell Bench Press',
        'Incline Dumbbell Press',
        'Chest Dips',
        'Cable Flyes',
        'Push-ups to Failure',
        'Chest Press Machine'
      ],
      'duration': '60 min',
      'difficulty': 'Advanced',
      'category': 'Chest',
      'creator': 'FitnessKing92',
      'rating': 4.8,
      'likes': 1247,
      'color': const Color(0xFFFF6B35),
      'icon': CupertinoIcons.flame_fill,
      'createdAt': '2 days ago',
      'isVerified': true,
    },
    {
      'name': 'Pull Day Destroyer',
      'description': 'Complete back and biceps annihilation',
      'exercises': [
        'Deadlifts',
        'Pull-ups',
        'Barbell Rows',
        'T-Bar Rows',
        'Hammer Curls',
        'Cable Curls'
      ],
      'duration': '55 min',
      'difficulty': 'Advanced',
      'category': 'Back',
      'creator': 'IronLifter',
      'rating': 4.9,
      'likes': 892,
      'color': const Color(0xFF007AFF),
      'icon': CupertinoIcons.bars,
      'createdAt': '1 week ago',
      'isVerified': true,
    },
    {
      'name': 'Beginner Arm Blast',
      'description': 'Perfect for building arm strength',
      'exercises': [
        'Dumbbell Curls',
        'Tricep Pushdowns',
        'Hammer Curls',
        'Overhead Extension',
        'Close-Grip Push-ups',
        'Arm Circles'
      ],
      'duration': '30 min',
      'difficulty': 'Beginner',
      'category': 'Biceps',
      'creator': 'FitNewbie',
      'rating': 4.5,
      'likes': 456,
      'color': const Color(0xFF30D158),
      'icon': CupertinoIcons.person_alt,
      'createdAt': '3 days ago',
      'isVerified': false,
    },
    {
      'name': 'Shoulder Shredder',
      'description': 'Build boulder shoulders',
      'exercises': [
        'Military Press',
        'Lateral Raises',
        'Rear Delt Flyes',
        'Face Pulls',
        'Shrugs',
        'Pike Push-ups'
      ],
      'duration': '40 min',
      'difficulty': 'Intermediate',
      'category': 'Shoulders',
      'creator': 'ShoulderGuru',
      'rating': 4.7,
      'likes': 723,
      'color': const Color(0xFFFF2D92),
      'icon': CupertinoIcons.flame,
      'createdAt': '5 days ago',
      'isVerified': true,
    },
    {
      'name': 'Leg Day Massacre',
      'description': 'No mercy leg workout',
      'exercises': [
        'Squats',
        'Romanian Deadlifts',
        'Bulgarian Split Squats',
        'Leg Press',
        'Calf Raises',
        'Walking Lunges'
      ],
      'duration': '65 min',
      'difficulty': 'Advanced',
      'category': 'Legs',
      'creator': 'LegDayLegend',
      'rating': 4.9,
      'likes': 1156,
      'color': const Color(0xFF5856D6),
      'icon': CupertinoIcons.bolt_fill,
      'createdAt': '4 days ago',
      'isVerified': true,
    },
    {
      'name': 'Core Crusher',
      'description': 'Abs of steel workout',
      'exercises': [
        'Plank Variations',
        'Russian Twists',
        'Mountain Climbers',
        'Dead Bug',
        'Bicycle Crunches',
        'Hanging Leg Raises'
      ],
      'duration': '25 min',
      'difficulty': 'Intermediate',
      'category': 'Core',
      'creator': 'AbsExpert',
      'rating': 4.6,
      'likes': 634,
      'color': const Color(0xFFFF9500),
      'icon': CupertinoIcons.circle_grid_3x3,
      'createdAt': '1 week ago',
      'isVerified': false,
    },
    {
      'name': 'Tricep Torture',
      'description': 'Isolated tricep destruction',
      'exercises': [
        'Close-Grip Bench Press',
        'Tricep Dips',
        'Overhead Extension',
        'Diamond Push-ups',
        'Tricep Kickbacks',
        'Cable Pushdowns'
      ],
      'duration': '35 min',
      'difficulty': 'Intermediate',
      'category': 'Triceps',
      'creator': 'ArmSpecialist',
      'rating': 4.4,
      'likes': 387,
      'color': const Color(0xFFFF3B30),
      'icon': CupertinoIcons.heart_fill,
      'createdAt': '6 days ago',
      'isVerified': false,
    },
    {
      'name': 'Power Chest Builder',
      'description': 'Build explosive chest power',
      'exercises': [
        'Explosive Push-ups',
        'Plyometric Bench Press',
        'Medicine Ball Throws',
        'Clap Push-ups',
        'Resistance Band Flyes',
        'Isometric Holds'
      ],
      'duration': '45 min',
      'difficulty': 'Advanced',
      'category': 'Chest',
      'creator': 'PowerLifter99',
      'rating': 4.8,
      'likes': 945,
      'color': const Color(0xFFFF9500),
      'icon': CupertinoIcons.flame_fill,
      'createdAt': '2 weeks ago',
      'isVerified': true,
    },
  ];

  List<Map<String, dynamic>> get _filteredWorkouts {
    List<Map<String, dynamic>> filtered = _publicWorkouts;

    // Filter by category
    if (_selectedFilter != 'All') {
      filtered = filtered
          .where((workout) => workout['category'] == _selectedFilter)
          .toList();
    }

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((workout) {
        final name = workout['name'].toString().toLowerCase();
        final description = workout['description'].toString().toLowerCase();
        final creator = workout['creator'].toString().toLowerCase();
        final query = _searchQuery.toLowerCase();

        return name.contains(query) ||
            description.contains(query) ||
            creator.contains(query);
      }).toList();
    }

    // Sort by likes (most popular first)
    filtered.sort((a, b) => (b['likes'] as int).compareTo(a['likes'] as int));

    return filtered;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.discoverWorkouts),

          // Main content
          SafeArea(
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
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),

                          // Search Bar
                          _buildSearchBar(),

                          const SizedBox(height: 20),

                          // Filter Tabs
                          _buildFilterTabs(),

                          const SizedBox(height: 24),

                          // Results Count
                          Text(
                            '${_filteredWorkouts.length} Public Workouts',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Workouts List
                          _filteredWorkouts.isEmpty
                              ? _buildNoResults()
                              : ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: _filteredWorkouts.length,
                                  itemBuilder: (context, index) {
                                    final workout = _filteredWorkouts[index];
                                    return _buildWorkoutCard(workout);
                                  },
                                ),

                          // Extra bottom padding
                          const SizedBox(height: 100),
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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        children: [
          // Back Button
          GestureDetector(
            onTap: () => Navigator.pop(context),
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
              child: const Center(
                child: Icon(
                  CupertinoIcons.back,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Title
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Discover Workouts',
                      style: GoogleFonts.inter(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF3B82F6).withOpacity(0.3),
                            const Color(0xFF7C3AED).withOpacity(0.3),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'PUBLIC',
                        style: GoogleFonts.inter(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3B82F6),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Explore workouts from the community',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search workouts, creators...',
              hintStyle: GoogleFonts.inter(
                color: Colors.white.withOpacity(0.6),
                fontSize: 16,
              ),
              prefixIcon: Icon(
                CupertinoIcons.search,
                color: Colors.white.withOpacity(0.6),
                size: 20,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? GestureDetector(
                      onTap: () {
                        _searchController.clear();
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                      child: Icon(
                        CupertinoIcons.clear_circled_solid,
                        color: Colors.white.withOpacity(0.6),
                        size: 20,
                      ),
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _filterTabs.map((filter) {
          final isSelected = _selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFilter = filter;
                });
                HapticFeedback.lightImpact();
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  gradient: isSelected
                      ? LinearGradient(
                          colors: [
                            const Color(0xFF3B82F6),
                            const Color(0xFF7C3AED),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : null,
                  color: isSelected ? null : Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF3B82F6)
                        : Colors.white.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  filter,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withOpacity(0.9),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildNoResults() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(
            CupertinoIcons.search,
            size: 64,
            color: Colors.white.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'No workouts found',
            style: GoogleFonts.inter(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(Map<String, dynamic> workout) {
    final exercises = workout['exercises'] as List<String>;
    final displayExercises = exercises.take(3).toList();
    final hasMoreExercises = exercises.length > 3;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with icon, title, and creator info
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: workout['color'],
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Center(
                        child: Icon(
                          workout['icon'],
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  workout['name'],
                                  style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              if (workout['isVerified'])
                                Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3B82F6)
                                        .withOpacity(0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    CupertinoIcons.checkmark_seal_fill,
                                    color: const Color(0xFF3B82F6),
                                    size: 14,
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                'by ${workout['creator']}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.7),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '•',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                workout['createdAt'],
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                // Description
                Text(
                  workout['description'],
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                  ),
                ),

                const SizedBox(height: 16),

                // Stats Row
                Row(
                  children: [
                    _buildStatChip(
                      icon: CupertinoIcons.time,
                      label: workout['duration'],
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      icon: CupertinoIcons.chart_bar_alt_fill,
                      label: workout['difficulty'],
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      icon: CupertinoIcons.star_fill,
                      label: workout['rating'].toString(),
                    ),
                    const SizedBox(width: 12),
                    _buildStatChip(
                      icon: CupertinoIcons.heart_fill,
                      label: '${workout['likes']}',
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Exercise List
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...displayExercises
                        .map((exercise) => Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Row(
                                children: [
                                  Container(
                                    width: 4,
                                    height: 4,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.6),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      exercise,
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        color: Colors.white.withOpacity(0.8),
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                    if (hasMoreExercises) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.4),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${exercises.length - 3} more exercises...',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.5),
                              fontWeight: FontWeight.w400,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 20),

                // Action Buttons Row
                Row(
                  children: [
                    // Try Workout Button
                    Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFF3B82F6),
                              const Color(0xFF7C3AED),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.mediumImpact();
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => WorkoutSessionPage(
                                  workoutPlan: workout,
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            'Try Workout',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // Like Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            // Toggle like status
                            workout['isLiked'] = !(workout['isLiked'] ?? false);
                            if (workout['isLiked']) {
                              workout['likes'] = (workout['likes'] ?? 0) + 1;
                            } else {
                              workout['likes'] = (workout['likes'] ?? 1) - 1;
                            }
                          });
                        },
                        icon: Icon(
                          workout['isLiked'] == true
                              ? CupertinoIcons.heart_fill
                              : CupertinoIcons.heart,
                          color: workout['isLiked'] == true
                              ? AppColors.vibrantMint
                              : Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ),

                    const SizedBox(width: 8),

                    // Save Button
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          setState(() {
                            // Toggle save status
                            workout['isSaved'] = !(workout['isSaved'] ?? false);
                          });

                          // Show feedback
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: workout['isSaved']
                                            ? AppColors.vibrantMint
                                                .withOpacity(0.2)
                                            : Colors.white.withOpacity(0.1),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        workout['isSaved']
                                            ? CupertinoIcons.checkmark
                                            : CupertinoIcons.xmark,
                                        color: workout['isSaved']
                                            ? AppColors.vibrantMint
                                            : Colors.white.withOpacity(0.8),
                                        size: 14,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        workout['isSaved']
                                            ? 'Workout saved to favorites!'
                                            : 'Workout removed from favorites',
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
                        icon: Icon(
                          workout['isSaved'] == true
                              ? CupertinoIcons.bookmark_fill
                              : CupertinoIcons.bookmark,
                          color: workout['isSaved'] == true
                              ? AppColors.vibrantMint
                              : Colors.white.withOpacity(0.8),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 12,
            color: Colors.white.withOpacity(0.7),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }
}
