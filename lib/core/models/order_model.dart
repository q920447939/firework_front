import 'dart:convert';
import 'cart_item_model.dart';

class Order {
  final String id;
  final String date;
  final double totalAmount;
  final String status; // 'Pending', 'Completed'
  final List<CartItem> items;

  Order({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.status,
    required this.items,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'totalAmount': totalAmount,
      'status': status,
      'items': jsonEncode(items.map((e) => e.toMap()).toList()),
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      date: map['date'],
      totalAmount: map['totalAmount'],
      status: map['status'],
      items: (jsonDecode(map['items']) as List)
          .map((e) => CartItem.fromMap(e))
          .toList(),
    );
  }
}
