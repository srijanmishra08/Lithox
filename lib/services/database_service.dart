import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path/path.dart';
import '../models/order.dart';
import 'web_storage_service.dart';

class DatabaseService {
  static Database? _database;
  static const String _databaseName = 'lithox_orders.db';
  static const int _databaseVersion = 1;
  
  // Table names
  static const String _ordersTable = 'orders';
  static const String _orderUpdatesTable = 'order_updates';

  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  static Future<Database> _initDatabase() async {
    // For web platform, we'll use in-memory storage or fallback
    if (kIsWeb) {
      // For web, we'll use a simple in-memory database
      // In a real web app, you might want to use IndexedDB or local storage
      throw UnsupportedError('Database not supported on web platform');
    }
    
    // Ensure database factory is initialized for non-web platforms
    try {
      // Initialize sqflite_common_ffi if not already done
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    } catch (e) {
      // Database factory should already be initialized in main.dart
      // This is a fallback in case it wasn't
    }
    
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  static Future<void> _onCreate(Database db, int version) async {
    // Create orders table
    await db.execute('''
      CREATE TABLE $_ordersTable (
        id TEXT PRIMARY KEY,
        customerName TEXT NOT NULL,
        customerEmail TEXT NOT NULL,
        customerPhone TEXT NOT NULL,
        address TEXT NOT NULL,
        city TEXT NOT NULL,
        area TEXT NOT NULL,
        serviceType TEXT NOT NULL,
        approximateArea TEXT NOT NULL,
        notes TEXT NOT NULL,
        photoCount INTEGER NOT NULL,
        createdAt TEXT NOT NULL,
        scheduledDate TEXT,
        completedDate TEXT,
        status TEXT NOT NULL,
        estimatedCost REAL,
        finalCost REAL
      )
    ''');

    // Create order updates table
    await db.execute('''
      CREATE TABLE $_orderUpdatesTable (
        id TEXT PRIMARY KEY,
        orderId TEXT NOT NULL,
        timestamp TEXT NOT NULL,
        status TEXT NOT NULL,
        message TEXT NOT NULL,
        notes TEXT,
        FOREIGN KEY (orderId) REFERENCES $_ordersTable (id)
      )
    ''');
  }

  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database upgrades when needed
  }

