import 'package:get/get.dart';
import '../../core/db/database_helper.dart';
import '../../core/models/cart_item_model.dart';
import '../../core/models/product_model.dart';

class CartController extends GetxController {
  final RxList<CartItem> cartItems = <CartItem>[].obs;
  final RxDouble totalAmount = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    final box = await DatabaseHelper.instance.cartBox;
    final List<dynamic> rawList = box.values.toList();
    
    cartItems.value = rawList.map((e) {
      // Hive stores Map<dynamic, dynamic>, need to cast to Map<String, dynamic>
      final map = Map<String, dynamic>.from(e as Map);
      return CartItem.fromMap(map);
    }).toList();
    
    calculateTotal();
  }

  void calculateTotal() {
    double total = 0;
    for (var item in cartItems) {
      total += item.price * item.quantity;
    }
    totalAmount.value = total;
  }

  Future<void> addToCart(Product product, String spec, int quantity) async {
    final box = await DatabaseHelper.instance.cartBox;
    final id = '${product.id}_$spec';

    // Check if exists in current list (faster than DB query)
    final existing = cartItems.firstWhereOrNull((item) => item.id == id);

    if (existing != null) {
      existing.quantity += quantity;
      await box.put(id, existing.toMap());
    } else {
      final newItem = CartItem(
        id: id,
        productId: product.id,
        name: product.name,
        price: product.activityPrice ?? product.price,
        imageUrl: product.imageUrl,
        spec: spec,
        quantity: quantity,
      );
      await box.put(id, newItem.toMap());
    }
    await loadCart();
  }


  Future<void> updateQuantity(String id, int change) async {
    final box = await DatabaseHelper.instance.cartBox;
    final item = cartItems.firstWhere((item) => item.id == id);
    final newQuantity = item.quantity + change;

    if (newQuantity <= 0) {
      await box.delete(id);
    } else {
      item.quantity = newQuantity;
      await box.put(id, item.toMap());
    }
    await loadCart();
  }

  Future<void> clearCart() async {
    final box = await DatabaseHelper.instance.cartBox;
    await box.clear();
    await loadCart();
  }
}
