import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'screens/auth/auth_login_screen.dart';
import 'screens/auth/auth_register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/services/services_screen.dart';
import 'screens/booking/booking_form_screen.dart';
import 'screens/booking/order_confirmation_screen.dart';
import 'screens/tracking/tracking_screen.dart';
import 'screens/profile/profile_screen.dart';
import 'services/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load environment variables
  await dotenv.load(fileName: ".env");
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  runApp(const ProviderScope(child: LithoxApp()));
}

class LithoxApp extends ConsumerWidget {
  const LithoxApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return MaterialApp.router(
      title: 'Lithox Epoxy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF341B87), // Primary Purple
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      routerConfig: _router,
    );
  }
}

final _router = GoRouter(
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const AuthLoginScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const AuthRegisterScreen(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const ServicesScreen(),
    ),
    GoRoute(
      path: '/booking',
      builder: (context, state) {
        final serviceId = state.uri.queryParameters['serviceId'];
        return BookingFormScreen(preSelectedServiceId: serviceId);
      },
    ),
    GoRoute(
      path: '/confirmation/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return OrderConfirmationScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/tracking/:orderId',
      builder: (context, state) {
        final orderId = state.pathParameters['orderId']!;
        return TrackingScreen(orderId: orderId);
      },
    ),
    GoRoute(
      path: '/profile',
      builder: (context, state) => const ProfileScreen(),
    ),
  ],
);
