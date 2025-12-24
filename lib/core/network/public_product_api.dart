import 'package:get/get.dart';

import '../../config/server_config.dart';
import '../models/product_model.dart';

class PublicProductApi {
  final GetConnect _client;
  final ServerConfig _config;

  PublicProductApi({GetConnect? client, ServerConfig? config})
      : _client = client ?? GetConnect(),
        _config = config ?? ServerConfig() {
    _client.httpClient.baseUrl = _baseUrl(_config);
    _client.httpClient.timeout = const Duration(seconds: 15);
  }

  Future<List<_PublicProductLite>> _fetchHotProducts({int limit = 20}) async {
    final tenantCode = _config.tenantCode;
    if (tenantCode.trim().isEmpty) {
      throw StateError('TENANT_CODE is empty');
    }

    final resp = await _client.get(
      '/api/public/$tenantCode/hot-products',
      query: {'limit': limit.toString()},
    );
    if (!resp.isOk) {
      throw StateError('HTTP ${resp.statusCode ?? '-'}: ${resp.statusText ?? 'Request failed'}');
    }
    final body = resp.body;
    final map = _asMap(body);
    final success = map['success'] == true;
    if (!success) {
      throw StateError((map['message'] ?? 'Request failed').toString());
    }

    final data = map['data'];
    final list = data is List ? data : const <dynamic>[];
    return list.map((e) => _PublicProductLite.fromJson(_asMap(e))).toList();
  }

  Future<Product> fetchProductDetailAsAppProduct(String productId) async {
    final tenantCode = _config.tenantCode;
    if (tenantCode.trim().isEmpty) {
      throw StateError('TENANT_CODE is empty');
    }

    final resp = await _client.get('/api/public/$tenantCode/products/$productId');
    if (!resp.isOk) {
      throw StateError('HTTP ${resp.statusCode ?? '-'}: ${resp.statusText ?? 'Request failed'}');
    }
    final body = resp.body;
    final map = _asMap(body);
    final success = map['success'] == true;
    if (!success) {
      throw StateError((map['message'] ?? 'Request failed').toString());
    }

    final data = _asMap(map['data']);
    final productJson = _asMap(data['product']);
    final mediasJson = data['medias'] is List ? (data['medias'] as List) : const <dynamic>[];
    final skusJson = data['skus'] is List ? (data['skus'] as List) : const <dynamic>[];

    final id = (productJson['id'] ?? productId).toString();
    final name = (productJson['title'] ?? '').toString();
    final imageUrl = (productJson['mainImageUrl'] ?? '').toString();
    final description = (productJson['detailMarkdown'] ?? '').toString();

    final specs = skusJson
        .map((e) => _asMap(e))
        .map((m) => (m['specName'] ?? '').toString())
        .where((s) => s.trim().isNotEmpty)
        .toList();

    double? minOriginal;
    double? minActive;
    for (final sku in skusJson) {
      final m = _asMap(sku);
      final original = _toDouble(m['originalPrice']);
      final active = _toDouble(m['activePrice']);
      if (original != null) {
        minOriginal = minOriginal == null ? original : (original < minOriginal ? original : minOriginal);
      }
      if (active != null) {
        minActive = minActive == null ? active : (active < minActive ? active : minActive);
      }
    }

    String? videoUrl;
    for (final media in mediasJson) {
      final m = _asMap(media);
      final mediaType = _toInt(m['mediaType']);
      if (mediaType == 2) {
        final url = (m['url'] ?? '').toString();
        if (url.trim().isNotEmpty) {
          videoUrl = url;
          break;
        }
      }
    }

    return Product(
      id: id,
      name: name.isNotEmpty ? name : '商品 $id',
      price: minOriginal ?? 0,
      activityPrice: minActive,
      imageUrl: imageUrl,
      videoUrl: videoUrl,
      salesCount: 0,
      heat: 0,
      specs: specs,
      description: description,
    );
  }

  Future<List<Product>> fetchHomeProducts({int limit = 20}) async {
    final lites = await _fetchHotProducts(limit: limit);
    if (lites.isEmpty) return const <Product>[];
    final futures = lites.map((p) => fetchProductDetailAsAppProduct(p.id));
    return Future.wait(futures);
  }

