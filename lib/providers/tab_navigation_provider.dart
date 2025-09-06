import 'package:flutter_riverpod/flutter_riverpod.dart';

// Provider for managing tab navigation
final tabNavigationProvider = StateNotifierProvider<TabNavigationNotifier, int>((ref) {
  return TabNavigationNotifier();
});

class TabNavigationNotifier extends StateNotifier<int> {
  TabNavigationNotifier() : super(0);

  void switchToTab(int index) {
    state = index;
  }

  void switchToHome() => switchToTab(0);
  void switchToBook() => switchToTab(1);
  void switchToOrders() => switchToTab(2);
}
