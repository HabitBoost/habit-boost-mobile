import 'package:flutter/material.dart';

class HabitIcon extends StatelessWidget {
  const HabitIcon({
    required this.icon,
    required this.color,
    this.isCompleted = false,
    this.size = 40,
    super.key,
  });

  final String icon;
  final Color color;
  final bool isCompleted;
  final double size;

  static const _iconMap = <String, IconData>{
    'dumbbell': Icons.fitness_center,
    'run': Icons.directions_run,
    'water': Icons.water_drop,
    'book': Icons.menu_book,
    'meditation': Icons.self_improvement,
    'sleep': Icons.bedtime,
    'food': Icons.restaurant,
    'code': Icons.code,
    'music': Icons.music_note,
    'walk': Icons.directions_walk,
    'bike': Icons.pedal_bike,
    'heart': Icons.favorite,
    'star': Icons.star,
    'pill': Icons.medication,
    'brush': Icons.brush,
    'plant': Icons.eco,
    'sun': Icons.wb_sunny,
    'moon': Icons.nightlight_round,
    'chat': Icons.chat_bubble,
    'write': Icons.edit_note,
  };

  @override
  Widget build(BuildContext context) {
    final iconData = _iconMap[icon] ?? Icons.check_circle_outline;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: isCompleted ? 0.2 : 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        iconData,
        size: size * 0.55,
        color: color,
      ),
    );
  }
}
