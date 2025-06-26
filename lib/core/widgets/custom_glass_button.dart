import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

class CustomGlassButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? gradientStartColor;
  final Color? gradientEndColor;
  final Color? textColor;
  final Color? accentColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final double? height;
  final bool useAccentGlow;

  const CustomGlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.gradientStartColor,
    this.gradientEndColor,
    this.textColor,
    this.accentColor,
    this.fontSize = 18,
    this.fontWeight = FontWeight.w500,
    this.padding = const EdgeInsets.symmetric(vertical: 16),
    this.borderRadius = 16,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
    this.useAccentGlow = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color startColor =
        gradientStartColor ?? AppColors.primaryColor.withOpacity(0.9);
    final Color endColor =
        gradientEndColor ?? AppColors.primaryColor.withOpacity(0.7);
    final Color finalTextColor = textColor ?? AppColors.darkBackground;
    final Color finalAccentColor = accentColor ?? startColor.withOpacity(1.0);

    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius! + 1),
          boxShadow: [
            // Subtle outer shadow for depth
            BoxShadow(
              color: finalAccentColor.withOpacity(0.2),
              blurRadius: 12,
              spreadRadius: 0,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius!),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              width: width ?? double.infinity,
              height: height,
              padding: padding,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [startColor, endColor],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(borderRadius!),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.0,
                ),
                boxShadow: [
                  // Inner highlight for subtle depth
                  BoxShadow(
                    color: Colors.white.withOpacity(0.05),
                    blurRadius: 0,
                    spreadRadius: 0,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Accent glow (subtle)
                  if (useAccentGlow)
                    Positioned(
                      top: -15,
                      right: -15,
                      child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              finalAccentColor.withOpacity(0.3),
                              finalAccentColor.withOpacity(0.0),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                      ),
                    ),

                  // Button content
                  Center(
                    child: isLoading
                        ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(finalTextColor),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (icon != null) ...[
                                Icon(
                                  icon,
                                  color: finalTextColor,
                                  size: fontSize! + 2,
                                  shadows: [
                                    Shadow(
                                      color: finalAccentColor.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 8),
                              ],
                              Text(
                                text,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.inter(
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                  color: finalTextColor,
                                  shadows: [
                                    Shadow(
                                      color: finalAccentColor.withOpacity(0.3),
                                      blurRadius: 5,
                                      offset: const Offset(0, 1),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Predefined button variants for common use cases
class GlassButtonVariants {
  // Primary button (default green gradient)
  static Widget primary({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      isLoading: isLoading,
      icon: icon,
      width: width,
      accentColor: accentColor,
    );
  }

  // Secondary button (blue gradient)
  static Widget secondary({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: AppColors.homepageGradient1.withOpacity(0.9),
      gradientEndColor: AppColors.homepageGradient2.withOpacity(0.7),
      accentColor: accentColor ?? AppColors.homepageGradient1,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  // Danger button (red gradient)
  static Widget danger({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: AppColors.errorColor.withOpacity(0.9),
      gradientEndColor: AppColors.errorColor.withOpacity(0.7),
      accentColor: accentColor ?? AppColors.errorColor,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  // Success button (green gradient)
  static Widget success({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: AppColors.successColor.withOpacity(0.9),
      gradientEndColor: AppColors.successColor.withOpacity(0.7),
      accentColor: accentColor ?? AppColors.successColor,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  // Profile button (profile gradient)
  static Widget profile({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: AppColors.profileGradient1.withOpacity(0.9),
      gradientEndColor: AppColors.profileGradient2.withOpacity(0.7),
      accentColor: accentColor ?? AppColors.profileGradient1,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  // Fitness button (fitness gradient)
  static Widget fitness({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: AppColors.fitnessGradient1.withOpacity(0.9),
      gradientEndColor: AppColors.fitnessGradient2.withOpacity(0.7),
      accentColor: accentColor ?? AppColors.fitnessGradient1,
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }

  // Transparent/Ghost button
  static Widget ghost({
    required String text,
    required VoidCallback onTap,
    bool isLoading = false,
    IconData? icon,
    double? width,
    Color? accentColor,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: Colors.white.withOpacity(0.1),
      gradientEndColor: Colors.white.withOpacity(0.05),
      accentColor: accentColor ?? Colors.white.withOpacity(0.5),
      textColor: Colors.white,
      isLoading: isLoading,
      icon: icon,
      width: width,
      useAccentGlow: false,
    );
  }

  // Small button variant
  static Widget small({
    required String text,
    required VoidCallback onTap,
    Color? gradientStartColor,
    Color? gradientEndColor,
    Color? textColor,
    Color? accentColor,
    bool isLoading = false,
    IconData? icon,
    double? width,
  }) {
    return CustomGlassButton(
      text: text,
      onTap: onTap,
      gradientStartColor: gradientStartColor,
      gradientEndColor: gradientEndColor,
      accentColor: accentColor,
      textColor: textColor,
      fontSize: 14,
      fontWeight: FontWeight.w500,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      borderRadius: 12,
      isLoading: isLoading,
      icon: icon,
      width: width,
    );
  }
}
