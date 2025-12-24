class CartItem {
  final String id; // Unique ID (e.g., productId + spec)
  final String productId;
  final String name;
  /// Current price (prefer active price if present).
  final double price;
  /// Original price for strikethrough display.
  final double originalPrice;
  final String imageUrl;
  final String spec;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.imageUrl,
    required this.spec,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'name': name,
      'price': price,
      'originalPrice': originalPrice,
      'imageUrl': imageUrl,
      'spec': spec,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    final price = _toDoubleOrZero(map['price']);
    final originalPrice = _toDoubleNullable(map['originalPrice']) ?? price;
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: price,
      originalPrice: originalPrice,
      imageUrl: map['imageUrl'],
      spec: map['spec'],
      quantity: map['quantity'],
    );
  }
}

double? _toDoubleNullable(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  final parsed = double.tryParse(v.toString().trim());
  return parsed;
}

double _toDoubleOrZero(dynamic v) {
  if (v is num) return v.toDouble();
  return double.tryParse((v ?? '').toString().trim()) ?? 0.0;
}
