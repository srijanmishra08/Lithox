enum OrderStatus {
  pending,
  confirmed,
  chemicalApplied,
  polished,
  completed,
}

class Order {
  final String orderId;
  final String userId;
  final String name;
  final String phone;
  final String email;
  final String addressEncrypted;
  final double sqFt;
  final String serviceId;
  final String? selfieUrl;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Order({
    required this.orderId,
    required this.userId,
    required this.name,
    required this.phone,
    required this.email,
    required this.addressEncrypted,
    required this.sqFt,
    required this.serviceId,
    this.selfieUrl,
    required this.status,
    required this.createdAt,
    this.updatedAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderId: json['orderId'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      addressEncrypted: json['address_encrypted'] as String,
      sqFt: (json['sqFt'] as num).toDouble(),
      serviceId: json['serviceId'] as String,
      selfieUrl: json['selfieUrl'] as String?,
      status: OrderStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null 
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'userId': userId,
      'name': name,
      'phone': phone,
      'email': email,
      'address_encrypted': addressEncrypted,
      'sqFt': sqFt,
      'serviceId': serviceId,
      if (selfieUrl != null) 'selfieUrl': selfieUrl,
      'status': status.name.toUpperCase(),
      'createdAt': createdAt.toIso8601String(),
      if (updatedAt != null) 'updatedAt': updatedAt!.toIso8601String(),
    };
  }

  Order copyWith({
    String? orderId,
    String? userId,
    String? name,
    String? phone,
    String? email,
    String? addressEncrypted,
    double? sqFt,
    String? serviceId,
    String? selfieUrl,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Order(
      orderId: orderId ?? this.orderId,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      addressEncrypted: addressEncrypted ?? this.addressEncrypted,
      sqFt: sqFt ?? this.sqFt,
      serviceId: serviceId ?? this.serviceId,
      selfieUrl: selfieUrl ?? this.selfieUrl,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get statusDisplayName {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.chemicalApplied:
        return 'Chemical Applied';
      case OrderStatus.polished:
        return 'Polished';
      case OrderStatus.completed:
        return 'Completed';
    }
  }
}
