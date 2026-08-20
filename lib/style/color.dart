import 'package:flutter/material.dart';

/// Begir Design System
///
/// Centralized color palette for the entire application.
/// Do not define random colors inside widgets.
/// Add new colors here when necessary.
abstract final class AppColors {
  // ============================================================
  // Brand
  // ============================================================

  /// Main brand color.
  static const Color primary = Color(0xFF16A085);

  /// Darker version of primary for pressed states / emphasis.
  static const Color primaryDark = Color(0xFF117A65);

  /// Lighter version of primary.
  static const Color primaryLight = Color(0xFF48C9B0);

  /// Very light primary background.
  static const Color primarySurface = Color(0xFFE8F8F5);

  // ============================================================
  // Secondary
  // ============================================================

  static const Color secondary = Color(0xFF34495E);

  static const Color secondaryLight = Color(0xFF5D6D7E);

  static const Color secondarySurface = Color(0xFFF2F4F5);

  // ============================================================
  // Background & Surface
  // ============================================================

  static const Color background = Color(0xFFF8FAF9);

  static const Color surface = Color(0xFFFFFFFF);

  static const Color surfaceVariant = Color(0xFFF1F4F3);

  static const Color card = Color(0xFFFFFFFF);

  // ============================================================
  // Text
  // ============================================================

  /// Main headings and important text.
  static const Color textPrimary = Color(0xFF17202A);

  /// Normal body text.
  static const Color textSecondary = Color(0xFF566573);

  /// Supporting / less important text.
  static const Color textTertiary = Color(0xFF85929E);

  /// Text placed on primary-colored backgrounds.
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  /// Text placed on dark backgrounds.
  static const Color textOnDark = Color(0xFFFFFFFF);

  // ============================================================
  // Border & Divider
  // ============================================================

  static const Color border = Color(0xFFE5E8E8);

  static const Color borderLight = Color(0xFFF0F2F2);

  static const Color divider = Color(0xFFEAEDED);

  // ============================================================
  // Status Colors
  // ============================================================

  /// Success / purchased / completed.
  static const Color success = Color(0xFF27AE60);

  static const Color successSurface = Color(0xFFEAF8F0);

  /// Warning / urgent.
  static const Color warning = Color(0xFFF39C12);

  static const Color warningSurface = Color(0xFFFEF5E7);

  /// Error / destructive actions.
  static const Color error = Color(0xFFE74C3C);

  static const Color errorSurface = Color(0xFFFDEDEC);

  /// Informational messages.
  static const Color info = Color(0xFF3498DB);

  static const Color infoSurface = Color(0xFFEBF5FB);

  // ============================================================
  // Shopping Item States
  // ============================================================

  /// Item is waiting for someone to buy it.
  static const Color pending = Color(0xFFF39C12);

  /// Someone has taken responsibility for buying it.
  static const Color reserved = Color(0xFF3498DB);

  /// Item has been purchased.
  static const Color purchased = Color(0xFF27AE60);

  /// Item has been cancelled.
  static const Color cancelled = Color(0xFF95A5A6);

  // ============================================================
  // Priority
  // ============================================================

  /// Low priority.
  static const Color priorityLow = Color(0xFF27AE60);

  /// Normal priority.
  static const Color priorityNormal = Color(0xFF3498DB);

  /// High priority.
  static const Color priorityHigh = Color(0xFFF39C12);

  /// Critical priority.
  static const Color priorityCritical = Color(0xFFE74C3C);

  // ============================================================
  // Utility
  // ============================================================

  static const Color transparent = Colors.transparent;

  static const Color black = Color(0xFF000000);

  static const Color white = Color(0xFFFFFFFF);
}