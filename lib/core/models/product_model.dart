class Product {
  final String id;
  final String name;
  final double price;
  final double? activityPrice;
  final String imageUrl;
  final String? videoUrl;
  final int salesCount;
  final int heat; // 1-5 scale or raw number
  final List<String> specs;
  final String description;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.activityPrice,
    required this.imageUrl,
    this.videoUrl,
    required this.salesCount,
    required this.heat,
    required this.specs,
    required this.description,
  });

  // Factory for simple mock data creation
  factory Product.mock(
    String id,
    String name,
    double price,
    List<String> specs,
    String imageUrl,
  ) {
    return Product(
      id: id,
      name: name,
      price: price,
      activityPrice: price * 0.8,
      imageUrl: imageUrl,
      videoUrl:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      salesCount: 100 + int.parse(id) * 10,
      heat: 5,
      specs: specs,
      description:
          'This is a spectacular firework named $name. It features vibrant colors and loud bangs. Perfect for celebrations!',
    );
  }
}
