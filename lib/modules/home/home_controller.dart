import 'package:get/get.dart';
import '../../data/mock_data.dart';
import '../../core/models/product_model.dart';

class HomeController extends GetxController {
  final RxList<Product> products = <Product>[].obs;
  final RxList<Product> hotProducts = <Product>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  void loadData() {
    // Simulate API delay
    Future.delayed(const Duration(milliseconds: 500), () {
      products.value = MockData.products;
      hotProducts.value = MockData.hotProducts;
    });
  }

  void search(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      products.value = MockData.products;
    } else {
      products.value = MockData.products.where((p) => 
        p.name.toLowerCase().contains(query.toLowerCase())
      ).toList();
    }
  }
}
