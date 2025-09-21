import 'package:flutter/material.dart';

/// App-wide constants for Lithox Epoxy App
class AppConstants {
  // Colors
  static const Color primaryPurple = Color(0xFF341B87);
  
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
  
  // Spacing
  static const double standardPadding = 20.0;
  static const double smallPadding = 12.0;
  static const double largePadding = 32.0;
  
  // Border Radius
  static const double standardBorderRadius = 12.0;
  static const double largeBorderRadius = 24.0;
  
  // Contact Information
  static const String businessPhone = '+919057263521';
  static const String businessEmail = 'srijanmishram@gmail.com';
  static const String companyName = 'Lithox Epoxy';
  
  // Private constructor to prevent instantiation
  AppConstants._();
}
