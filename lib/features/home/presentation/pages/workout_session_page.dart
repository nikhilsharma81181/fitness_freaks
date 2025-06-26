import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import '../widgets/background_gradient.dart';

class WorkoutSessionPage extends StatefulWidget {
  final Map<String, dynamic> workoutPlan;

  const WorkoutSessionPage({
    super.key,
    required this.workoutPlan,
  });

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Timer related
  Timer? _timer;
  int _seconds = 0;
  bool _isTimerRunning = false;
  bool _isPaused = false;

  // Rest timer
  Timer? _restTimer;
  int _restSeconds = 0;
  bool _isResting = false;

  // Workout state
  int _currentExerciseIndex = 0;
  List<Map<String, dynamic>> _exerciseData = [];
  bool _workoutCompleted = false;

  // Scroll controller for sticky timer
  late ScrollController _scrollController;
  bool _showStickyTimer = false;

  @override
  void initState() {
    super.initState();
    _initializeWorkout();
    _setupAnimations();
    _setupScrollController();
  }

  void _setupAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    _pulseController.repeat(reverse: true);
  }

  void _setupScrollController() {
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      // Show sticky timer when scrolled past the main timer card
      final shouldShow = _scrollController.offset > 300;
      if (shouldShow != _showStickyTimer) {
        setState(() {
          _showStickyTimer = shouldShow;
        });
      }
    });
  }

  void _initializeWorkout() {
    final exercises = widget.workoutPlan['exercises'] as List<String>;
    _exerciseData = exercises.map((exercise) {
      return {
        'name': exercise,
        'sets': <Map<String, dynamic>>[],
        'completed': false,
        'isExpanded': false,
      };
    }).toList();

    // Expand first exercise
    if (_exerciseData.isNotEmpty) {
      _exerciseData[0]['isExpanded'] = true;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _restTimer?.cancel();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startTimer() {
    if (!_isTimerRunning) {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          _seconds++;
        });
      });
      setState(() {
        _isTimerRunning = true;
        _isPaused = false;
      });
      HapticFeedback.lightImpact();
    }
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isPaused = true;
    });
    HapticFeedback.mediumImpact();
  }

  void _startRestTimer(int duration) {
    setState(() {
      _isResting = true;
      _restSeconds = duration;
    });

    _restTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _restSeconds--;
      });

      if (_restSeconds <= 0) {
        _restTimer?.cancel();
        setState(() {
          _isResting = false;
        });
        HapticFeedback.heavyImpact();
      } else if (_restSeconds <= 5) {
        HapticFeedback.lightImpact();
      }
    });
  }

  String _formatTime(int seconds) {
    int hours = seconds ~/ 3600;
    int minutes = (seconds % 3600) ~/ 60;
    int secs = seconds % 60;

    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
  }

  void _addSetInline(int exerciseIndex, double weight, int reps) {
    if (weight > 0 && reps > 0) {
      setState(() {
        (_exerciseData[exerciseIndex]['sets'] as List).add({
          'weight': weight,
          'reps': reps,
        });
      });
      HapticFeedback.lightImpact();
    }
  }

  void _completeWorkout() {
    _timer?.cancel();
    _restTimer?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => _buildWorkoutCompleteDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: Stack(
        children: [
          // Background gradient
          const BackgroundGradient(forTab: TabType.fitness),

          // Main content
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                // Header with timer
                _buildHeader(),

                // Main content
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 16),

                          // Workout timer card
                          _buildTimerCard(),

                          const SizedBox(height: 20),

                          // Exercise list
                          _buildExerciseList(),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Rest timer overlay
          if (_isResting) _buildRestTimerOverlay(),

          // Sticky timer at bottom
          if (_showStickyTimer) _buildStickyTimer(),
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
            onTap: () => _showExitDialog(),
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
                Text(
                  widget.workoutPlan['name'],
                  style: GoogleFonts.inter(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${(widget.workoutPlan['exercises'] as List).length} exercises • ${widget.workoutPlan['duration']}',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.7),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),

          // Menu button
          GestureDetector(
            onTap: () => _showWorkoutMenu(),
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
                  CupertinoIcons.ellipsis,
                  color: Colors.white,
                  size: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.08),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withOpacity(0.25),
          width: 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // Timer display
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isTimerRunning ? _pulseAnimation.value : 1.0,
                child: Text(
                  _formatTime(_seconds),
                  style: GoogleFonts.inter(
                    fontSize: 48,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          // Timer controls
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Start/Pause button
              GestureDetector(
                onTap: _isTimerRunning ? _pauseTimer : _startTimer,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        AppColors.vibrantMint,
                        AppColors.vibrantTeal,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isTimerRunning
                            ? CupertinoIcons.pause_fill
                            : CupertinoIcons.play_fill,
                        color: Colors.black,
                        size: 18,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _isTimerRunning
                            ? 'Pause'
                            : (_isPaused ? 'Resume' : 'Start'),
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Exercises',
          style: GoogleFonts.inter(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _exerciseData.length,
          itemBuilder: (context, index) {
            return _buildExerciseCard(index);
          },
        ),
      ],
    );
  }

  Widget _buildExerciseCard(int index) {
    final exercise = _exerciseData[index];
    final isExpanded = exercise['isExpanded'] as bool;
    final sets = exercise['sets'] as List<Map<String, dynamic>>;

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
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1.0,
        ),
      ),
      child: Column(
        children: [
          // Exercise header
          GestureDetector(
            onTap: () {
              setState(() {
                exercise['isExpanded'] = !isExpanded;
              });
            },
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  // Exercise number
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: widget.workoutPlan['color'],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Exercise name and sets count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['name'],
                          style: GoogleFonts.inter(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          sets.isEmpty
                              ? 'No sets added'
                              : '${sets.length} set${sets.length == 1 ? '' : 's'}',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Expand/collapse icon
                  Icon(
                    isExpanded
                        ? CupertinoIcons.chevron_up
                        : CupertinoIcons.chevron_down,
                    color: Colors.white.withOpacity(0.7),
                    size: 20,
                  ),
                ],
              ),
            ),
          ),

          // Exercise details (expandable)
          if (isExpanded) ...[
            const Divider(
              color: Colors.white24,
              height: 1,
              indent: 20,
              endIndent: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Sets list
                  if (sets.isNotEmpty) ...[
                    // Sets header
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Set',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            'Weight (kg)',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            'Reps',
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(width: 40), // For delete button space
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Sets data
                    ...sets.asMap().entries.map((entry) {
                      final setIndex = entry.key;
                      final setData = entry.value;
                      return _buildSetRow(index, setIndex, setData);
                    }).toList(),

                    const SizedBox(height: 16),
                  ],

                  // Add set inline form
                  _buildAddSetInlineForm(index),

                  // Rest timer buttons
                  if (sets.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        _buildRestButton('60s', 60),
                        const SizedBox(width: 8),
                        _buildRestButton('90s', 90),
                        const SizedBox(width: 8),
                        _buildRestButton('2min', 120),
                        const SizedBox(width: 8),
                        _buildRestButton('3min', 180),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSetRow(
      int exerciseIndex, int setIndex, Map<String, dynamic> setData) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '${setIndex + 1}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${setData['weight']}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${setData['reps']}',
              style: GoogleFonts.inter(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                (_exerciseData[exerciseIndex]['sets'] as List)
                    .removeAt(setIndex);
              });
              HapticFeedback.lightImpact();
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                CupertinoIcons.trash,
                color: Colors.red,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRestButton(String label, int seconds) {
    return Expanded(
      child: GestureDetector(
        onTap: () => _startRestTimer(seconds),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.white.withOpacity(0.15),
              width: 1,
            ),
          ),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildAddSetInlineForm(int exerciseIndex) {
    final TextEditingController weightController = TextEditingController();
    final TextEditingController repsController = TextEditingController();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.15),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Add New Set',
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Weight input
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Weight (kg)',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CupertinoTextField(
                      controller: weightController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      placeholder: '0',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Reps input
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Reps',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.7),
                      ),
                    ),
                    const SizedBox(height: 4),
                    CupertinoTextField(
                      controller: repsController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      placeholder: '0',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              // Add button
              GestureDetector(
                onTap: () {
                  final weight = double.tryParse(weightController.text) ?? 0.0;
                  final reps = int.tryParse(repsController.text) ?? 0;

                  if (weight > 0 && reps > 0) {
                    _addSetInline(exerciseIndex, weight, reps);
                    weightController.clear();
                    repsController.clear();
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.vibrantMint,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    CupertinoIcons.add,
                    color: Colors.black,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStickyTimer() {
    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black.withOpacity(0.9),
              Colors.black.withOpacity(0.7),
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer display
                  Row(
                    children: [
                      Icon(
                        CupertinoIcons.time,
                        color: AppColors.vibrantMint,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _formatTime(_seconds),
                        style: GoogleFonts.inter(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),

                  // Timer controls
                  Row(
                    children: [
                      if (!_isTimerRunning && !_isPaused)
                        GestureDetector(
                          onTap: _startTimer,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.vibrantMint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Start',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      if (_isTimerRunning)
                        GestureDetector(
                          onTap: _pauseTimer,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Pause',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      if (_isPaused)
                        GestureDetector(
                          onTap: _startTimer,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppColors.vibrantMint,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Resume',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
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
      ),
    );
  }

  Widget _buildRestTimerOverlay() {
    return Container(
      color: Colors.black.withOpacity(0.8),
      child: Center(
        child: Container(
          margin: const EdgeInsets.all(40),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1.0,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Rest Time',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _formatTime(_restSeconds),
                style: GoogleFonts.inter(
                  fontSize: 48,
                  fontWeight: FontWeight.w800,
                  color: AppColors.vibrantMint,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {
                      _restTimer?.cancel();
                      setState(() {
                        _isResting = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _restSeconds += 30;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.vibrantMint,
                            AppColors.vibrantTeal,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '+30s',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
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

  void _showExitDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.08),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'End Workout?',
                style: GoogleFonts.inter(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Your progress will be saved.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withOpacity(0.8),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.15),
                          width: 1,
                        ),
                      ),
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Continue',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child: Text(
                          'End Workout',
                          style: GoogleFonts.inter(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
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

  void _showWorkoutMenu() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(
          'Workout Options',
          style: GoogleFonts.inter(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
              _completeWorkout();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  CupertinoIcons.checkmark_alt,
                  size: 22,
                  color: Colors.green,
                ),
                const SizedBox(width: 12),
                Text(
                  'Complete Workout',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: GoogleFonts.inter(
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWorkoutCompleteDialog() {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              Colors.white.withOpacity(0.08),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withOpacity(0.25),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantMint.withOpacity(0.3),
                    AppColors.vibrantTeal.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.vibrantMint.withOpacity(0.4),
                  width: 2,
                ),
              ),
              child: Icon(
                CupertinoIcons.checkmark_alt,
                color: AppColors.vibrantMint,
                size: 40,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Workout Complete!',
              style: GoogleFonts.inter(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              'Great job! You completed ${widget.workoutPlan['name']} in ${_formatTime(_seconds)}.',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: Colors.white.withOpacity(0.8),
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 24),

            // Done button
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.vibrantMint,
                    AppColors.vibrantTeal,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.vibrantMint.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                CupertinoIcons.checkmark_alt,
                                color: AppColors.vibrantMint,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'Workout Completed! 💪',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Great job on finishing your workout!',
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      color: Colors.white.withOpacity(0.8),
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      backgroundColor: Colors.black.withOpacity(0.8),
                      duration: const Duration(seconds: 3),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      margin: const EdgeInsets.all(16),
                    ),
                  );
                },
                child: Text(
                  'Done',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