  // CRUD Operations for Orders
  static Future<void> insertOrder(Order order) async {
    if (kIsWeb) {
      await WebStorageService.insertOrder(order);
      return;
    }
    
    final db = await database;
    
    // Insert order
    await db.insert(
      _ordersTable,
      {
        'id': order.id,
        'customerName': order.customerName,
        'customerEmail': order.customerEmail,
        'customerPhone': order.customerPhone,
        'address': order.address,
        'city': order.city,
        'area': order.area,
        'serviceType': order.serviceType,
        'approximateArea': order.approximateArea,
        'notes': order.notes,
        'photoCount': order.photoCount,
        'createdAt': order.createdAt.toIso8601String(),
        'scheduledDate': order.scheduledDate?.toIso8601String(),
        'completedDate': order.completedDate?.toIso8601String(),
        'status': order.status.name,
        'estimatedCost': order.estimatedCost,
        'finalCost': order.finalCost,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

    // Insert order updates
    for (final update in order.updates) {
      await db.insert(
        _orderUpdatesTable,
        {
          'id': update.id,
          'orderId': order.id,
          'timestamp': update.timestamp.toIso8601String(),
          'status': update.status.name,
          'message': update.message,
          'notes': update.notes,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }

  static Future<List<Order>> getAllOrders() async {
    if (kIsWeb) {
      return await WebStorageService.loadOrders();
    }
    
    final db = await database;
    
    final orderMaps = await db.query(
      _ordersTable,
      orderBy: 'createdAt DESC',
    );

    final List<Order> orders = [];
    
    for (final orderMap in orderMaps) {
      // Get updates for this order
      final updateMaps = await db.query(
        _orderUpdatesTable,
        where: 'orderId = ?',
        whereArgs: [orderMap['id']],
        orderBy: 'timestamp ASC',
      );

      final updates = updateMaps.map((updateMap) => OrderUpdate(
        id: updateMap['id'] as String,
        timestamp: DateTime.parse(updateMap['timestamp'] as String),
        status: OrderStatus.values.firstWhere((e) => e.name == updateMap['status']),
        message: updateMap['message'] as String,
        notes: updateMap['notes'] as String?,
      )).toList();

      final order = Order(
        id: orderMap['id'] as String,
        customerName: orderMap['customerName'] as String,
        customerEmail: orderMap['customerEmail'] as String,
        customerPhone: orderMap['customerPhone'] as String,
        address: orderMap['address'] as String,
        city: orderMap['city'] as String,
        area: orderMap['area'] as String,
        serviceType: orderMap['serviceType'] as String,
        approximateArea: orderMap['approximateArea'] as String,
        notes: orderMap['notes'] as String,
        photoCount: orderMap['photoCount'] as int,
        createdAt: DateTime.parse(orderMap['createdAt'] as String),
        scheduledDate: orderMap['scheduledDate'] != null 
            ? DateTime.parse(orderMap['scheduledDate'] as String) 
            : null,
        completedDate: orderMap['completedDate'] != null 
            ? DateTime.parse(orderMap['completedDate'] as String) 
            : null,
        status: OrderStatus.values.firstWhere(
          (e) => e.name == orderMap['status'],
        ),
        estimatedCost: orderMap['estimatedCost'] as double?,
        finalCost: orderMap['finalCost'] as double?,
        updates: updates,
      );

      orders.add(order);
    }

    return orders;
  }

  static Future<Order?> getOrderById(String orderId) async {
    if (kIsWeb) {
      return await WebStorageService.getOrderById(orderId);
    }
    
    final db = await database;
    
    final orderMaps = await db.query(
      _ordersTable,
      where: 'id = ?',
      whereArgs: [orderId],
      limit: 1,
    );

    if (orderMaps.isEmpty) return null;

    final orderMap = orderMaps.first;
    
    // Get updates for this order
    final updateMaps = await db.query(
      _orderUpdatesTable,
      where: 'orderId = ?',
      whereArgs: [orderId],
      orderBy: 'timestamp ASC',
    );

    final updates = updateMaps.map((updateMap) => OrderUpdate(
      id: updateMap['id'] as String,
      timestamp: DateTime.parse(updateMap['timestamp'] as String),
      status: OrderStatus.values.firstWhere((e) => e.name == updateMap['status']),
      message: updateMap['message'] as String,
      notes: updateMap['notes'] as String?,
    )).toList();

    return Order(
      id: orderMap['id'] as String,
      customerName: orderMap['customerName'] as String,
      customerEmail: orderMap['customerEmail'] as String,
      customerPhone: orderMap['customerPhone'] as String,
      address: orderMap['address'] as String,
      city: orderMap['city'] as String,
      area: orderMap['area'] as String,
      serviceType: orderMap['serviceType'] as String,
      approximateArea: orderMap['approximateArea'] as String,
      notes: orderMap['notes'] as String,
      photoCount: orderMap['photoCount'] as int,
      createdAt: DateTime.parse(orderMap['createdAt'] as String),
      scheduledDate: orderMap['scheduledDate'] != null 
          ? DateTime.parse(orderMap['scheduledDate'] as String) 
          : null,
      completedDate: orderMap['completedDate'] != null 
          ? DateTime.parse(orderMap['completedDate'] as String) 
          : null,
      status: OrderStatus.values.firstWhere(
        (e) => e.name == orderMap['status'],
      ),
      estimatedCost: orderMap['estimatedCost'] as double?,
      finalCost: orderMap['finalCost'] as double?,
      updates: updates,
    );
  }

  static Future<void> updateOrder(Order order) async {
    if (kIsWeb) {
      await WebStorageService.updateOrder(order);
      return;
    }
    
    final db = await database;
    
    // Update order
    await db.update(
      _ordersTable,
      {
        'customerName': order.customerName,
        'customerEmail': order.customerEmail,
        'customerPhone': order.customerPhone,
        'address': order.address,
        'city': order.city,
        'area': order.area,
        'serviceType': order.serviceType,
        'approximateArea': order.approximateArea,
        'notes': order.notes,
        'photoCount': order.photoCount,
        'scheduledDate': order.scheduledDate?.toIso8601String(),
        'completedDate': order.completedDate?.toIso8601String(),
        'status': order.status.name,
        'estimatedCost': order.estimatedCost,
        'finalCost': order.finalCost,
      },
      where: 'id = ?',
      whereArgs: [order.id],
    );

    // Delete existing updates and insert new ones
    await db.delete(
      _orderUpdatesTable,
      where: 'orderId = ?',
      whereArgs: [order.id],
    );

    // Insert updated order updates
    for (final update in order.updates) {
      await db.insert(
        _orderUpdatesTable,
        {
          'id': update.id,
          'orderId': order.id,
          'timestamp': update.timestamp.toIso8601String(),
          'status': update.status.name,
          'message': update.message,
          'notes': update.notes,
        },
      );
    }
  }

  static Future<void> deleteOrder(String orderId) async {
    if (kIsWeb) {
      await WebStorageService.deleteOrder(orderId);
      return;
    }
    
    final db = await database;
    
    // Delete order updates first (due to foreign key constraint)
    await db.delete(
      _orderUpdatesTable,
      where: 'orderId = ?',
      whereArgs: [orderId],
    );

    // Delete order
    await db.delete(
      _ordersTable,
      where: 'id = ?',
      whereArgs: [orderId],
    );
  }

  static Future<void> clearAllOrders() async {
    if (kIsWeb) {
      await WebStorageService.clearOrders();
      return;
    }
    
    final db = await database;
    
    await db.delete(_orderUpdatesTable);
    await db.delete(_ordersTable);
  }

  static Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
