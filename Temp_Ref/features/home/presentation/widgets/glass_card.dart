import 'package:flutter/material.dart';

/// A reusable glass-like card container
class GlassCard extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double opacity;
  final BorderRadius? customBorderRadius;
  final EdgeInsetsGeometry padding;
  final Color? gradientStartColor;
  final Color? gradientEndColor;

  const GlassCard({
    Key? key,
    required this.child,
    this.borderRadius = 24,
    this.opacity = 0.2,
    this.customBorderRadius,
    this.padding = const EdgeInsets.all(16),
    this.gradientStartColor,
    this.gradientEndColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final finalBorderRadius =
        customBorderRadius ?? BorderRadius.circular(borderRadius);

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(opacity),
        borderRadius: finalBorderRadius,
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
        gradient: (gradientStartColor != null && gradientEndColor != null)
            ? LinearGradient(
                colors: [
                  gradientStartColor!.withOpacity(0.1),
                  gradientEndColor!.withOpacity(0.05),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: child,
    );
  }
}
