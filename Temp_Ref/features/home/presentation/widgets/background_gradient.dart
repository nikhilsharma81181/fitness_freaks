import 'package:flutter/material.dart';

import '../../../../core/constants/colors.dart';

/// Background gradient widget used across the app
class BackgroundGradient extends StatelessWidget {
  final TabType forTab;

  const BackgroundGradient({
    Key? key,
    this.forTab = TabType.home,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Pure black background
        Container(
          color: Colors.black,
        ),

        // Vibrant radial gradient with frosted light source effect
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            width: screenSize.width,
            height: screenSize.height * 0.6,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: _getGradientColors(),
                center: Alignment.topRight,
                radius: 1.2,
                stops: const [0.1, 0.4, 0.9],
              ),
            ),
            child: Stack(
              children: [
                // Secondary smaller highlight for "light source" effect
                Positioned(
                  top: 20,
                  right: -20,
                  child: Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        colors: [
                          Colors.white.withValues(alpha: 0.4),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                        radius: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Subtle glass-like overlay
        Container(
          width: screenSize.width,
          height: screenSize.height,
          color: Colors.black.withValues(alpha: 0.1),
        ),
      ],
    );
  }

  List<Color> _getGradientColors() {
    switch (forTab) {
      case TabType.home:
        return [
          AppColors.homepageGradient1,
          AppColors.homepageGradient2.withValues(alpha: 0.5),
          Colors.transparent,
        ];
      case TabType.fitness:
        return [
          AppColors.fitnessGradient1,
          AppColors.fitnessGradient2.withValues(alpha: 0.5),
          Colors.transparent,
        ];
      case TabType.chat:
        return [
          AppColors.chatGradient1,
          AppColors.chatGradient2.withValues(alpha: 0.5),
          Colors.transparent,
        ];
      case TabType.profile:
        return [
          AppColors.profileGradient1,
          AppColors.profileGradient2.withValues(alpha: 0.5),
          Colors.transparent,
        ];
    }
  }
}

enum TabType {
  home,
  fitness,
  chat,
  profile,
}