  Future<Map<String, CartProductSnapshot>> fetchProductsBatchForCart(
    List<String> productIds,
  ) async {
    final tenantCode = _config.tenantCode;
    if (tenantCode.trim().isEmpty) {
      throw StateError('TENANT_CODE is empty');
    }
    if (productIds.isEmpty) return <String, CartProductSnapshot>{};

    final ids = productIds
        .map((e) => int.tryParse(e.trim()))
        .whereType<int>()
        .toList();
    if (ids.isEmpty) return <String, CartProductSnapshot>{};

    final resp = await _client.post(
      '/api/public/$tenantCode/products/batch',
      {'ids': ids},
    );
    if (!resp.isOk) {
      throw StateError('HTTP ${resp.statusCode ?? '-'}: ${resp.statusText ?? 'Request failed'}');
    }

    final map = _asMap(resp.body);
    final success = map['success'] == true;
    if (!success) {
      throw StateError((map['message'] ?? 'Request failed').toString());
    }

    final data = map['data'];
    final list = data is List ? data : const <dynamic>[];
    final result = <String, CartProductSnapshot>{};

    for (final row in list) {
      final rowMap = _asMap(row);
      final productJson = _asMap(rowMap['product']);
      final skusJson = rowMap['skus'] is List ? (rowMap['skus'] as List) : const <dynamic>[];

      final id = (productJson['id'] ?? '').toString();
      if (id.trim().isEmpty) continue;
      final title = (productJson['title'] ?? '').toString();
      final mainImageUrl = (productJson['mainImageUrl'] ?? '').toString();

      double? minOriginal;
      double? minActive;
      final skus = <CartSkuSnapshot>[];
      for (final sku in skusJson) {
        final m = _asMap(sku);
        final specName = (m['specName'] ?? '').toString();
        final original = _toDouble(m['originalPrice']);
        final active = _toDouble(m['activePrice']);

        if (original != null) {
          minOriginal = minOriginal == null ? original : (original < minOriginal ? original : minOriginal);
        }
        if (active != null) {
          minActive = minActive == null ? active : (active < minActive ? active : minActive);
        }

        skus.add(
          CartSkuSnapshot(
            specName: specName,
            originalPrice: original,
            activePrice: active,
          ),
        );
      }

      result[id] = CartProductSnapshot(
        id: id,
        title: title,
        mainImageUrl: mainImageUrl,
        minOriginalPrice: minOriginal,
        minActivePrice: minActive,
        skus: skus,
      );
    }
    return result;
  }

  static String _baseUrl(ServerConfig config) {
    final host = config.host.trim();
    final port = config.port.trim();
    final scheme = config.scheme.trim().isNotEmpty ? config.scheme.trim() : 'http';
    if (port.isEmpty) return '$scheme://$host';
    return '$scheme://$host:$port';
  }
}

class CartProductSnapshot {
  final String id;
  final String title;
  final String mainImageUrl;
  final double? minOriginalPrice;
  final double? minActivePrice;
  final List<CartSkuSnapshot> skus;

  CartProductSnapshot({
    required this.id,
    required this.title,
    required this.mainImageUrl,
    required this.minOriginalPrice,
    required this.minActivePrice,
    required this.skus,
  });
}

class CartSkuSnapshot {
  final String specName;
  final double? originalPrice;
  final double? activePrice;

  CartSkuSnapshot({
    required this.specName,
    required this.originalPrice,
    required this.activePrice,
  });
}

class _PublicProductLite {
  final String id;
  final String title;
  final String mainImageUrl;

  _PublicProductLite({required this.id, required this.title, required this.mainImageUrl});

  factory _PublicProductLite.fromJson(Map<String, dynamic> json) {
    return _PublicProductLite(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      mainImageUrl: (json['mainImageUrl'] ?? '').toString(),
    );
  }
}

Map<String, dynamic> _asMap(dynamic value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((k, v) => MapEntry(k.toString(), v));
  return <String, dynamic>{};
}

double? _toDouble(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  final s = v.toString().trim();
  if (s.isEmpty) return null;
  return double.tryParse(s);
}

int? _toInt(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString().trim());
}
