import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';

class LogoHeader extends StatelessWidget {
  const LogoHeader({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 32.0 : 48.0;
    final circleSize = compact ? 40.0 : 48.0;
    final fontSize = compact ? 20.0 : 24.0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: circleSize,
          height: circleSize,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(circleSize / 2),
          ),
          child: Icon(
            Icons.eco,
            color: Colors.white,
            size: iconSize * 0.5,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'HabitBoost',
          style: TextStyle(
            fontFamily: 'BricolageGrotesque',
            fontSize: fontSize,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
