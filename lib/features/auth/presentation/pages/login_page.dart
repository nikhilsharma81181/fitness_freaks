// login_page.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/features/home/presentation/pages/homepage.dart';
import 'onboarding_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _cardAnimation;
  late Animation<double> _buttonAnimation;
  late Animation<double> _termsAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.3, 0.6, curve: Curves.easeOut),
    );

    _cardAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 0.7, curve: Curves.easeOut),
    );

    _buttonAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 0.9, curve: Curves.easeOut),
    );

    _termsAnimation = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.8, 1.0, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Ensure the Scaffold background itself is dark if the gradient doesn't cover edges
      backgroundColor: AppColors.darkBackground,
      body: Container(
        // *** GRADIENT IMPROVEMENT AREA ***
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // Changed angle for more dynamism
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            // Added a third color for smoother transition and depth
            colors: [
              AppColors.darkBackground, // Start with the base dark color
              AppColors.sleepGradient[0]
                  .withOpacity(0.85), // Use a darker shade from sleep gradient
              AppColors.sleepGradient[1]
                  .withOpacity(0.7), // End with a slightly lighter shade
              // Alternative using different colors:
              // AppColors.darkBackground,
              // Color(0xFF0A2A3F), // A deep, dark blue
              // Color(0xFF003545), // A dark teal/cyan
            ],
            // Adjusted stops for better blending
            stops: const [0.0, 0.5, 1.0],
          ),
        ),
        // *** END GRADIENT IMPROVEMENT AREA ***
        child: SafeArea(
          child: Stack(
            children: [
              // Background subtle pattern (optional, keep if desired)
              Positioned.fill(
                child: ShaderMask(
                  shaderCallback: (Rect bounds) {
                    return LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        AppColors.vibrantMint
                            .withOpacity(0.03), // Reduced opacity
                      ],
                      stops: const [0.5, 1.0], // Make it fade in lower down
                    ).createShader(bounds);
                  },
                  blendMode: BlendMode.srcOver,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.transparent, // Needs a color for ShaderMask
                    ),
                  ),
                ),
              ),

              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 25),
                        // Logo with pulse animation
                        AnimatedBuilder(
                          animation: _logoAnimation,
                          builder: (context, child) {
                            return Transform.scale(
                              scale: 0.9 + 0.1 * _logoAnimation.value,
                              child: FadeTransition(
                                opacity: _logoAnimation,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            width: 90,
                            height: 90,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: AppColors.accentGradient,
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.vibrantMint.withOpacity(0.3),
                                  blurRadius: 30,
                                  spreadRadius: 0,
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.heart_fill,
                                size: 40,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        // App title with fade animation
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(_fadeAnimation),
                            child: Text(
                              'FITNESS FREAKS',
                              style: GoogleFonts.inter(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.2),
                              end: Offset.zero,
                            ).animate(_fadeAnimation),
                            child: Text(
                              'Your Personal AI Fitness Coach',
                              style: GoogleFonts.inter(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: AppColors.secondaryTextColor,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 100),

                        // Glass card for sign in options with slide-up animation
                        FadeTransition(
                          opacity: _cardAnimation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0, 0.1),
                              end: Offset.zero,
                            ).animate(_cardAnimation),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: AppColors.glassBackground,
                                    borderRadius: BorderRadius.circular(24),
                                    border: Border.all(
                                      color: AppColors.glassBorder,
                                      width: 1.5,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 24.0,
                                      vertical: 32.0,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Sign in to continue',
                                          style: GoogleFonts.inter(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 36),

                                        // Animate buttons
                                        FadeTransition(
                                          opacity: _buttonAnimation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 0.1),
                                              end: Offset.zero,
                                            ).animate(_buttonAnimation),
                                            child: _buildSignInButton(
                                              text: 'Continue with Google',
                                              icon: FontAwesomeIcons.google,
                                              onPressed: () {
                                                _navigateToHome(context);
                                              },
                                              // Google button text usually isn't white on dark backgrounds
                                              textColor: Colors.black,
                                              iconColor: Colors.black,
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 16),

                                        // Apple Sign In Button
                                        FadeTransition(
                                          opacity: _buttonAnimation,
                                          child: SlideTransition(
                                            position: Tween<Offset>(
                                              begin: const Offset(0, 0.1),
                                              end: Offset.zero,
                                            ).animate(_buttonAnimation),
                                            child: _buildSignInButton(
                                              text: 'Continue with Apple',
                                              icon: FontAwesomeIcons.apple,
                                              isApple: true,
                                              onPressed: () {
                                                _navigateToHome(context);
                                              },
                                            ),
                                          ),
                                        ),

                                        const SizedBox(height: 32),

                                        // Terms text with fade animation
                                        FadeTransition(
                                          opacity: _termsAnimation,
                                          child: Text(
                                            'By continuing, you agree to our Terms of Service and Privacy Policy',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.inter(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w400,
                                              color:
                                                  AppColors.secondaryTextColor,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40), // Added padding at bottom
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome(BuildContext context) {
    // Navigate to onboarding flow instead of directly to home
    Navigator.of(context).pushReplacement(
      CupertinoPageRoute(
        builder: (context) => const OnboardingPage(),
      ),
    );
  }

  Widget _buildSignInButton({
    required String text,
    required IconData icon,
    bool isApple = false,
    required VoidCallback onPressed,
    Color textColor = Colors.white,
    Color iconColor = Colors.white,
  }) {
    // Using a simple ButtonStyle for consistency, but keeping glass effect
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: ElevatedButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isApple ? Colors.black.withOpacity(0.6) : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.glassBorder, width: 1),
            ),
            // Remove shadow if using glass effect primarily
            elevation: 0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(
                icon,
                color: iconColor,
                size: isApple ? 22 : 20,
              ),
              const SizedBox(width: 16),
              Text(
                text,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
