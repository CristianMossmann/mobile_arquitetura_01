import 'package:mobile_arquitetura_01/core/errors/failure.dart';
import 'package:mobile_arquitetura_01/data/datasources/product_cache_datasource.dart';
import 'package:mobile_arquitetura_01/data/datasources/product_remote_datasource.dart';
import 'package:mobile_arquitetura_01/data/models/product_model.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remote;
  final ProductCacheDatasource cache;

  ProductRepositoryImpl(this.remote, this.cache);

  Product _toEntity(ProductModel m) {
    return Product(
      id: m.id,
      title: m.title,
      description: m.description,
      price: m.price,
      thumbnail: m.thumbnail,
      brand: m.brand,
      category: m.category,
      rating: m.rating,
    );
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final models = await remote.getProducts();
      cache.save(models);
      return models.map(_toEntity).toList();
    } catch (e) {
      final cached = cache.get();
      if (cached != null && cached.isNotEmpty) {
        return cached.map(_toEntity).toList();
      }
      throw Failure('Não foi possível carregar os produtos');
    }
  }

  @override
  Future<Product> getProductById(int id) async {
    try {
      final model = await remote.getProductById(id);
      return _toEntity(model);
    } catch (e) {
      throw Failure('Não foi possível carregar o produto');
    }
  }
}
