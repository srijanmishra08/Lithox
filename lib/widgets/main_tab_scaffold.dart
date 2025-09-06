import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/home_screen.dart';
import '../screens/booking/booking_form_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/tab_navigation_provider.dart';

class MainTabScaffold extends ConsumerWidget {
  const MainTabScaffold({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(tabNavigationProvider);
    final theme = Theme.of(context);
    
    const pages = [
      // Keep the exact home widget you already have
      HomeScreen(),
      // Use existing booking screen
      BookingFormScreen(),
      // Orders tracking screen
      OrdersScreen(),
    ];

    // Use IndexedStack to preserve state & scroll position
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _buildBottomNav(theme, currentIndex, ref),
    );
  }

  Widget _buildBottomNav(ThemeData theme, int currentIndex, WidgetRef ref) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) => ref.read(tabNavigationProvider.notifier).switchToTab(index),
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        selectedItemColor: theme.colorScheme.primary,
        unselectedItemColor: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: theme.textTheme.bodySmall,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
            tooltip: 'Home - Company information and services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today),
            label: 'Book',
            tooltip: 'Book - Schedule consultation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: 'Orders',
            tooltip: 'Orders - Track your projects',
          ),
        ],
      ),
    );
  }
}
