import 'package:flutter/material.dart';

/// A card displaying user statistics on the profile page
class ProfileStatsCard extends StatelessWidget {
  const ProfileStatsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sample stats data
    final stats = [
      {'icon': Icons.local_fire_department, 'label': 'Workouts', 'value': '24', 'iconColor': Colors.orange},
      {'icon': Icons.timer, 'label': 'Hours', 'value': '42', 'iconColor': Colors.blue},
      {'icon': Icons.emoji_events, 'label': 'Achievements', 'value': '8', 'iconColor': Colors.yellow},
      {'icon': Icons.bolt, 'label': 'Streak', 'value': '6', 'iconColor': Colors.green},
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'My Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Stats grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.5,
            children: stats.map((stat) {
              return _buildStatItem(
                icon: stat['icon'] as IconData,
                label: stat['label'] as String,
                value: stat['value'] as String,
                iconColor: stat['iconColor'] as Color,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  
  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Icon
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          
          // Value and label
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
