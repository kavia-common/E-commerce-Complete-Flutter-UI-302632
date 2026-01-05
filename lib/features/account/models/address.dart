class Address {
  const Address({
    required this.id,
    required this.userId,
    required this.fullName,
    required this.phoneNumber,
    required this.line1,
    this.line2,
    required this.city,
    this.state,
    required this.postalCode,
    required this.countryCode,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String userId;
  final String fullName;
  final String phoneNumber;
  final String line1;
  final String? line2;
  final String city;
  final String? state;
  final String postalCode;
  final String countryCode;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  Address copyWith({
    String? fullName,
    String? phoneNumber,
    String? line1,
    String? line2,
    String? city,
    String? state,
    String? postalCode,
    String? countryCode,
    bool? isDefault,
    DateTime? updatedAt,
  }) {
    return Address(
      id: id,
      userId: userId,
      fullName: fullName ?? this.fullName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      line1: line1 ?? this.line1,
      line2: line2 ?? this.line2,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      countryCode: countryCode ?? this.countryCode,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Address.fromJson(Map<String, Object?> json) {
    return Address(
      id: (json['id'] as String?) ?? '',
      userId: (json['userId'] as String?) ?? 'local-user',
      fullName: (json['fullName'] as String?) ?? '',
      phoneNumber: (json['phoneNumber'] as String?) ?? '',
      line1: (json['line1'] as String?) ?? '',
      line2: json['line2'] as String?,
      city: (json['city'] as String?) ?? '',
      state: json['state'] as String?,
      postalCode: (json['postalCode'] as String?) ?? '',
      countryCode: (json['countryCode'] as String?) ?? 'US',
      isDefault: (json['isDefault'] as bool?) ?? false,
      createdAt: DateTime.tryParse((json['createdAt'] as String?) ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'schemaVersion': 1,
      'id': id,
      'userId': userId,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'line1': line1,
      'line2': line2,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'countryCode': countryCode,
      'isDefault': isDefault,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
