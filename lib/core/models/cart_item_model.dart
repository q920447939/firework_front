class CartItem {
  final String id; // Unique ID (e.g., productId + spec)
  final String productId;
  final String name;
  final double price;
  final String imageUrl;
  final String spec;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
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
      'imageUrl': imageUrl,
      'spec': spec,
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      productId: map['productId'],
      name: map['name'],
      price: map['price'],
      imageUrl: map['imageUrl'],
      spec: map['spec'],
      quantity: map['quantity'],
    );
  }
}
