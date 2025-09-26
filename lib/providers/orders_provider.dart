import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../services/order_service.dart';

// Provider for all orders
final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

// Provider for a specific order by ID
final orderByIdProvider = Provider.family<Order?, String>((ref, orderId) {
  final orders = ref.watch(ordersProvider);
  try {
    return orders.firstWhere((order) => order.id == orderId);
  } catch (e) {
    return null;
  }
});

// Provider for orders filtered by status
final ordersByStatusProvider = Provider.family<List<Order>, OrderStatus>((ref, status) {
  final orders = ref.watch(ordersProvider);
  return orders.where((order) => order.status == status).toList();
});

// Provider for order statistics
final orderStatsProvider = Provider<OrderStats>((ref) {
  final orders = ref.watch(ordersProvider);
  
  int total = orders.length;
  int completed = orders.where((o) => o.status == OrderStatus.completed).length;
  int inProgress = orders.where((o) => o.status == OrderStatus.inProgress || o.status == OrderStatus.scheduled).length;
  int pending = orders.where((o) => o.status == OrderStatus.submitted || o.status == OrderStatus.reviewed || o.status == OrderStatus.quoted).length;
  
  return OrderStats(
    total: total,
    completed: completed,
    inProgress: inProgress,
    pending: pending,
  );
});

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  void _loadOrders() async {
    // Load user orders from database
    final orders = await OrderService.getUserOrders();
    state = orders;
  }

  // Add a new order
  void addOrder(Order order) {
    state = [...state, order];
  }

  // Update an existing order
  void updateOrder(Order updatedOrder) {
    state = state.map((order) {
      return order.id == updatedOrder.id ? updatedOrder : order;
    }).toList();
  }

  // Create order from booking
  Future<Order> createOrderFromBooking({
    required String customerName,
    required String customerEmail,
    required String customerPhone,
    required String address,
    required String city,
    required String area,
    required String serviceType,
    required String approximateArea,
    required String notes,
    required int photoCount,
  }) async {
    final order = await OrderService.createOrder(
      customerName: customerName,
      customerEmail: customerEmail,
      customerPhone: customerPhone,
      address: address,
      city: city,
      area: area,
      serviceType: serviceType,
      approximateArea: approximateArea,
      notes: notes,
      photoCount: photoCount,
    );
    
    addOrder(order);
    return order;
  }

  // Update order status
  void updateOrderStatus(String orderId, OrderStatus newStatus, {String? notes}) async {
    final success = await OrderService.updateOrderStatus(orderId, newStatus, notes: notes);
    if (success) {
      await refreshOrders();
    }
  }

  // Refresh orders from service
  Future<void> refreshOrders() async {
    final orders = await OrderService.getUserOrders();
    state = orders;
  }

  // Remove mock orders and refresh
  Future<void> removeMockOrders() async {
    await OrderService.removeMockOrders();
    await refreshOrders();
  }

  // Simulate real-time updates (for demo)
  void startRealTimeUpdates() {
    // Simulate periodic updates every 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      refreshOrders();
      startRealTimeUpdates(); // Continue the cycle
    });
  }
}

class OrderStats {
  final int total;
  final int completed;
  final int inProgress;
  final int pending;

  const OrderStats({
    required this.total,
    required this.completed,
    required this.inProgress,
    required this.pending,
  });
}
