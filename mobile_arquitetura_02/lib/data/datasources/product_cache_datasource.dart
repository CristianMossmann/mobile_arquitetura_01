import 'package:mobile_arquitetura_01/data/models/product_model.dart';

class ProductCacheDatasource {
  List<ProductModel>? _cache;

  void save(List<ProductModel> products) {
    _cache = products;
  }

  List<ProductModel>? get() => _cache;
}
