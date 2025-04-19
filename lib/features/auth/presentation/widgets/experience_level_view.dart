import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:fitness_freaks_flutter/features/auth/domain/entities/user_onboarding_data.dart';
import 'package:google_fonts/google_fonts.dart';

/// View for selecting fitness experience level during onboarding
class ExperienceLevelView extends StatefulWidget {
  /// The onboarding data to update
  final UserOnboardingData onboardingData;

  /// Callback when data changes
  final VoidCallback onDataChanged;

  const ExperienceLevelView({
    Key? key,
    required this.onboardingData,
    required this.onDataChanged,
  }) : super(key: key);

  @override
  State<ExperienceLevelView> createState() => _ExperienceLevelViewState();
}

class _ExperienceLevelViewState extends State<ExperienceLevelView>
    with SingleTickerProviderStateMixin {
  // Animation state
  bool _appearAnimation = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  // Currently selected level
  late ExperienceLevel _selectedLevel;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );

    // Set initial selected level
    _selectedLevel = widget.onboardingData.experienceLevel;

    // Start appearance animation after a short delay
    Future.delayed(const Duration(milliseconds: 100), () {
      if (mounted) {
        setState(() {
          _appearAnimation = true;
        });
        _animationController.forward();
      }
    });
  }

  @override
  void didUpdateWidget(ExperienceLevelView oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset animations if onboarding data changes
    if (oldWidget.onboardingData != widget.onboardingData) {
      _appearAnimation = false;
      _animationController.reset();

      setState(() {});

      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          setState(() {
            _appearAnimation = true;
          });
          _animationController.forward();
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Introduction text
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Text(
                "Help us tailor your program by sharing your fitness experience level.",
                style: GoogleFonts.inter(
                  fontSize: 16,
                  color: Colors.white.withOpacity(0.8),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ),

        // Selected level display
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOut,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20.0),
                child: Column(
                  children: [
                    // Level name
                    Text(
                      _selectedLevel.name,
                      style: GoogleFonts.inter(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Level description
                    Text(
                      _selectedLevel.description,
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // Level visualizer
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 700),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _buildLevelVisualizer(),
            ),
          ),
        ),

        // Custom slider
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 800),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: _buildCustomSlider(),
            ),
          ),
        ),

        // Experience level examples
        AnimatedOpacity(
          opacity: _appearAnimation ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeOut,
          child: AnimatedSlide(
            offset: _appearAnimation ? Offset.zero : const Offset(0, 0.2),
            duration: const Duration(milliseconds: 900),
            curve: Curves.easeOut,
            child: Padding(
              padding: const EdgeInsets.only(top: 30.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.06),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: AppColors.vibrantTeal,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "What This Means",
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        _buildExperienceLevelExample(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Add bottom padding
        const SizedBox(height: 40),
      ],
    );
  }

  // Build a visual representation of the experience levels
  Widget _buildLevelVisualizer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: List.generate(5, (index) {
        final level = index + 1;
        final isSelected = _selectedLevel.level == level;
        final double height = 40.0 + (level * 15.0);

        return GestureDetector(
          onTap: () {
            // Provide haptic feedback
            HapticFeedback.mediumImpact();

            // Update selected level
            setState(() {
              _selectedLevel = ExperienceLevel.fromLevel(level);
              widget.onboardingData.experienceLevel = _selectedLevel;
              widget.onDataChanged();
            });
          },
          child: Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
                height: height,
                width: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: isSelected
                        ? [
                            AppColors.vibrantTeal.withOpacity(0.7),
                            AppColors.vibrantTeal,
                          ]
                        : [
                            Colors.white.withOpacity(0.1),
                            Colors.white.withOpacity(0.2),
                          ],
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.vibrantTeal.withOpacity(0.3),
                            blurRadius: 8,
                            spreadRadius: 0,
                          )
                        ]
                      : null,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? AppColors.vibrantTeal
                      : Colors.white.withOpacity(0.3),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // Build custom slider with a beautiful design
  Widget _buildCustomSlider() {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            activeTrackColor: AppColors.vibrantTeal,
            inactiveTrackColor: Colors.white.withOpacity(0.1),
            thumbColor: Colors.white,
            thumbShape: const _GlowingRoundSliderThumbShape(
              enabledThumbRadius: 12,
              glowColor: AppColors.vibrantTeal,
            ),
            overlayColor: AppColors.vibrantTeal.withOpacity(0.2),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 24),
            tickMarkShape: SliderTickMarkShape.noTickMark,
            showValueIndicator: ShowValueIndicator.never,
            valueIndicatorColor: Colors.transparent,
          ),
          child: Slider(
            value: _selectedLevel.level.toDouble(),
            min: 1,
            max: 5,
            divisions: 4,
            onChanged: (value) {
              final newLevel = value.round();
              if (newLevel != _selectedLevel.level) {
                HapticFeedback.selectionClick();
                setState(() {
                  _selectedLevel = ExperienceLevel.fromLevel(newLevel);
                  widget.onboardingData.experienceLevel = _selectedLevel;
                  widget.onDataChanged();
                });
              }
            },
          ),
        ),

        // Level labels
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildLevelText('Beginner'),
              _buildLevelText('Novice'),
              _buildLevelText('Intermediate'),
              _buildLevelText('Advanced'),
              _buildLevelText('Expert'),
            ],
          ),
        ),
      ],
    );
  }

  // Build a level label text
  Widget _buildLevelText(String text) {
    final isCurrentLevel =
        _selectedLevel.name.toLowerCase() == text.toLowerCase();

    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: isCurrentLevel ? FontWeight.w600 : FontWeight.w400,
        color: isCurrentLevel
            ? AppColors.vibrantTeal.withOpacity(0.9)
            : Colors.white.withOpacity(0.5),
      ),
    );
  }

  // Build experience level example based on the selected level
  Widget _buildExperienceLevelExample() {
    String exampleText;
    IconData iconData;

    switch (_selectedLevel.level) {
      case 1: // Beginner
        exampleText =
            "You're new to fitness or returning after a long break. We'll focus on building basic form and consistency with beginner-friendly workouts.";
        iconData = Icons.emoji_people;
        break;
      case 2: // Novice
        exampleText =
            "You have some workout experience. We'll help develop your strength and endurance with progressive workouts tailored to your growing abilities.";
        iconData = Icons.directions_walk;
        break;
      case 3: // Intermediate
        exampleText =
            "You've been working out consistently. We'll create balanced programs with more challenging exercises to keep advancing your fitness.";
        iconData = Icons.directions_run;
        break;
      case 4: // Advanced
        exampleText =
            "You're experienced and disciplined. We'll design targeted programs with advanced techniques to push your limits and break plateaus.";
        iconData = Icons.fitness_center;
        break;
      case 5: // Expert
        exampleText =
            "You have extensive training experience. We'll develop specialized programs with periodization and performance optimization for your goals.";
        iconData = Icons.sports_martial_arts;
        break;
      default:
        exampleText =
            "We'll create a balanced program tailored to your experience level.";
        iconData = Icons.fitness_center;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 3, right: 12),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.vibrantTeal.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            iconData,
            color: AppColors.vibrantTeal,
            size: 20,
          ),
        ),
        Expanded(
          child: Text(
            exampleText,
            style: GoogleFonts.inter(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
              height: 1.5,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom thumb shape for the slider with a glowing effect
class _GlowingRoundSliderThumbShape extends SliderComponentShape {
  final double enabledThumbRadius;
  final Color glowColor;

  const _GlowingRoundSliderThumbShape({
    required this.enabledThumbRadius,
    required this.glowColor,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(enabledThumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    // Draw glow effect
    final Paint glowPaint = Paint()
      ..color = glowColor.withOpacity(0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8.0);
    canvas.drawCircle(center, enabledThumbRadius * 1.8, glowPaint);

    // Draw inner glow
    final Paint innerGlowPaint = Paint()
      ..color = glowColor.withOpacity(0.5)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);
    canvas.drawCircle(center, enabledThumbRadius * 1.2, innerGlowPaint);

    // Draw white thumb
    final Paint thumbPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, enabledThumbRadius, thumbPaint);

    // Draw border
    final Paint borderPaint = Paint()
      ..color = Colors.white.withOpacity(0.8)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, enabledThumbRadius, borderPaint);
  }
}
