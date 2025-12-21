import 'package:get/get.dart';
import '../../core/models/product_model.dart';
import '../../core/network/public_product_api.dart';

class HomeController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> hotProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;

  final RxList<String> searchSuggestions = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  final PublicProductApi _api = PublicProductApi();
  final List<Product> _allProducts = <Product>[];

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final list = await _api.fetchHomeProducts(limit: 20);
      _allProducts
        ..clear()
        ..addAll(list);
      products.assignAll(list);
      hotProducts.assignAll(list.take(5));
      searchSuggestions.assignAll(
        hotProducts.map((p) => p.name).where((s) => s.trim().isNotEmpty).take(10).toList(),
      );
    } catch (e) {
      errorMessage.value = e.toString();
      products.clear();
      hotProducts.clear();
      searchSuggestions.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      products.assignAll(_allProducts);
    } else {
      final q = query.toLowerCase();
      products.assignAll(
        _allProducts.where((p) => p.name.toLowerCase().contains(q)).toList(),
      );
    }
  }
}
