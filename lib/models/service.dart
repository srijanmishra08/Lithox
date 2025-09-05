class Service {
  final String id;
  final String title;
  final String subtitle;
  final String description;
  final double pricePerSqFt;
  final String? image;
  final List<String> features;
  final String process;

  Service({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.description,
    required this.pricePerSqFt,
    this.image,
    this.features = const [],
    this.process = '',
  });

  factory Service.fromJson(Map<String, dynamic> json) {
    return Service(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      description: json['description'] as String,
      pricePerSqFt: (json['pricePerSqFt'] as num).toDouble(),
      image: json['image'] as String?,
      features: json['features'] != null 
          ? List<String>.from(json['features'] as List)
          : [],
      process: json['process'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'description': description,
      'pricePerSqFt': pricePerSqFt,
      if (image != null) 'image': image,
      'features': features,
      'process': process,
    };
  }

  Service copyWith({
    String? id,
    String? title,
    String? subtitle,
    String? description,
    double? pricePerSqFt,
    String? image,
    List<String>? features,
    String? process,
  }) {
    return Service(
      id: id ?? this.id,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      description: description ?? this.description,
      pricePerSqFt: pricePerSqFt ?? this.pricePerSqFt,
      image: image ?? this.image,
      features: features ?? this.features,
      process: process ?? this.process,
    );
  }
}
