import 'dart:convert';
import 'dart:math';
import '../models/order.dart';

class OrderService {
  static final List<Order> _orders = [];
  static final Random _random = Random();

  // Create a new order from booking submission
  static Order createOrder({
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
  }) {
    final orderId = _generateOrderId();
    final order = Order(
      id: orderId,
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
      createdAt: DateTime.now(),
      status: OrderStatus.submitted,
      updates: [
        OrderUpdate(
          id: _generateUpdateId(),
          timestamp: DateTime.now(),
          status: OrderStatus.submitted,
          message: 'Consultation request submitted successfully',
          notes: 'Your request has been received and will be reviewed within 24 hours.',
        ),
      ],
    );

    _orders.add(order);
    
    // Simulate automatic status updates
    _simulateOrderProgress(orderId);
    
    return order;
  }

  // Get all orders for the current user
  static List<Order> getUserOrders() {
    // In a real app, this would filter by user ID
    return List.from(_orders);
  }

  // Get order by ID
  static Order? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Update order status
  static bool updateOrderStatus(String orderId, OrderStatus newStatus, {String? notes}) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) return false;

    final order = _orders[orderIndex];
    final update = OrderUpdate(
      id: _generateUpdateId(),
      timestamp: DateTime.now(),
      status: newStatus,
      message: newStatus.description,
      notes: notes,
    );

    final updatedOrder = order.copyWith(
      status: newStatus,
      updates: [...order.updates, update],
      scheduledDate: newStatus == OrderStatus.scheduled ? DateTime.now().add(const Duration(days: 3)) : order.scheduledDate,
      completedDate: newStatus == OrderStatus.completed ? DateTime.now() : order.completedDate,
    );

    _orders[orderIndex] = updatedOrder;
    return true;
  }

  // Add cost estimate to order
  static bool addCostEstimate(String orderId, double estimatedCost) {
    final orderIndex = _orders.indexWhere((order) => order.id == orderId);
    if (orderIndex == -1) return false;

    final order = _orders[orderIndex];
    final update = OrderUpdate(
      id: _generateUpdateId(),
      timestamp: DateTime.now(),
      status: OrderStatus.quoted,
      message: 'Cost estimate prepared',
      notes: 'Estimated cost: ₹${estimatedCost.toStringAsFixed(0)}',
    );

    final updatedOrder = order.copyWith(
      status: OrderStatus.quoted,
      estimatedCost: estimatedCost,
      updates: [...order.updates, update],
    );

    _orders[orderIndex] = updatedOrder;
    return true;
  }

  // Generate mock orders for demonstration
  static void generateMockOrders() {
    if (_orders.isNotEmpty) return; // Don't generate if orders already exist

    final mockOrders = [
      Order(
        id: 'LTX-2025-001',
        customerName: 'John Doe',
        customerEmail: 'john@example.com',
        customerPhone: '+91-9876543210',
        address: 'Sector 14, Udaipur',
        city: 'Udaipur',
        area: 'Hiran Magri',
        serviceType: 'Residential Flooring',
        approximateArea: '800 sq ft',
        notes: 'Living room and dining area',
        photoCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
        scheduledDate: DateTime.now().add(const Duration(days: 2)),
        status: OrderStatus.scheduled,
        estimatedCost: 45000,
        updates: [
          OrderUpdate(
            id: 'UPD-001',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            status: OrderStatus.submitted,
            message: 'Consultation request submitted successfully',
          ),
          OrderUpdate(
            id: 'UPD-002',
            timestamp: DateTime.now().subtract(const Duration(days: 4)),
            status: OrderStatus.reviewed,
            message: 'Our team is reviewing your requirements',
          ),
          OrderUpdate(
            id: 'UPD-003',
            timestamp: DateTime.now().subtract(const Duration(days: 2)),
            status: OrderStatus.quoted,
            message: 'Cost estimate prepared',
            notes: 'Estimated cost: ₹45,000',
          ),
          OrderUpdate(
            id: 'UPD-004',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            status: OrderStatus.scheduled,
            message: 'Installation has been scheduled',
            notes: 'Scheduled for ${DateTime.now().add(const Duration(days: 2)).toString().split(' ')[0]}',
          ),
        ],
      ),
      Order(
        id: 'LTX-2025-002',
        customerName: 'Jane Smith',
        customerEmail: 'jane@example.com',
        customerPhone: '+91-9876543211',
        address: 'City Palace Road, Udaipur',
        city: 'Udaipur',
        area: 'City Palace Area',
        serviceType: 'Commercial Flooring',
        approximateArea: '1200 sq ft',
        notes: 'Office space renovation',
        photoCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
        completedDate: DateTime.now().subtract(const Duration(days: 1)),
        status: OrderStatus.completed,
        estimatedCost: 85000,
        finalCost: 82000,
        updates: [
          OrderUpdate(
            id: 'UPD-005',
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            status: OrderStatus.submitted,
            message: 'Consultation request submitted successfully',
          ),
          OrderUpdate(
            id: 'UPD-006',
            timestamp: DateTime.now().subtract(const Duration(days: 9)),
            status: OrderStatus.reviewed,
            message: 'Our team is reviewing your requirements',
          ),
          OrderUpdate(
            id: 'UPD-007',
            timestamp: DateTime.now().subtract(const Duration(days: 7)),
            status: OrderStatus.quoted,
            message: 'Cost estimate prepared',
            notes: 'Estimated cost: ₹85,000',
          ),
          OrderUpdate(
            id: 'UPD-008',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            status: OrderStatus.scheduled,
            message: 'Installation has been scheduled',
          ),
          OrderUpdate(
            id: 'UPD-009',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            status: OrderStatus.inProgress,
            message: 'Work is currently in progress',
          ),
          OrderUpdate(
            id: 'UPD-010',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
            status: OrderStatus.completed,
            message: 'Project has been completed successfully',
            notes: 'Final cost: ₹82,000',
          ),
        ],
      ),
    ];

    _orders.addAll(mockOrders);
  }

  // Simulate order progress for demo purposes
  static void _simulateOrderProgress(String orderId) {
    // Simulate review after 10 seconds
    Future.delayed(const Duration(seconds: 10), () {
      updateOrderStatus(orderId, OrderStatus.reviewed, 
        notes: 'Our expert team has reviewed your requirements.');
    });

    // Simulate quote after 30 seconds
    Future.delayed(const Duration(seconds: 30), () {
      final cost = _random.nextDouble() * 50000 + 20000; // Random cost between 20k-70k
      addCostEstimate(orderId, cost);
    });
  }

  // Helper methods
  static String _generateOrderId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(999);
    return 'LTX-${DateTime.now().year}-${random.toString().padLeft(3, '0')}';
  }

  static String _generateUpdateId() {
    return 'UPD-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Clear all orders (for testing)
  static void clearOrders() {
    _orders.clear();
  }
}
