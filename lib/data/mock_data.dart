import '../core/models/product_model.dart';

class MockData {
  static List<Product> get products {
    return List.generate(20, (index) {
      return Product.mock(
        index.toString(),
        'Firework Item ${index + 1}',
        88.0 + index * 10,
      );
    });
  }

  static List<Product> get hotProducts {
    return products.take(3).toList();
  }
}
