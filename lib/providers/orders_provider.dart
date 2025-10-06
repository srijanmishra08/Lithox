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

