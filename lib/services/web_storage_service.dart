import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/order.dart';

/// Web-compatible storage service using SharedPreferences
class WebStorageService {
  static const String _ordersKey = 'lithox_orders';
  
  static Future<void> saveOrders(List<Order> orders) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJson = orders.map((order) => order.toJson()).toList();
      await prefs.setString(_ordersKey, jsonEncode(ordersJson));
    } catch (e) {
      // Error saving orders to web storage: silently handle
    }
  }
  
  static Future<List<Order>> loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ordersJsonString = prefs.getString(_ordersKey);
      
      if (ordersJsonString == null) {
        return [];
      }
      
      final List<dynamic> ordersJson = jsonDecode(ordersJsonString);
      return ordersJson.map((json) => Order.fromJson(json)).toList();
    } catch (e) {
      // Error loading orders from web storage: silently handle
      return [];
    }
  }
  
  static Future<void> clearOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_ordersKey);
    } catch (e) {
      // Error clearing orders from web storage: silently handle
    }
  }
  
  static Future<Order?> getOrderById(String orderId) async {
    final orders = await loadOrders();
    try {
      return orders.firstWhere((order) => order.id == orderId);
    } catch (e) {
      return null;
    }
  }
  
  static Future<void> insertOrder(Order order) async {
    final orders = await loadOrders();
    orders.add(order);
    await saveOrders(orders);
  }
  
  static Future<void> updateOrder(Order updatedOrder) async {
    final orders = await loadOrders();
    final index = orders.indexWhere((order) => order.id == updatedOrder.id);
    if (index != -1) {
      orders[index] = updatedOrder;
      await saveOrders(orders);
    }
  }
  
  static Future<void> deleteOrder(String orderId) async {
    final orders = await loadOrders();
    orders.removeWhere((order) => order.id == orderId);
    await saveOrders(orders);
  }
}