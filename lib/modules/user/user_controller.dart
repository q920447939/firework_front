import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/db/database_helper.dart';
import '../../core/models/order_model.dart';
import '../../core/models/cart_item_model.dart';

class UserController extends GetxController {
  final RxList<Order> orders = <Order>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
  }

  Future<void> loadOrders() async {
    final box = await DatabaseHelper.instance.orderBox;
    final List<dynamic> rawList = box.values.toList();
    
    // Sort by date manually since Hive is key-value store
    final parsedOrders = rawList.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      return Order.fromMap(map);
    }).toList();
    
    parsedOrders.sort((a, b) => b.date.compareTo(a.date));
    orders.value = parsedOrders;
  }

  Future<void> createOrder(List<CartItem> items, double total) async {
    final box = await DatabaseHelper.instance.orderBox;
    final newOrder = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      date: DateTime.now().toIso8601String(),
      totalAmount: total,
      status: 'Pending',
      items: items,
    );

    await box.put(newOrder.id, newOrder.toMap());
    await loadOrders();
  }

  Future<void> contactSeller(String? orderId) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: '1234567890', // Replace with real number
    );
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      // Get.snackbar('Error', 'Could not launch dialer');
      print('Could not launch dialer');
    }


  }
}
