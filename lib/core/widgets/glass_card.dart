import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fitness_freaks_flutter/core/constants/app_colors.dart';

/// A reusable glass card widget with frosted glass effect
class GlassCard extends StatelessWidget {
  /// Child widget to display inside the glass card
  final Widget child;

  /// Border radius of the glass card
  final double borderRadius;

  /// Opacity of the glass effect
  final double opacity;

  /// Border color of the glass card
  final Color? borderColor;

  /// Border width of the glass card
  final double borderWidth;

  /// Padding to apply to the child
  final EdgeInsetsGeometry padding;

  /// Shadow opacity (0.0 to 1.0)
  final double shadowOpacity;

  /// Shadow blur radius
  final double shadowBlurRadius;

  /// Background color of the glass card (will be applied with opacity)
  final Color? backgroundColor;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 16.0,
    this.opacity = 0.05,
    this.borderColor,
    this.borderWidth = 1.5,
    this.padding = const EdgeInsets.all(16.0),
    this.shadowOpacity = 0.1,
    this.shadowBlurRadius = 10.0,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Colors.white.withOpacity(opacity),
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: borderColor ?? AppColors.glassBorder,
              width: borderWidth,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(shadowOpacity),
                blurRadius: shadowBlurRadius,
                spreadRadius: 0,
              ),
            ],
          ),
          padding: padding,
          child: child,
        ),
      ),
    );
  }
}

/// Extension to easily apply glass card effect to any widget
extension GlassCardExtension on Widget {
  Widget glassCard({
    double borderRadius = 16.0,
    double opacity = 0.05,
    Color? borderColor,
    double borderWidth = 1.5,
    EdgeInsetsGeometry padding = const EdgeInsets.all(16.0),
    double shadowOpacity = 0.1,
    double shadowBlurRadius = 10.0,
    Color? backgroundColor,
  }) {
    return GlassCard(
      borderRadius: borderRadius,
      opacity: opacity,
      borderColor: borderColor,
      borderWidth: borderWidth,
      padding: padding,
      shadowOpacity: shadowOpacity,
      shadowBlurRadius: shadowBlurRadius,
      backgroundColor: backgroundColor,
      child: this,
    );
  }
}
