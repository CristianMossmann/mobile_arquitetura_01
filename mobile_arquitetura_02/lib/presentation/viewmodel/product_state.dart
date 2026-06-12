import 'package:mobile_arquitetura_01/domain/entities/product.dart';

class ProductState {
  final bool isLoading;
  final List<Product> products;
  final String? error;

  const ProductState({
    this.isLoading = false,
    this.products = const [],
    this.error,
  });

  ProductState copyWith({
    bool? isLoading,
    List<Product>? products,
    String? error,
    bool clearError = false,
  }) {
    return ProductState(
      isLoading: isLoading ?? this.isLoading,
      products: products ?? this.products,
      error: clearError ? null : (error ?? this.error),
    );
  }
}
