// lib/core/themes/theme.dart

import 'package:flutter/material.dart';

import 'color.dart';
import 'text.dart';

class AppTheme {
  AppTheme._();

  // ============================================================
  // Light Theme
  // ============================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // ============================================================
    // Color Scheme
    // ============================================================

    colorScheme: const ColorScheme(
      brightness: Brightness.light,

      // Brand
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,

      primaryContainer: AppColors.primarySurface,
      onPrimaryContainer: AppColors.primaryDark,

      // Secondary
      secondary: AppColors.secondary,
      onSecondary: AppColors.textOnPrimary,

      secondaryContainer: AppColors.secondarySurface,
      onSecondaryContainer: AppColors.secondary,

      // Surface
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,

      // Error
      error: AppColors.error,
      onError: AppColors.textOnPrimary,

      // Borders
      outline: AppColors.border,
      outlineVariant: AppColors.borderLight,

      // Inverse
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.textOnDark,
      inversePrimary: AppColors.primaryLight,
    ),

    // ============================================================
    // General
    // ============================================================

    primaryColor: AppColors.primary,

    scaffoldBackgroundColor: AppColors.background,

    cardColor: AppColors.card,

    dividerColor: AppColors.divider,

    // ============================================================
    // AppBar
    // ============================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,

      elevation: 0,
      scrolledUnderElevation: 0,

      centerTitle: true,

      titleTextStyle: AppTextStyles.h3,

