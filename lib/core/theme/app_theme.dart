import 'package:flutter/material.dart';
import 'package:habit_boost/core/constants/app_colors.dart';
import 'package:habit_boost/core/constants/app_dimensions.dart';
import 'package:habit_boost/core/theme/app_colors_theme.dart';

abstract class AppTheme {
  static const _fontHeading = 'BricolageGrotesque';
  static const _fontBody = 'DMSans';

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      surface: AppColors.bgPage,
      onSurface: AppColors.textPrimary,
      error: AppColors.accentCoral,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      bgPage: AppColors.bgPage,
      bgCard: AppColors.bgCard,
      textPrimary: AppColors.textPrimary,
      textSecondary: AppColors.textSecondary,
      borderSubtle: AppColors.borderSubtle,
      colorsTheme: AppColorsTheme.light,
    );
  }

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: Brightness.dark,
      surface: AppColors.darkBgPage,
      onSurface: AppColors.darkTextPrimary,
      error: AppColors.accentCoral,
    );

    return _buildTheme(
      colorScheme: colorScheme,
      bgPage: AppColors.darkBgPage,
      bgCard: AppColors.darkBgCard,
      textPrimary: AppColors.darkTextPrimary,
      textSecondary: AppColors.darkTextSecondary,
      borderSubtle: AppColors.darkBorderSubtle,
      colorsTheme: AppColorsTheme.dark,
    );
  }

  static ThemeData _buildTheme({
    required ColorScheme colorScheme,
    required Color bgPage,
    required Color bgCard,
    required Color textPrimary,
    required Color textSecondary,
    required Color borderSubtle,
    required AppColorsTheme colorsTheme,
  }) {
    final textTheme = TextTheme(
      displayLarge: const TextStyle(
        fontFamily: _fontHeading,
        fontSize: 36,
        fontWeight: FontWeight.w800,
      ),
      headlineLarge: const TextStyle(
        fontFamily: _fontHeading,
        fontSize: 28,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: const TextStyle(
        fontFamily: _fontHeading,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      titleLarge: const TextStyle(
        fontFamily: _fontHeading,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
      titleMedium: TextStyle(
        fontFamily: _fontBody,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(
        fontFamily: _fontBody,
        fontSize: 15,
        fontWeight: FontWeight.w400,
        height: 1.5,
        color: textPrimary,
      ),
      bodyMedium: TextStyle(
        fontFamily: _fontBody,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      ),
      labelLarge: const TextStyle(
        fontFamily: _fontBody,
        fontSize: 15,
        fontWeight: FontWeight.w600,
      ),
      labelMedium: const TextStyle(
        fontFamily: _fontBody,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: const TextStyle(
        fontFamily: _fontBody,
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      fontFamily: _fontBody,
      textTheme: textTheme,
      cardTheme: CardThemeData(
        elevation: 0,
        color: bgCard,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusCard,
          ),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          textStyle: const TextStyle(
            fontFamily: _fontBody,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: _fontBody,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.accentCoral,
          textStyle: const TextStyle(
            fontFamily: _fontBody,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: bgCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusButton,
          ),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusButton,
          ),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusButton,
          ),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            AppDimensions.radiusButton,
          ),
          borderSide: const BorderSide(
            color: AppColors.accentCoral,
          ),
        ),
        labelStyle: TextStyle(
          fontFamily: _fontBody,
          fontSize: 14,
          color: textSecondary,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.paddingM,
          vertical: AppDimensions.paddingM,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: bgPage,
        foregroundColor: textPrimary,
        titleTextStyle: TextStyle(
          fontFamily: _fontHeading,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          color: textPrimary,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: bgPage,
        indicatorColor:
            AppColors.primary.withValues(alpha: 0.12),
        labelBehavior:
            NavigationDestinationLabelBehavior.alwaysShow,
        height: AppDimensions.bottomNavHeight,
        labelTextStyle:
            WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const TextStyle(
              fontFamily: _fontBody,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            );
          }
          return TextStyle(
            fontFamily: _fontBody,
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: textSecondary,
          );
        }),
      ),
      scaffoldBackgroundColor: bgPage,
      dividerColor: borderSubtle,
      dialogTheme: DialogThemeData(
        backgroundColor: bgCard,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : textSecondary,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primary
              : bgCard,
        ),
      ),
      extensions: [colorsTheme],
    );
  }
}
