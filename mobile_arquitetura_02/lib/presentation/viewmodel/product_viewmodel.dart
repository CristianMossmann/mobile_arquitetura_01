import 'package:flutter/foundation.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/domain/repositories/product_repository.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/product_state.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository repository;
  ProductState _state = const ProductState();

  ProductState get state => _state;

  ProductViewModel(this.repository);

  Future<void> loadProducts() async {
    _state = _state.copyWith(isLoading: true, clearError: true);
    notifyListeners();

    try {
      final products = await repository.getProducts();
      final preservedFavorites = {
        for (final p in _state.products.where((p) => p.isFavorite)) p.id,
      };
      final merged = products
          .map((p) => preservedFavorites.contains(p.id)
              ? p.copyWith(isFavorite: true)
              : p)
          .toList();
      _state = _state.copyWith(
        isLoading: false,
        products: merged,
        clearError: true,
      );
    } catch (e) {
      _state = _state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
    notifyListeners();
  }

  void toggleFavorite(int productId) {
    final updated = _state.products.map((product) {
      if (product.id == productId) {
        return product.copyWith(isFavorite: !product.isFavorite);
      }
      return product;
    }).toList();

    _state = _state.copyWith(products: updated);
    notifyListeners();
  }

  List<Product> get favorites =>
      _state.products.where((p) => p.isFavorite).toList();

  void reset() {
    _state = const ProductState();
    notifyListeners();
  }
}
