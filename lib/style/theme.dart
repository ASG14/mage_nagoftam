import 'package:flutter/material.dart';

import 'color.dart';
import 'typography.dart';

abstract final class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,

    // ============================================================
    // General
    // ============================================================
    scaffoldBackgroundColor: AppColors.white1,

    // ============================================================
    // Text Theme
    // ============================================================
    textTheme: TextTheme(
      displayLarge: AppTypography.h1.copyWith(color: AppColors.gray1),

      displayMedium: AppTypography.h2.copyWith(color: AppColors.gray1),

      displaySmall: AppTypography.h3.copyWith(color: AppColors.gray1),

      headlineLarge: AppTypography.h2.copyWith(color: AppColors.gray1),

      headlineMedium: AppTypography.h3.copyWith(color: AppColors.gray1),

      headlineSmall: AppTypography.h4.copyWith(color: AppColors.gray1),

      titleLarge: AppTypography.h4.copyWith(color: AppColors.gray1),

      titleMedium: AppTypography.h5.copyWith(color: AppColors.gray1),

      titleSmall: AppTypography.h6.copyWith(color: AppColors.gray1),

      bodyLarge: AppTypography.h7.copyWith(color: AppColors.gray1),

      bodyMedium: AppTypography.h8.copyWith(color: AppColors.gray2),

      bodySmall: AppTypography.h9.copyWith(color: AppColors.gray2),

      labelLarge: AppTypography.h7.copyWith(color: AppColors.gray1),

      labelMedium: AppTypography.h9.copyWith(color: AppColors.gray2),

      labelSmall: AppTypography.h10.copyWith(color: AppColors.gray2),
    ),

    // ============================================================
    // AppBar
    // ============================================================
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white2,
      foregroundColor: AppColors.gray1,
      elevation: 0,
      scrolledUnderElevation: 0,
      //centerTitle: true,

      titleTextStyle: AppTypography.h5.copyWith(color: AppColors.gray1),

      iconTheme: const IconThemeData(color: AppColors.gray1, size: 24),
    ),

    // ============================================================
    // Filled Button
    // ============================================================
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.green2,
        foregroundColor: AppColors.white2,

        minimumSize: const Size(double.infinity, 48),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        elevation: 0,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        textStyle: AppTypography.h7.copyWith(color: AppColors.white2),
      ),
    ),

    // ============================================================
    // Outlined Button
    // ============================================================
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: AppColors.white2,
        foregroundColor: AppColors.green2,

        minimumSize: const Size(double.infinity, 48),

        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),

        side: const BorderSide(color: AppColors.green2, width: 1),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        textStyle: AppTypography.h7.copyWith(color: AppColors.green2),
      ),
    ),

    // ============================================================
    // Text Button
    // ============================================================
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        backgroundColor: AppColors.green2,
        foregroundColor: AppColors.white2,

        minimumSize: const Size(double.infinity, 48),

        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

        textStyle: AppTypography.h8.copyWith(color: AppColors.green2),
      ),
    ),

    // ============================================================
    // Text Field
    // ============================================================
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.white2,

      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),

      hintStyle: AppTypography.h8.copyWith(color: AppColors.gray2),

      labelStyle: AppTypography.h8.copyWith(color: AppColors.gray2),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(color: AppColors.gray4),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(color: AppColors.green2, width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(color: AppColors.red1),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(5),

        borderSide: const BorderSide(color: AppColors.red1, width: 1.5),
      ),

      errorStyle: AppTypography.h9.copyWith(color: AppColors.red1),
    ),

    // ============================================================
    // Card
    // ============================================================
    cardTheme: CardThemeData(
      color: AppColors.white2,
      elevation: 0,

      margin: EdgeInsets.zero,

      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),

        side: const BorderSide(color: AppColors.gray4),
      ),
    ),

    // ============================================================
    // Divider
    // ============================================================
    dividerTheme: const DividerThemeData(
      color: AppColors.gray4,
      thickness: 1,
      space: 1,
    ),

    // ============================================================
    // Navigation Bar
    // ============================================================
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white2,
      indicatorColor: AppColors.gray4,
    ),

    // ============================================================
    // Bottom Navigation Bar
    // ============================================================
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.white2,

      unselectedIconTheme: IconThemeData(color: AppColors.gray2),
      selectedIconTheme: IconThemeData(color: AppColors.green1),

      selectedItemColor: AppColors.green2,
      unselectedItemColor: AppColors.gray2,

      selectedLabelStyle: AppTypography.h10.copyWith(color: AppColors.green2),

      unselectedLabelStyle: AppTypography.h10.copyWith(color: AppColors.gray2),

      type: BottomNavigationBarType.fixed,

      elevation: 8,
    ),

    // ============================================================
    // Floating Action Button
    // ============================================================
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.green2,
      foregroundColor: AppColors.white2,
      elevation: 2,
    ),

    // ============================================================
    // Checkbox
    // ============================================================
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),

      side: const BorderSide(color: AppColors.gray3),

      fillColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.green2;
        }

        return AppColors.white2;
      }),

      checkColor: WidgetStateProperty.all(AppColors.white2),
    ),

    // ============================================================
    // Switch
    // ============================================================
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.white2;
        }

        return AppColors.gray3;
      }),

      trackColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.green3;
        }

        return AppColors.gray4;
      }),
    ),

    // ============================================================
    // Progress Indicator
    // ============================================================
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: AppColors.green2,
      linearTrackColor: AppColors.gray4,
    ),

    // ============================================================
    // SnackBar
    // ============================================================
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.gray1,

      contentTextStyle: AppTypography.h8.copyWith(color: AppColors.white2),

      actionTextColor: AppColors.green3,

      behavior: SnackBarBehavior.floating,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
    ),

    // ============================================================
    // Dialog
    // ============================================================
    dialogTheme: DialogThemeData(
      alignment: Alignment.center,
      backgroundColor: AppColors.white2,
      elevation: 8,

      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),

      titleTextStyle: AppTypography.h4.copyWith(color: AppColors.gray1),

      contentTextStyle: AppTypography.h8.copyWith(color: AppColors.gray2),
      
    ),

    // ============================================================
    // Icons
    // ============================================================
    iconTheme: const IconThemeData(color: AppColors.gray2, size: 24),
  );
}
