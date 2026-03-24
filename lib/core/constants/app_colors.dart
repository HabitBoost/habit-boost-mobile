import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF4CAF50);
  static const Color primaryDark = Color(0xFF2E7D32);

  // Accent
  static const Color accentCoral = Color(0xFFFF6B6B);
  static const Color accentGreen = Color(0xFF22C55E);
  static const Color accentIndigo = Color(0xFF6366F1);
  static const Color accentOrange = Color(0xFFD97706);
  static const Color accentYellow = Color(0xFFFCD34D);

  // Background — Light
  static const Color bgPage = Color(0xFFFFFFFF);
  static const Color bgCard = Color(0xFFF6F7F8);
  static const Color bgHighlight = Color(0xFFFFFBEB);

  // Background — Dark
  static const Color darkBgPage = Color(0xFF0F1117);
  static const Color darkBgCard = Color(0xFF1A1D27);
  static const Color darkBgHighlight = Color(0xFF2A2418);

  // Text — Light
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFFD1D5DB);

  // Text — Dark
  static const Color darkTextPrimary = Color(0xFFF5F5F5);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkTextTertiary = Color(0xFF6B7280);
  static const Color darkTextDisabled = Color(0xFF4B5563);

  // Border — Light
  static const Color borderSubtle = Color(0xFFF3F4F6);
  static const Color borderEmpty = Color(0xFFE5E7EB);

  // Border — Dark
  static const Color darkBorderSubtle = Color(0xFF2A2D37);
  static const Color darkBorderEmpty = Color(0xFF374151);

  // Badge backgrounds — Light
  static const Color badgeGreenBg = Color(0xFFF0FDF4);
  static const Color badgeIndigoBg = Color(0xFFF0F5FF);
  static const Color badgeYellowBg = Color(0xFFFFFBEB);

  // Badge backgrounds — Dark
  static const Color darkBadgeGreenBg = Color(0xFF1A2E1A);
  static const Color darkBadgeIndigoBg = Color(0xFF1A1D2E);
  static const Color darkBadgeYellowBg = Color(0xFF2E2A1A);
}
