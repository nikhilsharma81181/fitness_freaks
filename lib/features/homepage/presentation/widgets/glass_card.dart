// File: lib/features/home/presentation/widgets/enhanced_glass_card.dart

import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class GlassCard extends StatelessWidget {
  final Widget child;
  final double cornerRadius;
  final double transparency;
  final Color? borderColor;
  final EdgeInsets? padding;

  const GlassCard({
    Key? key,
    required this.child,
    this.cornerRadius = 28,
    this.transparency = 0.8,
    this.borderColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cornerRadius),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Blurred background for frosted glass effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    color: Colors.white.withOpacity(0.01),
                  ),
                ),
              ),

              // Dark overlay for contrast
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    color: Pallate.cardBackground.withOpacity(
                      0.6 * transparency,
                    ),
                  ),
                ),
              ),

              // Subtle inner glow effect
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(0.01),
                        Colors.transparent,
                      ],
                      center: Alignment.topLeft,
                      radius: 1.0,
                    ),
                  ),
                ),
              ),

              // Glass highlight
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withOpacity(0.1),
                        Colors.transparent,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.center,
                    ),
                  ),
                ),
              ),

              // Refined border
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(cornerRadius),
                    border: Border.all(
                      width: 0.7,
                      color: borderColor ?? Colors.white.withOpacity(0.2),
                    ),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: padding ?? const EdgeInsets.all(24.0),
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
