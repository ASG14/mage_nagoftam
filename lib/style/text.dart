import 'package:flutter/material.dart';

import 'color.dart';

/// Begir Typography System.
///
/// The naming follows the familiar hierarchy of web typography:
///
/// H1 → Main page title
/// H2 → Section title
/// H3 → Sub-section title
/// H4 → Card / component title
///
/// Body → Main readable content
/// Body Small → Supporting content
/// Caption → Small secondary information
/// Label → Form and UI labels
/// Button → Button text
abstract final class AppTextStyles {
  // ============================================================
  // Headings
  // ============================================================

  /// H1
  ///
  /// Main title of a screen.
  static const TextStyle h1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.35,
    color: AppColors.textPrimary,
  );

  /// H2
  ///
  /// Main section heading.
  static const TextStyle h2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// H3
  ///
  /// Sub-section heading.
  static const TextStyle h3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  /// H4
  ///
  /// Card and component heading.
  static const TextStyle h4 = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w600,
    height: 1.5,
    color: AppColors.textPrimary,
  );

  // ============================================================
  // Body
  // ============================================================

  /// Main body text.
  static const TextStyle body = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    height: 1.7,
    color: AppColors.textSecondary,
  );

  /// Slightly emphasized body text.
  static const TextStyle bodyMedium = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    height: 1.7,
    color: AppColors.textPrimary,
  );

  /// Small body text.
  static const TextStyle bodySmall = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    height: 1.6,
    color: AppColors.textSecondary,
  );

  // ============================================================
  // UI Text
  // ============================================================

  /// Form labels and important UI labels.
  static const TextStyle label = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  /// Small secondary information.
  static const TextStyle caption = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.textTertiary,
  );

  /// Button text.
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.textOnPrimary,
  );

  /// Text used inside outlined / secondary buttons.
  static const TextStyle buttonSecondary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1.4,
    color: AppColors.primary,
  );

  // ============================================================
  // Shopping
  // ============================================================

  /// Shopping item title.
  static const TextStyle shoppingTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.45,
    color: AppColors.textPrimary,
  );

  /// Shopping item quantity.
  static const TextStyle shoppingQuantity = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 1.4,
    color: AppColors.textSecondary,
  );

  /// Shopping item status.
  static const TextStyle shoppingStatus = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1.4,
  );

  // ============================================================
  // Special
  // ============================================================

  /// Large number / statistic.
  static const TextStyle display = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 1.2,
    color: AppColors.textPrimary,
  );

  /// Error message.
  static const TextStyle error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 1.5,
    color: AppColors.error,
  );

  /// Success message.
  static const TextStyle success = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 1.5,
    color: AppColors.success,
  );
}