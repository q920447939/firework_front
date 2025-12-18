import 'package:get/get.dart';
import '../../core/models/product_model.dart';
import '../../data/mock_data.dart';
import '../cart1/cart_controller.dart';

class DetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxString selectedSpec = ''.obs;
  final RxInt quantity = 1.obs;
  final CartController cartController = Get.put(CartController());

  void loadProduct(String id) {
    // Simulate API call
    final foundProduct = MockData.products.firstWhere(
      (p) => p.id == id,
      orElse: () => MockData.products.first,
    );
    product.value = foundProduct;
    if (foundProduct.specs.isNotEmpty) {
      selectedSpec.value = foundProduct.specs.first;
    }
  }

  void selectSpec(String spec) {
    selectedSpec.value = spec;
  }

  Future<void> addToCart() async {
    if (product.value != null && selectedSpec.isNotEmpty) {
      await cartController.addToCart(
        product.value!,
        selectedSpec.value,
        quantity.value,
      );
    }
  }

  void buyNow() {
    // Get.snackbar('Contact Seller', 'Opening WhatsApp/Phone...');
    // In real app: launchUrl
  }
}
