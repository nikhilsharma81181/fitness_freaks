import 'package:flutter/material.dart';

enum TabType {
  home,
  sleep,
  activity,
  profile,
}

class BackgroundGradient extends StatelessWidget {
  final TabType forTab;

  const BackgroundGradient({
    Key? key,
    required this.forTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Different gradient colors based on the selected tab
    List<Color> gradientColors;

    switch (forTab) {
      case TabType.home:
        // Turquoise to dark gradient (like Metabolic health screen)
        gradientColors = [
          const Color(0xFF1A6B47),
          const Color(0xFF0A3B27),
          Colors.black,
        ];
        break;
      case TabType.sleep:
        // Deep blue to dark gradient (like Sleep screen)
        gradientColors = [
          const Color(0xFF2A6799),
          const Color(0xFF193D5B),
          Colors.black,
        ];
        break;
      case TabType.activity:
        // Orange/copper to dark gradient (like Movement screen)
        gradientColors = [
          const Color(0xFF8F5211),
          const Color(0xFF593613),
          Colors.black,
        ];
        break;
      case TabType.profile:
        // Purple to dark gradient (like Stress tracking screen)
        gradientColors = [
          const Color(0xFF563D7C),
          const Color(0xFF2D2041),
          Colors.black,
        ];
        break;
    }

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: gradientColors,
          stops: const [0.0, 0.3, 1.0],
        ),
      ),
    );
  }
}
