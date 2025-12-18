import '../core/models/product_model.dart';

class MockData {
  static List<Product> get products {
    /* return List.generate(20, (index) {
      return Product.mock(
        index.toString(),
        '龙腾盛世礼花弹 ${index + 1}',
        88.0 + index * 10,
      );
    });
     */
    return [
      Product.mock(
        "1",
        '龙腾盛世礼花弹',
        88.0,
        ['12寸', '36 发'],
        'https://lsyxhp.com/index.php?m=home&c=Lists&a=index&tid=4',
      ),
      Product.mock(
        "2",
        '凤舞九天组合烟花',
        88.0,
        ['10寸', '40 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQtTswm6NUXwxZ6_KrokReyOrqXaXTOF2df-g&s',
      ),
      Product.mock(
        "3",
        '加特林',
        42.0,
        ['1箱', '8 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnrmLv--R069frdJOoimFNuRSoTcT0ExHqWA&s',
      ),
      Product.mock(
        "4",
        '仙女棒',
        42.0,
        ['1箱', '10 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnrmLv--R069frdJOoimFNuRSoTcT0ExHqWA&s',
      ),
      Product.mock(
        "5",
        '水母烟花',
        42.0,
        ['1箱', '12 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnrmLv--R069frdJOoimFNuRSoTcT0ExHqWA&s',
      ),
      Product.mock(
        "6",
        '孔雀开屏',
        42.0,
        ['1箱', '12 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnrmLv--R069frdJOoimFNuRSoTcT0ExHqWA&s',
      ),
      Product.mock(
        "7",
        '满天星',
        42.0,
        ['1箱', '12 发'],
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQnrmLv--R069frdJOoimFNuRSoTcT0ExHqWA&s',
      ),
    ];
  }

  static List<Product> get hotProducts {
    return products.take(3).toList();
  }
}
