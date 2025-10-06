import 'dart:math';
import '../models/order.dart';
import 'database_service.dart';

class OrderService {
  static final Random _random = Random();

  // Create a new order from booking submission
  static Future<Order> createOrder({
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
      updates: [
        OrderUpdate(
          id: _generateUpdateId(),
          timestamp: DateTime.now(),
          message: 'Consultation request submitted successfully',
          notes: 'Your request has been received and will be reviewed within 24 hours.',
        ),
      ],
    );

    // Save to database
    await DatabaseService.insertOrder(order);
    
    // Simulate automatic status updates
    _simulateOrderProgress(orderId);
    
    return order;
  }

  // Get all orders for the current user
  static Future<List<Order>> getUserOrders() async {
    return await DatabaseService.getAllOrders();
  }

  // Get order by ID
  static Future<Order?> getOrderById(String orderId) async {
    return await DatabaseService.getOrderById(orderId);
  }


  // Add order note (replaces cost estimate functionality)
  static Future<bool> addOrderNote(String orderId, String note) async {
    final order = await DatabaseService.getOrderById(orderId);
    if (order == null) return false;

    final update = OrderUpdate(
      id: _generateUpdateId(),
      timestamp: DateTime.now(),
      message: 'Order note added',
      notes: note,
    );

    final updatedOrder = order.copyWith(
      updates: [...order.updates, update],
    );

    await DatabaseService.updateOrder(updatedOrder);
    return true;
  }

  // Generate mock orders for demonstration
  static Future<void> generateMockOrders({bool forceGenerate = false}) async {
    final existingOrders = await DatabaseService.getAllOrders();
    if (existingOrders.isNotEmpty && !forceGenerate) return; // Don't generate if orders already exist unless forced

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
        updates: [
          OrderUpdate(
            id: 'UPD-001',
            timestamp: DateTime.now().subtract(const Duration(days: 5)),
            message: 'Consultation request received',
          ),
          OrderUpdate(
            id: 'UPD-002',
            timestamp: DateTime.now().subtract(const Duration(days: 1)),
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
        updates: [
          OrderUpdate(
            id: 'UPD-005',
            timestamp: DateTime.now().subtract(const Duration(days: 10)),
            message: 'Consultation request received',
          ),
          OrderUpdate(
            id: 'UPD-006',
            timestamp: DateTime.now().subtract(const Duration(days: 3)),
            message: 'Work is currently in progress',
          ),
        ],
      ),
    ];

    // Save mock orders to database
    for (final order in mockOrders) {
      await DatabaseService.insertOrder(order);
    }
  }

  // Simulate order progress for demo purposes
  static void _simulateOrderProgress(String orderId) {
    // Simulate status update after 10 seconds
    Future.delayed(const Duration(seconds: 10), () async {
      await addOrderNote(orderId, 'Our expert team has reviewed your requirements and will contact you soon.');
    });
  }

  // Helper methods
  static String _generateOrderId() {
    final random = _random.nextInt(999);
    return 'LTX-${DateTime.now().year}-${random.toString().padLeft(3, '0')}';
  }

  static String _generateUpdateId() {
    return 'UPD-${DateTime.now().millisecondsSinceEpoch}';
  }

  // Clear all orders (for testing)
  static Future<void> clearOrders() async {
    await DatabaseService.clearAllOrders();
  }

  // Remove mock orders only
  static Future<void> removeMockOrders() async {
    // Delete the specific mock orders by their IDs
    const mockOrderIds = ['LTX-2025-001', 'LTX-2025-002'];
    
    for (final orderId in mockOrderIds) {
      await DatabaseService.deleteOrder(orderId);
    }
  }
}
