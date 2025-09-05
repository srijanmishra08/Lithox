import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/order.dart';
import '../models/service.dart';
import '../models/user.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Orders Collection
  CollectionReference get ordersCollection => _firestore.collection('orders');
  
  // Services Collection
  CollectionReference get servicesCollection => _firestore.collection('services');
  
  // Users Collection
  CollectionReference get usersCollection => _firestore.collection('users');

  // Create a new order
  Future<void> createOrder(Order order) async {
    try {
      await ordersCollection.doc(order.orderId).set(order.toJson());
    } catch (e) {
      throw Exception('Failed to create order: ${e.toString()}');
    }
  }

  // Get order by ID
  Future<Order?> getOrder(String orderId) async {
    try {
      final doc = await ordersCollection.doc(orderId).get();
      if (!doc.exists) return null;
      
      return Order.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get order: ${e.toString()}');
    }
  }

  // Get orders for a user
  Stream<List<Order>> getUserOrders(String userId) {
    return ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromJson(doc.data() as Map<String, dynamic>))
            .toList());
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await ordersCollection.doc(orderId).update({
        'status': status.name.toUpperCase(),
        'updatedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Failed to update order status: ${e.toString()}');
    }
  }

  // Listen to order changes
  Stream<Order?> watchOrder(String orderId) {
    return ordersCollection
        .doc(orderId)
        .snapshots()
        .map((snapshot) {
          if (!snapshot.exists) return null;
          return Order.fromJson(snapshot.data() as Map<String, dynamic>);
        });
  }

  // Get all services
  Future<List<Service>> getServices() async {
    try {
      final snapshot = await servicesCollection.get();
      return snapshot.docs
          .map((doc) => Service.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get services: ${e.toString()}');
    }
  }

  // Get service by ID
  Future<Service?> getService(String serviceId) async {
    try {
      final doc = await servicesCollection.doc(serviceId).get();
      if (!doc.exists) return null;
      
      return Service.fromJson(doc.data() as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Failed to get service: ${e.toString()}');
    }
  }

  // Create or update service (Admin function)
  Future<void> createOrUpdateService(Service service) async {
    try {
      await servicesCollection.doc(service.id).set(service.toJson());
    } catch (e) {
      throw Exception('Failed to create/update service: ${e.toString()}');
    }
  }

  // Seed initial services data
  Future<void> seedServicesData() async {
    try {
      final services = [
        Service(
          id: 'uv_epoxy',
          title: 'UV Epoxy Floor Coating',
          subtitle: 'Post-marble fixing',
          description: 'High gloss UV epoxy suitable after marble fixing. Provides excellent durability and shine.',
          pricePerSqFt: 65.0,
          features: [
            'High gloss finish',
            'UV resistant',
            'Post marble installation',
            'Easy maintenance',
            'Long lasting'
          ],
          process: '1. Surface preparation\n2. Primer application\n3. UV epoxy coating\n4. Curing process',
        ),
        Service(
          id: 'epoxy_standard',
          title: 'Epoxy Flooring',
          subtitle: 'Primer + Base + Top coat',
          description: 'Complete epoxy flooring solution available in all colours. Includes primer, base coat, and top coat.',
          pricePerSqFt: 55.0,
          features: [
            'All colors available',
            'Three-layer system',
            'Chemical resistant',
            'Easy to clean',
            'Professional finish'
          ],
          process: '1. Surface cleaning\n2. Primer application\n3. Base coat application\n4. Top coat finish\n5. Curing',
        ),
      ];

      for (final service in services) {
        await createOrUpdateService(service);
      }
    } catch (e) {
      throw Exception('Failed to seed services data: ${e.toString()}');
    }
  }

  // Update user profile
  Future<void> updateUserProfile(User user) async {
    try {
      await usersCollection.doc(user.uid).update(user.toJson());
    } catch (e) {
      throw Exception('Failed to update user profile: ${e.toString()}');
    }
  }
}

// Provider
final firestoreServiceProvider = Provider<FirestoreService>((ref) => FirestoreService());

// Services stream provider
final servicesProvider = FutureProvider<List<Service>>((ref) {
  return ref.read(firestoreServiceProvider).getServices();
});

// User orders stream provider
final userOrdersProvider = StreamProvider.family<List<Order>, String>((ref, userId) {
  return ref.read(firestoreServiceProvider).getUserOrders(userId);
});

// Single order stream provider
final orderProvider = StreamProvider.family<Order?, String>((ref, orderId) {
  return ref.read(firestoreServiceProvider).watchOrder(orderId);
});
