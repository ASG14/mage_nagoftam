// lib/core/themes/theme.dart

import 'package:flutter/material.dart';
import 'color.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    // رنگ‌های اصلی
    primaryColor: AppColors.primary,
    primarySwatch: Colors.blue, // باید با primaryColor هماهنگ باشد
    scaffoldBackgroundColor: AppColors.background,
    cardColor: AppColors.surface,
    
    // استایل AppBar
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.appBarBackground,
      foregroundColor: AppColors.appBarTitle,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: AppColors.appBarTitle,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        
      ),
    ),
    
    // استایل دکمه‌ها
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    
    // استایل متنی (اختیاری)
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: AppColors.textPrimary),
      bodyMedium: TextStyle(color: AppColors.textSecondary),
    ),
  );
}