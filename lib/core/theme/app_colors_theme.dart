import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';

/// Theme extension providing all app-specific colors
/// that adapt to light/dark mode.
class AppColorsTheme extends ThemeExtension<AppColorsTheme> {
  const AppColorsTheme({
    required this.bgPage,
    required this.bgCard,
    required this.bgHighlight,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
    required this.textDisabled,
    required this.borderSubtle,
    required this.borderEmpty,
    required this.badgeGreenBg,
    required this.badgeIndigoBg,
    required this.badgeYellowBg,
  });

  final Color bgPage;
  final Color bgCard;
  final Color bgHighlight;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;
  final Color textDisabled;
  final Color borderSubtle;
  final Color borderEmpty;
  final Color badgeGreenBg;
  final Color badgeIndigoBg;
  final Color badgeYellowBg;

  static const light = AppColorsTheme(
    bgPage: AppColors.bgPage,
    bgCard: AppColors.bgCard,
    bgHighlight: AppColors.bgHighlight,
    textPrimary: AppColors.textPrimary,
    textSecondary: AppColors.textSecondary,
    textTertiary: AppColors.textTertiary,
    textDisabled: AppColors.textDisabled,
    borderSubtle: AppColors.borderSubtle,
    borderEmpty: AppColors.borderEmpty,
    badgeGreenBg: AppColors.badgeGreenBg,
    badgeIndigoBg: AppColors.badgeIndigoBg,
    badgeYellowBg: AppColors.badgeYellowBg,
  );

  static const dark = AppColorsTheme(
    bgPage: AppColors.darkBgPage,
    bgCard: AppColors.darkBgCard,
    bgHighlight: AppColors.darkBgHighlight,
    textPrimary: AppColors.darkTextPrimary,
    textSecondary: AppColors.darkTextSecondary,
    textTertiary: AppColors.darkTextTertiary,
    textDisabled: AppColors.darkTextDisabled,
    borderSubtle: AppColors.darkBorderSubtle,
    borderEmpty: AppColors.darkBorderEmpty,
    badgeGreenBg: AppColors.darkBadgeGreenBg,
    badgeIndigoBg: AppColors.darkBadgeIndigoBg,
    badgeYellowBg: AppColors.darkBadgeYellowBg,
  );

  static AppColorsTheme of(BuildContext context) {
    return Theme.of(context).extension<AppColorsTheme>()!;
  }

  @override
  AppColorsTheme copyWith({
    Color? bgPage,
    Color? bgCard,
    Color? bgHighlight,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
    Color? textDisabled,
    Color? borderSubtle,
    Color? borderEmpty,
    Color? badgeGreenBg,
    Color? badgeIndigoBg,
    Color? badgeYellowBg,
  }) {
    return AppColorsTheme(
      bgPage: bgPage ?? this.bgPage,
      bgCard: bgCard ?? this.bgCard,
      bgHighlight: bgHighlight ?? this.bgHighlight,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
      textDisabled: textDisabled ?? this.textDisabled,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      borderEmpty: borderEmpty ?? this.borderEmpty,
      badgeGreenBg: badgeGreenBg ?? this.badgeGreenBg,
      badgeIndigoBg: badgeIndigoBg ?? this.badgeIndigoBg,
      badgeYellowBg: badgeYellowBg ?? this.badgeYellowBg,
    );
  }

  @override
  AppColorsTheme lerp(
    covariant AppColorsTheme? other,
    double t,
  ) {
    if (other == null) return this;
    return AppColorsTheme(
      bgPage: Color.lerp(bgPage, other.bgPage, t)!,
      bgCard: Color.lerp(bgCard, other.bgCard, t)!,
      bgHighlight:
          Color.lerp(bgHighlight, other.bgHighlight, t)!,
      textPrimary:
          Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(
        textSecondary,
        other.textSecondary,
        t,
      )!,
      textTertiary:
          Color.lerp(textTertiary, other.textTertiary, t)!,
      textDisabled:
          Color.lerp(textDisabled, other.textDisabled, t)!,
      borderSubtle:
          Color.lerp(borderSubtle, other.borderSubtle, t)!,
      borderEmpty:
          Color.lerp(borderEmpty, other.borderEmpty, t)!,
      badgeGreenBg:
          Color.lerp(badgeGreenBg, other.badgeGreenBg, t)!,
      badgeIndigoBg: Color.lerp(
        badgeIndigoBg,
        other.badgeIndigoBg,
        t,
      )!,
      badgeYellowBg: Color.lerp(
        badgeYellowBg,
        other.badgeYellowBg,
        t,
      )!,
    );
  }
}
