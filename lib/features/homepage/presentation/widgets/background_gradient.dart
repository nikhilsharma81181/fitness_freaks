import 'package:fitness_freaks/core/constant/colors/pallate.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class BackgroundGradient extends StatelessWidget {
  final TabType tabType;
  
  const BackgroundGradient({
    super.key, 
    this.tabType = TabType.home,
  });

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    
    // Determine colors based on selected tab
    final Color primaryColor;
    final Color secondaryColor;
    
    switch (tabType) {
      case TabType.home:
        primaryColor = Pallate.homepageGradient1;
        secondaryColor = Pallate.homepageGradient2;
        break;
      case TabType.fitness:
        primaryColor = Pallate.fitnessGradient1;
        secondaryColor = Pallate.fitnessGradient2;
        break;
      case TabType.chat:
        primaryColor = Pallate.chatGradient1;
        secondaryColor = Pallate.chatGradient2;
        break;
      case TabType.profile:
        primaryColor = Pallate.profileGradient1;
        secondaryColor = Pallate.profileGradient2;
        break;
    }

    return SizedBox(
      width: screenSize.width,
      height: screenSize.height,
      child: Stack(
        children: [
          // Pure black background
          Container(
            color: Pallate.darkBackground,
            width: screenSize.width,
            height: screenSize.height,
          ),
      
          // Main radial gradient positioned at top right
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: screenSize.width,
              height: screenSize.height * 0.5,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    primaryColor,
                    secondaryColor.withOpacity(0.7),
                    Colors.transparent,
                  ],
                  center: Alignment.topRight,
                  radius: 1.4,
                  stops: const [0.0, 0.3, 1.0],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
      
          // Secondary smaller highlight for "light source" effect
          Positioned(
            top: 70,
            right: 50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [Colors.white.withOpacity(0.4), Colors.transparent],
                  center: Alignment.center,
                  radius: 0.5,
                  stops: const [0.0, 1.0],
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
      
          // Additional mood gradient based on tab type
          if (tabType == TabType.home) ...[
            // For homepage: subtle bottom accent for balance
            Positioned(
              bottom: screenSize.height * 0.2,
              left: 0,
              child: Container(
                width: screenSize.width,
                height: screenSize.height * 0.3,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      secondaryColor.withOpacity(0.2),
                      Colors.transparent,
                    ],
                    center: Alignment.bottomLeft,
                    radius: 1.2,
                  ),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(color: Colors.transparent),
                ),
              ),
            ),
          ],
      
          // Subtle glass-like overlay for entire screen
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.01)),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum TabType {
  home,
  fitness,
  chat,
  profile,
}