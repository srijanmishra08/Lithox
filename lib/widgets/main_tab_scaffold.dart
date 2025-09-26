import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../screens/home_screen.dart';
import '../screens/booking/booking_form_screen.dart';
import '../screens/orders_screen.dart';
import '../providers/tab_navigation_provider.dart';
import '../utils/app_constants.dart';

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
    return IntrinsicHeight(
      child: Container(
        constraints: const BoxConstraints(
          minHeight: 60,
          maxHeight: 80,
        ),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              AppConstants.cardSurface,
              AppConstants.surfaceLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: AppConstants.shadowColor.withValues(alpha: 0.08),
              blurRadius: 32,
              offset: const Offset(0, -8),
            ),
            BoxShadow(
              color: AppConstants.primaryPurple.withValues(alpha: 0.05),
              blurRadius: 16,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Home',
                index: 0,
                currentIndex: currentIndex,
                theme: theme,
                onTap: () => ref.read(tabNavigationProvider.notifier).switchToTab(0),
              ),
              _buildNavItem(
                icon: Icons.calendar_today_outlined,
                activeIcon: Icons.calendar_today,
                label: 'Book',
                index: 1,
                currentIndex: currentIndex,
                theme: theme,
                onTap: () => ref.read(tabNavigationProvider.notifier).switchToTab(1),
              ),
              _buildNavItem(
                icon: Icons.receipt_long_outlined,
                activeIcon: Icons.receipt_long,
                label: 'Orders',
                index: 2,
                currentIndex: currentIndex,
                theme: theme,
                onTap: () => ref.read(tabNavigationProvider.notifier).switchToTab(2),
              ),
            ],
          ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required ThemeData theme,
    required VoidCallback onTap,
  }) {
    final isSelected = index == currentIndex;
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: 12.0,
          vertical: 8.0,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: [
                    AppConstants.primaryPurple.withValues(alpha: 0.15),
                    AppConstants.primaryPurple.withValues(alpha: 0.08),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          borderRadius: BorderRadius.circular(AppConstants.radiusRounded),
          border: isSelected
              ? Border.all(
                  color: AppConstants.primaryPurple.withValues(alpha: 0.2),
                  width: 1,
                )
              : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryPurple.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: Icon(
                isSelected ? activeIcon : icon,
                key: ValueKey(isSelected),
                color: isSelected 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
            ),
            const SizedBox(height: 2),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: theme.textTheme.bodySmall!.copyWith(
                color: isSelected 
                  ? theme.colorScheme.primary 
                  : theme.colorScheme.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
