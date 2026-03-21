import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';

class UserGoals extends Equatable {
  const UserGoals({this.selectedGoals = const []});

  final List<GoalCategory> selectedGoals;

  @override
  List<Object> get props => [selectedGoals];
}

enum GoalCategory {
  health(
    label: 'Здоровье',
    icon: Icons.favorite_outline,
    color: AppColors.primary,
    bgColor: AppColors.badgeGreenBg,
  ),
  productivity(
    label: 'Продуктивность',
    icon: Icons.bolt_outlined,
    color: AppColors.accentCoral,
    bgColor: AppColors.bgCard,
  ),
  mentalHealth(
    label: 'Ментальное\nсостояние',
    icon: Icons.psychology_outlined,
    color: AppColors.accentIndigo,
    bgColor: AppColors.bgCard,
  ),
  sport(
    label: 'Спорт',
    icon: Icons.fitness_center_outlined,
    color: AppColors.primary,
    bgColor: AppColors.badgeGreenBg,
  ),
  nutrition(
    label: 'Питание',
    icon: Icons.restaurant_outlined,
    color: AppColors.accentOrange,
    bgColor: AppColors.bgCard,
  ),
  learning(
    label: 'Обучение',
    icon: Icons.menu_book_outlined,
    color: AppColors.accentOrange,
    bgColor: AppColors.bgCard,
  );

  const GoalCategory({
    required this.label,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final String label;
  final IconData icon;
  final Color color;
  final Color bgColor;
}
