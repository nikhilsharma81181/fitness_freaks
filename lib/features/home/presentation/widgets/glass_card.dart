import 'dart:ui';
import 'package:flutter/material.dart';

class EnhancedGlassCard extends StatelessWidget {
  final Widget child;
  final double cornerRadius;
  final double transparency;
  final EdgeInsetsGeometry padding;

  const EnhancedGlassCard({
    Key? key,
    required this.child,
    this.cornerRadius = 24.0,
    this.transparency = 0.7,
    this.padding = const EdgeInsets.all(24.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(cornerRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          width: double.infinity,
          padding: padding,
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.07),
            borderRadius: BorderRadius.circular(cornerRadius),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: 1.0,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
