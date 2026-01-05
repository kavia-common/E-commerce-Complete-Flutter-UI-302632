class Wishlist {
  const Wishlist({
    required this.productIds,
    required this.updatedAt,
  });

  final Set<String> productIds;
  final DateTime updatedAt;

  static Wishlist empty() => Wishlist(productIds: <String>{}, updatedAt: DateTime.now());

  bool contains(String productId) => productIds.contains(productId);

  Wishlist copyWith({
    Set<String>? productIds,
    DateTime? updatedAt,
  }) {
    return Wishlist(
      productIds: productIds ?? this.productIds,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Wishlist.fromJson(Map<String, Object?> json) {
    final List<dynamic> ids = (json['productIds'] as List<dynamic>?) ?? <dynamic>[];
    return Wishlist(
      productIds: ids.map((e) => e.toString()).toSet(),
      updatedAt: DateTime.tryParse((json['updatedAt'] as String?) ?? '') ?? DateTime.now(),
    );
  }

  Map<String, Object?> toJson() {
    return <String, Object?>{
      'schemaVersion': 1,
      'productIds': productIds.toList()..sort(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
