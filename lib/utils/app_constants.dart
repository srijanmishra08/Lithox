import 'package:flutter/material.dart';

/// App-wide constants for Lithox Epoxy App
class AppConstants {
  // Enhanced Color Palette
  static const Color primaryPurple = Color(0xFF341B87);
  static const Color primaryPurpleDark = Color(0xFF2A1470);
  static const Color primaryPurpleLight = Color(0xFF4A26A1);
  static const Color accentOrange = Color(0xFFFF6B35);
  static const Color accentTeal = Color(0xFF4ECDC4);
  static const Color surfaceLight = Color(0xFFFAFBFF);
  static const Color cardSurface = Color(0xFFFFFFFF);
  static const Color shadowColor = Color(0xFF000000);
  
  // Gradient Colors
  static const List<Color> primaryGradient = [
    primaryPurple,
    primaryPurpleLight,
  ];
  
  static const List<Color> heroGradient = [
    primaryPurple,
    Color(0xFF4527A0),
    Color(0xFF5E35B1),
  ];
  
  static const List<Color> cardGradient = [
    Color(0xFFF8F9FF),
    Color(0xFFEEF0FF),
  ];
  
  static const List<Color> shimmerGradient = [
    Color(0xFFE3F2FD),
    Color(0xFFBBDEFB),
    Color(0xFFE3F2FD),
  ];
  
  // Text Scaling Limits for Android optimization
  static const double minTextScaleFactor = 0.8;
  static const double maxTextScaleFactor = 1.3;
  
  // Image Optimization Settings
  static const double maxImageWidth = 1920;
  static const double maxImageHeight = 1080;
  static const int imageQuality = 85;
  static const double maxImageSizeInMB = 10;
  static const int maxImagesPerForm = 5;
  
  // Animation Durations
  static const Duration standardAnimationDuration = Duration(milliseconds: 300);
  static const Duration fastAnimationDuration = Duration(milliseconds: 150);
  static const Duration slowAnimationDuration = Duration(milliseconds: 500);
  static const Duration microAnimationDuration = Duration(milliseconds: 100);
  
  // Spacing System
  static const double spacing4 = 4.0;
  static const double spacing8 = 8.0;
  static const double spacing12 = 12.0;
  static const double spacing16 = 16.0;
  static const double spacing20 = 20.0;
  static const double spacing24 = 24.0;
  static const double spacing32 = 32.0;
  static const double spacing40 = 40.0;
  static const double spacing48 = 48.0;
  
  // Legacy spacing (for backward compatibility)
  static const double standardPadding = 20.0;
  static const double smallPadding = 12.0;
  static const double largePadding = 32.0;
  
  // Border Radius System
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 20.0;
  static const double radiusRounded = 24.0;
  static const double radiusCircular = 50.0;
  
  // Legacy radius (for backward compatibility)
  static const double standardBorderRadius = 12.0;
  static const double largeBorderRadius = 24.0;
  
  // Shadow System
  static const List<BoxShadow> shadowSmall = [
    BoxShadow(
      color: Color(0x1F000000),
      blurRadius: 4,
      offset: Offset(0, 2),
    ),
  ];
  
  static const List<BoxShadow> shadowMedium = [
    BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 8,
      offset: Offset(0, 4),
    ),
  ];
  
  static const List<BoxShadow> shadowLarge = [
    BoxShadow(
      color: Color(0x17000000),
      blurRadius: 16,
      offset: Offset(0, 8),
    ),
  ];
  
  static const List<BoxShadow> shadowGlow = [
    BoxShadow(
      color: Color(0x33341B87),
      blurRadius: 20,
      offset: Offset(0, 8),
    ),
  ];
  
  // Typography Scale
  static const double fontSizeCaption = 12.0;
  static const double fontSizeBody = 14.0;
  static const double fontSizeBodyLarge = 16.0;
  static const double fontSizeHeadline = 18.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeTitleLarge = 24.0;
  static const double fontSizeDisplay = 32.0;
  
  // Contact Information
  static const String businessPhone = '+919057263521';
  static const String businessEmail = 'srijanmishram@gmail.com';
  static const String companyName = 'Lithox Epoxy';
  
  // Private constructor to prevent instantiation
  AppConstants._();
}
