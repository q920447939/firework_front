import 'package:get/get.dart';
import '../../core/models/product_model.dart';
import '../../data/mock_data.dart';
import '../cart1/cart_controller.dart';

class DetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);

  final RxList<String> sizeOptions = <String>[].obs;
  final RxList<String> shotOptions = <String>[].obs;

  final RxString selectedSize = ''.obs;
  final RxString selectedShots = ''.obs;

  /// Purchase quantity (not the "shots" spec).
  final RxInt quantity = 1.obs;

  final CartController cartController = Get.put(CartController());

  String get selectedVariant {
    final parts = <String>[];
    final size = selectedSize.value.trim();
    final shots = selectedShots.value.trim();
    if (size.isNotEmpty) parts.add(size);
    if (shots.isNotEmpty) parts.add(shots);
    return parts.join(' / ');
  }

  void loadProduct(String id) {
    // Simulate API call
    final foundProduct = MockData.products.firstWhere(
      (p) => p.id == id,
      orElse: () => MockData.products.first,
    );
    product.value = foundProduct;
    _initOptions(foundProduct);
  }

  void selectSize(String size) {
    selectedSize.value = size;
  }

  void selectShots(String shots) {
    selectedShots.value = shots;
  }

  Future<void> addToCart() async {
    final p = product.value;
    if (p == null) return;
    final variant = selectedVariant;
    if (variant.isEmpty) return;
    await cartController.addToCart(p, variant, quantity.value);
  }

  void buyNow() {
    // Get.snackbar('Contact Seller', 'Opening WhatsApp/Phone...');
    // In real app: launchUrl
  }

  void _initOptions(Product foundProduct) {
    final sizes = foundProduct.specs
        .where((e) => e.contains('寸'))
        .map(_clean)
        .toList();
    final shots = foundProduct.specs
        .where((e) => e.contains('发'))
        .map(_clean)
        .toList();

    // Fallback: if we couldn't categorize, treat all as "size" options.
    sizeOptions.assignAll(
      sizes.isNotEmpty ? sizes : foundProduct.specs.map(_clean),
    );
    shotOptions.assignAll(shots);

    selectedSize.value = sizeOptions.isNotEmpty ? sizeOptions.first : '';
    selectedShots.value = shotOptions.isNotEmpty ? shotOptions.first : '';
  }

  String _clean(String raw) => raw.replaceAll(' ', '').trim();
}
