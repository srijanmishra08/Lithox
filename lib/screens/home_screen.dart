import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final currentUserAsync = ref.watch(currentUserProvider);
    
    return authState.when(
      data: (user) {
        if (user == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/login');
          });
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        
        return currentUserAsync.when(
          data: (currentUser) => _buildHomeContent(context, ref, currentUser),
          loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
          error: (error, stack) => Scaffold(
            body: Center(child: Text('Error: $error')),
          ),
        );
      },
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context, WidgetRef ref, currentUser) {
    final theme = Theme.of(context);
    
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context, ref, currentUser, theme),
              const SizedBox(height: 24),
              
              // Hero Section
              _buildHeroSection(context, theme),
              const SizedBox(height: 24),
              
              // Quick Stats
              _buildQuickStats(theme),
              const SizedBox(height: 24),
              
              // Quick Actions
              _buildQuickActions(context, theme),
              const SizedBox(height: 24),
              
              // Recent Orders
              _buildRecentOrders(context, ref, currentUser, theme),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(context, 0),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref, currentUser, ThemeData theme) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: theme.colorScheme.primaryContainer,
          child: Text(
            currentUser?.name?.substring(0, 1).toUpperCase() ?? 'U',
            style: TextStyle(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, ${currentUser?.name ?? 'User'}!',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                'Welcome to Lithox',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          onPressed: () {
            // TODO: Implement notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Notifications coming soon')),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
        ),
        PopupMenuButton(
          itemBuilder: (context) => [
            PopupMenuItem(
              onTap: () => context.go('/profile'),
              child: const Row(
                children: [
                  Icon(Icons.person_outline),
                  SizedBox(width: 8),
                  Text('Profile'),
                ],
              ),
            ),
            PopupMenuItem(
              onTap: () async {
                await ref.read(authServiceProvider).signOut();
                if (context.mounted) {
                  context.go('/login');
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.logout),
                  SizedBox(width: 8),
                  Text('Sign Out'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeroSection(BuildContext context, ThemeData theme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            theme.colorScheme.primary,
            theme.colorScheme.primary.withOpacity(0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.layers,
            size: 48,
            color: theme.colorScheme.onPrimary,
          ),
          const SizedBox(height: 16),
          Text(
            'Book Flooring Service',
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Premium epoxy flooring solutions for your space',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onPrimary.withOpacity(0.9),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => context.go('/services'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.colorScheme.onPrimary,
              foregroundColor: theme.colorScheme.primary,
            ),
            child: const Text('View Services'),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outline.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Since',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '1995',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            height: 40,
            width: 1,
            color: theme.colorScheme.outline.withOpacity(0.3),
          ),
          Column(
            children: [
              Text(
                'Quality',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                'Premium',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                theme,
                icon: Icons.phone,
                title: 'Expert Call',
                subtitle: 'Get instant help',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling expert... Feature coming soon')),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildActionCard(
                context,
                theme,
                icon: Icons.chat,
                title: 'WhatsApp',
                subtitle: 'Chat with us',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening WhatsApp... Feature coming soon')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outline.withOpacity(0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(BuildContext context, WidgetRef ref, currentUser, ThemeData theme) {
    if (currentUser == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                // TODO: Navigate to orders screen
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Full orders view coming soon')),
                );
              },
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Consumer(
          builder: (context, ref, child) {
            final ordersAsync = ref.watch(userOrdersProvider(currentUser.uid));
            
            return ordersAsync.when(
              data: (orders) {
                if (orders.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(24),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.colorScheme.outline.withOpacity(0.2),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 48,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No orders yet',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          'Your orders will appear here',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: orders.take(3).length,
                  separatorBuilder: (context, index) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: theme.colorScheme.primaryContainer,
                        child: Text(
                          order.orderId.substring(order.orderId.length - 2),
                          style: TextStyle(
                            color: theme.colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      title: Text('Order ${order.orderId}'),
                      subtitle: Text(order.statusDisplayName),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      onTap: () => context.go('/tracking/${order.orderId}'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error loading orders: $error'),
            );
          },
        ),
      ],
    );
  }

  Widget _buildBottomNavigation(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: (index) {
        switch (index) {
          case 0:
            context.go('/home');
            break;
          case 1:
            context.go('/services');
            break;
          case 2:
            // TODO: Navigate to orders
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Orders page coming soon')),
            );
            break;
          case 3:
            context.go('/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.design_services_outlined),
          activeIcon: Icon(Icons.design_services),
          label: 'Services',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined),
          activeIcon: Icon(Icons.receipt_long),
          label: 'Orders',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
