import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/l10n/app_localizations.dart';

class UserGoals extends Equatable {
  const UserGoals({this.selectedGoals = const []});

  final List<GoalCategory> selectedGoals;

  @override
  List<Object> get props => [selectedGoals];
}

enum GoalCategory {
  health(
    icon: Icons.favorite_outline,
    color: AppColors.primary,
    bgColor: AppColors.badgeGreenBg,
  ),
  productivity(
    icon: Icons.bolt_outlined,
    color: AppColors.accentCoral,
    bgColor: AppColors.bgCard,
  ),
  mentalHealth(
    icon: Icons.psychology_outlined,
    color: AppColors.accentIndigo,
    bgColor: AppColors.bgCard,
  ),
  sport(
    icon: Icons.fitness_center_outlined,
    color: AppColors.primary,
    bgColor: AppColors.badgeGreenBg,
  ),
  nutrition(
    icon: Icons.restaurant_outlined,
    color: AppColors.accentOrange,
    bgColor: AppColors.bgCard,
  ),
  learning(
    icon: Icons.menu_book_outlined,
    color: AppColors.accentOrange,
    bgColor: AppColors.bgCard,
  );

  const GoalCategory({
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final Color color;
  final Color bgColor;

  String localizedLabel(AppLocalizations l10n) {
    switch (this) {
      case GoalCategory.health:
        return l10n.goalHealth;
      case GoalCategory.productivity:
        return l10n.goalProductivity;
      case GoalCategory.mentalHealth:
        return l10n.goalMentalHealth;
      case GoalCategory.sport:
        return l10n.goalSport;
      case GoalCategory.nutrition:
        return l10n.goalNutrition;
      case GoalCategory.learning:
        return l10n.goalLearning;
    }
  }
}