      iconTheme: IconThemeData(
        color: AppColors.textPrimary,
        size: 24,
      ),
    ),

    // ============================================================
    // Typography
    // ============================================================

    textTheme: const TextTheme(
      // Display
      displayLarge: AppTextStyles.display,

      // Headings
      headlineLarge: AppTextStyles.h1,
      headlineMedium: AppTextStyles.h2,
      headlineSmall: AppTextStyles.h3,

      // Titles
      titleLarge: AppTextStyles.h4,

      // Body
      bodyLarge: AppTextStyles.body,
      bodyMedium: AppTextStyles.bodyMedium,
      bodySmall: AppTextStyles.bodySmall,

      // Labels
      labelLarge: AppTextStyles.button,
      labelMedium: AppTextStyles.label,
      labelSmall: AppTextStyles.caption,
    ),

    // ============================================================
    // Elevated Button
    // ============================================================

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,

        minimumSize: const Size(
          double.infinity,
          48,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),

        textStyle: AppTextStyles.button,

        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textTertiary,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark.withValues(
                alpha: 0.20,
              );
            }

            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryLight.withValues(
                alpha: 0.15,
              );
            }

            return null;
          },
        ),
      ),
    ),

    // ============================================================
    // Filled Button
    // ============================================================

    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.textOnPrimary,

        minimumSize: const Size(
          double.infinity,
          48,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),

        textStyle: AppTextStyles.button,

        disabledBackgroundColor: AppColors.border,
        disabledForegroundColor: AppColors.textTertiary,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primaryDark.withValues(
                alpha: 0.20,
              );
            }

            if (states.contains(WidgetState.hovered)) {
              return AppColors.primaryLight.withValues(
                alpha: 0.15,
              );
            }

            return null;
          },
        ),
      ),
    ),

    // ============================================================
    // Outlined Button
    // ============================================================

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.surface,

        foregroundColor: AppColors.primary,

        minimumSize: const Size(
          double.infinity,
          48,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),

        side: const BorderSide(
          color: AppColors.primary,
          width: 1.2,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),

        textStyle: AppTextStyles.buttonSecondary,

        disabledForegroundColor: AppColors.textTertiary,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withValues(
                alpha: 0.10,
              );
            }

            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withValues(
                alpha: 0.05,
              );
            }

            return null;
          },
        ),
      ),
    ),

    // ============================================================
    // Text Button
    // ============================================================

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.primaryDark,
        foregroundColor: AppColors.primary,

        minimumSize: const Size(
          0,
          44,
        ),

        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),

        textStyle: AppTextStyles.buttonSecondary,

        disabledForegroundColor: AppColors.textTertiary,
      ).copyWith(
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
          (states) {
            if (states.contains(WidgetState.pressed)) {
              return AppColors.primary.withValues(
                alpha: 0.10,
              );
            }

            if (states.contains(WidgetState.hovered)) {
              return AppColors.primary.withValues(
                alpha: 0.05,
              );
            }

            return null;
          },
        ),
      ),
    ),

    // ============================================================
    // Input / TextField
    // ============================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,

      fillColor: AppColors.surface,

      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      labelStyle: AppTextStyles.label,

      hintStyle: AppTextStyles.bodySmall,

      floatingLabelStyle: AppTextStyles.label.copyWith(
        color: AppColors.primary,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(
          color: AppColors.border,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(
          color: AppColors.primary,
          width: 1.5,
        ),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(
          color: AppColors.error,
        ),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),

      errorStyle: AppTextStyles.error,
    ),

    // ============================================================
    // Card
    // ============================================================

    cardTheme: CardThemeData(
      color: AppColors.card,

      elevation: 0,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),

        side: const BorderSide(
          color: AppColors.borderLight,
        ),
      ),

      clipBehavior: Clip.antiAlias,
    ),

    // ============================================================
    // Divider
    // ============================================================

    dividerTheme: const DividerThemeData(
      color: AppColors.divider,
      thickness: 1,
      space: 1,
    ),

    // ============================================================
    // Checkbox
    // ============================================================

    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),

      side: const BorderSide(
        color: AppColors.border,
        width: 1.5,
      ),

      fillColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.surface;
        },
      ),

      checkColor: WidgetStateProperty.all(
        AppColors.textOnPrimary,
      ),
    ),

    // ============================================================
    // Switch
    // ============================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.textOnPrimary;
          }

          return AppColors.textTertiary;
        },
      ),

      trackColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.primary;
          }

          return AppColors.border;
        },
      ),
    ),

    // ============================================================
    // Chip
    // ============================================================

    chipTheme: ChipThemeData(
      backgroundColor: AppColors.surfaceVariant,

      selectedColor: AppColors.primarySurface,

      labelStyle: AppTextStyles.label,

      secondaryLabelStyle: AppTextStyles.bodySmall,

      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),

      side: const BorderSide(
        color: AppColors.borderLight,
      ),
    ),

    // ============================================================
    // Floating Action Button
    // ============================================================

    floatingActionButtonTheme:
        const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,

      foregroundColor: AppColors.textOnPrimary,

      elevation: 2,
    ),

    // ============================================================
    // SnackBar
    // ============================================================

    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.textPrimary,

      contentTextStyle: AppTextStyles.body.copyWith(
        color: AppColors.textOnDark,
      ),

      actionTextColor: AppColors.primaryLight,

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),

      elevation: 4,
    ),

    // ============================================================
    // Dialog
    // ============================================================

    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surface,

      elevation: 8,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),

      titleTextStyle: AppTextStyles.h3,

      contentTextStyle: AppTextStyles.body,
    ),

    // ============================================================
    // Progress Indicator
    // ============================================================

    progressIndicatorTheme:
        const ProgressIndicatorThemeData(
      color: AppColors.primary,

      linearTrackColor: AppColors.primarySurface,
    ),

    // ============================================================
    // Bottom Navigation Bar
    // ============================================================

    bottomNavigationBarTheme:
        const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,

      selectedItemColor: AppColors.primary,

      unselectedItemColor: AppColors.textTertiary,

      type: BottomNavigationBarType.fixed,

      elevation: 8,
    ),

    // ============================================================
    // Icon
    // ============================================================

    iconTheme: const IconThemeData(
      color: AppColors.textSecondary,

      size: 24,
    ),
  );
}