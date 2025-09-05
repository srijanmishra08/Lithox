class User {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final DateTime createdAt;
  final String? address;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      uid: json['uid'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      address: json['address'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      if (address != null) 'address': address,
    };
  }

  User copyWith({
    String? uid,
    String? name,
    String? email,
    String? phone,
    DateTime? createdAt,
    String? address,
  }) {
    return User(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
    );
  }
}
