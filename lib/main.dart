import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'widgets/main_tab_scaffold.dart';
import 'screens/booking/booking_form_screen.dart';
import 'screens/about_us_screen.dart';
import 'utils/app_constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database factory for proper SQLite support
  await _initializeDatabase();
  
  // Android-specific optimizations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // Optimize system UI for Android
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(const ProviderScope(child: LithoxApp()));
}

/// Initialize database factory for SQLite support
Future<void> _initializeDatabase() async {
  try {
    // Only initialize FFI for desktop platforms (not mobile)
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      // Initialize sqflite_common_ffi for desktop platforms only
      sqfliteFfiInit();
      
      // Set the database factory for desktop platforms
      databaseFactory = databaseFactoryFfi;
    }
    // For Android/iOS, use the default sqflite database factory
    // For web, use web storage
    
  } catch (e) {
    // If FFI initialization fails, ensure we have a fallback
    // This should not happen but provides a safety net
    debugPrint('Database initialization warning: $e');
  }
}

class LithoxApp extends ConsumerWidget {
  const LithoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'Lithox Epoxy',
      debugShowCheckedModeBanner: false, // Remove debug banner for production
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppConstants.primaryPurple,
          brightness: Brightness.light,
          primary: AppConstants.primaryPurple,
          secondary: AppConstants.accentTeal,
          tertiary: AppConstants.accentOrange,
          surface: AppConstants.surfaceLight,
          surfaceContainerHighest: AppConstants.cardSurface,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        
        // Enhanced Material 3 styling
        splashFactory: InkSparkle.splashFactory,
        highlightColor: Colors.transparent,
        splashColor: AppConstants.primaryPurple.withValues(alpha: 0.08),
        
        // Card theme
        cardTheme: CardThemeData(
          elevation: 0,
          shadowColor: AppConstants.shadowColor.withValues(alpha: 0.1),
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusLarge),
          ),
        ),
        
        // Input decoration theme
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppConstants.surfaceLight,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: const BorderSide(color: AppConstants.primaryPurple, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacing16,
            vertical: AppConstants.spacing16,
          ),
        ),
        
        // Elevated button theme
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing24,
              vertical: AppConstants.spacing16,
            ),
          ),
        ),
        
        // Text button theme
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppConstants.radiusMedium),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacing20,
              vertical: AppConstants.spacing12,
            ),
          ),
        ),
        
        // App bar theme
        appBarTheme: const AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: TextStyle(
            color: AppConstants.primaryPurple,
            fontSize: AppConstants.fontSizeTitleLarge,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      routerConfig: _router,
      // Performance optimizations
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(
              MediaQuery.of(context).textScaler.scale(1.0).clamp(0.8, 1.2),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const MainTabScaffold(),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) => const BookingFormScreen(),
    ),
    GoRoute(
      path: '/about',
      builder: (context, state) => const AboutUsScreen(),
    ),
  ],
);
