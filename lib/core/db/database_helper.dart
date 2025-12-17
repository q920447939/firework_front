import 'package:hive_flutter/hive_flutter.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  
  Box? _cartBox;
  Box? _orderBox;

  DatabaseHelper._init();

  Future<void> init() async {
    _cartBox = await Hive.openBox('cart');
    _orderBox = await Hive.openBox('orders');
  }

  Future<Box> get cartBox async {
    if (_cartBox == null || !_cartBox!.isOpen) {
      _cartBox = await Hive.openBox('cart');
    }
    return _cartBox!;
  }

  Future<Box> get orderBox async {
    if (_orderBox == null || !_orderBox!.isOpen) {
      _orderBox = await Hive.openBox('orders');
    }
    return _orderBox!;
  }
}
