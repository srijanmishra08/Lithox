class Order {
  final String id;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String address;
  final String city;
  final String area;
  final String serviceType;
  final String approximateArea;
  final String notes;
  final int photoCount;
  final DateTime createdAt;
  final DateTime? scheduledDate;
  final DateTime? completedDate;
  final OrderStatus status;
  final double? estimatedCost;
  final double? finalCost;
  final List<OrderUpdate> updates;

  const Order({
    required this.id,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.address,
    required this.city,
    required this.area,
    required this.serviceType,
    required this.approximateArea,
    required this.notes,
    required this.photoCount,
    required this.createdAt,
    this.scheduledDate,
    this.completedDate,
    required this.status,
    this.estimatedCost,
    this.finalCost,
    this.updates = const [],
  });

  Order copyWith({
    String? id,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? address,
    String? city,
    String? area,
    String? serviceType,
    String? approximateArea,
    String? notes,
    int? photoCount,
    DateTime? createdAt,
    DateTime? scheduledDate,
    DateTime? completedDate,
    OrderStatus? status,
    double? estimatedCost,
    double? finalCost,
    List<OrderUpdate>? updates,
  }) {
    return Order(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      address: address ?? this.address,
      city: city ?? this.city,
      area: area ?? this.area,
      serviceType: serviceType ?? this.serviceType,
      approximateArea: approximateArea ?? this.approximateArea,
      notes: notes ?? this.notes,
      photoCount: photoCount ?? this.photoCount,
      createdAt: createdAt ?? this.createdAt,
      scheduledDate: scheduledDate ?? this.scheduledDate,
      completedDate: completedDate ?? this.completedDate,
      status: status ?? this.status,
      estimatedCost: estimatedCost ?? this.estimatedCost,
      finalCost: finalCost ?? this.finalCost,
      updates: updates ?? this.updates,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'address': address,
      'city': city,
      'area': area,
      'serviceType': serviceType,
      'approximateArea': approximateArea,
      'notes': notes,
      'photoCount': photoCount,
      'createdAt': createdAt.toIso8601String(),
      'scheduledDate': scheduledDate?.toIso8601String(),
      'completedDate': completedDate?.toIso8601String(),
      'status': status.name,
      'estimatedCost': estimatedCost,
      'finalCost': finalCost,
      'updates': updates.map((update) => update.toJson()).toList(),
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      customerName: json['customerName'],
      customerEmail: json['customerEmail'],
      customerPhone: json['customerPhone'],
      address: json['address'],
      city: json['city'],
      area: json['area'],
      serviceType: json['serviceType'],
      approximateArea: json['approximateArea'],
      notes: json['notes'],
      photoCount: json['photoCount'],
      createdAt: DateTime.parse(json['createdAt']),
      scheduledDate: json['scheduledDate'] != null ? DateTime.parse(json['scheduledDate']) : null,
      completedDate: json['completedDate'] != null ? DateTime.parse(json['completedDate']) : null,
      status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
      estimatedCost: json['estimatedCost']?.toDouble(),
      finalCost: json['finalCost']?.toDouble(),
      updates: (json['updates'] as List?)?.map((update) => OrderUpdate.fromJson(update)).toList() ?? [],
    );
  }
}

enum OrderStatus {
  submitted,
  reviewed,
  quoted,
  scheduled,
  inProgress,
  completed,
  cancelled;

  String get displayName {
    switch (this) {
      case OrderStatus.submitted:
        return 'Submitted';
      case OrderStatus.reviewed:
        return 'Under Review';
      case OrderStatus.quoted:
        return 'Quote Provided';
      case OrderStatus.scheduled:
        return 'Scheduled';
      case OrderStatus.inProgress:
        return 'In Progress';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.submitted:
        return 'Your consultation request has been received';
      case OrderStatus.reviewed:
        return 'Our team is reviewing your requirements';
      case OrderStatus.quoted:
        return 'Quote has been prepared for your approval';
      case OrderStatus.scheduled:
        return 'Installation has been scheduled';
      case OrderStatus.inProgress:
        return 'Work is currently in progress';
      case OrderStatus.completed:
        return 'Project has been completed successfully';
      case OrderStatus.cancelled:
        return 'Order has been cancelled';
    }
  }
}

class OrderUpdate {
  final String id;
  final DateTime timestamp;
  final OrderStatus status;
  final String message;
  final String? notes;

  const OrderUpdate({
    required this.id,
    required this.timestamp,
    required this.status,
    required this.message,
    this.notes,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'message': message,
      'notes': notes,
    };
  }

  factory OrderUpdate.fromJson(Map<String, dynamic> json) {
    return OrderUpdate(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
      message: json['message'],
      notes: json['notes'],
    );
  }
}
