import 'package:get/get.dart';
import '../../core/models/product_model.dart';
import '../../core/network/public_product_api.dart';
import '../cart1/cart_controller.dart';

class DetailController extends GetxController {
  final Rx<Product?> product = Rx<Product?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final RxList<String> sizeOptions = <String>[].obs;
  final RxList<String> shotOptions = <String>[].obs;

  final RxString selectedSize = ''.obs;
  final RxString selectedShots = ''.obs;

  /// Purchase quantity (not the "shots" spec).
  final RxInt quantity = 1.obs;

  final CartController cartController = Get.put(CartController());
  final PublicProductApi _api = PublicProductApi();

  String get selectedVariant {
    final parts = <String>[];
    final size = selectedSize.value.trim();
    final shots = selectedShots.value.trim();
    if (size.isNotEmpty) parts.add(size);
    if (shots.isNotEmpty) parts.add(shots);
    return parts.join(' / ');
  }

  Future<void> loadProduct(String id) async {
    isLoading.value = true;
    errorMessage.value = '';
    product.value = null;
    try {
      final foundProduct = await _api.fetchProductDetailAsAppProduct(id);
      product.value = foundProduct;
      _initOptions(foundProduct);
    } catch (e) {
      errorMessage.value = e.toString();
      product.value = null;
    } finally {
      isLoading.value = false;
    }
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
