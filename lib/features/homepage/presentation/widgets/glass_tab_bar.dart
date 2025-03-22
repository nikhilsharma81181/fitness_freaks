
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:fitness_freaks/core/constant/colors/pallate.dart';

class GlassTabBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final List<BottomNavigationBarItem> items;

  const GlassTabBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100, // Height with safe area padding
      decoration: BoxDecoration(color: Colors.transparent),
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.only(top: 2),

            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 28, 28, 28).withOpacity(0.9),
              border: Border(
                top: BorderSide(
                  width: 0.5,
                  color: Colors.white.withOpacity(0.15),
                ),
              ),
            ),
            child: SafeArea(
              top: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final item = items[index];
                  final isSelected = index == currentIndex;

                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 0.0,
                      end: isSelected ? 1.0 : 0.0,
                    ),
                    duration: const Duration(
                      milliseconds: 350,
                    ), // Slightly quicker for better feel
                    curve: Curves.easeOutQuart, // More iOS-like curve
                    builder: (context, value, child) {
                      // Calculate the scale factor (from 1.0 to 1.1 for subtle effect)
                      final scale = 1.0 + (0.1 * value);

                      // Calculate color transition
                      final iconColor = Color.lerp(
                        Pallate.textTertiary,
                        Pallate.accentGreen,
                        value,
                      );

                      final textColor = Color.lerp(
                        Pallate.textTertiary,
                        Pallate.textPrimary,
                        value,
                      );

                      // Calculate glow opacity
                      final glowOpacity = 0.7 * value;

                      return GestureDetector(
                        onTap: () => onTap(index),
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          padding: const EdgeInsets.only(top: 10, bottom: 8),
                          width:
                              MediaQuery.of(context).size.width / items.length,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Glow effect that fades in/out smoothly
                              if (value > 0)
                                Positioned(
                                  top: 4,
                                  child: Opacity(
                                    opacity: glowOpacity,
                                    child: Container(
                                      width: 32, // Wider to match Swift UI
                                      height: 32,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(16),
                                        color: Pallate.accentGreen.withOpacity(
                                          0.15,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Pallate.accentGreen
                                                .withOpacity(0.5),
                                            blurRadius: 40,
                                            spreadRadius: 5,
                                            offset: const Offset(0, 0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  // Icon with smooth scaling
                                  Transform.scale(
                                    scale: scale,
                                    child: IconTheme(
                                      data: IconThemeData(
                                        color: iconColor,
                                        size: 24, // Matching Swift UI size
                                      ),
                                      child: item.icon,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  // Text with smooth color transition
                                  Text(
                                    item.label ?? '',
                                    style: TextStyle(
                                      fontSize: 11, // Matching Swift UI size
                                      fontWeight:
                                          value > 0.5
                                              ? FontWeight.w500
                                              : FontWeight.normal,
                                      color: textColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
