import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_01/domain/entities/product.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;

  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final Product? product = viewModel.state.products.cast<Product?>().firstWhere(
          (p) => p?.id == productId,
          orElse: () => null,
        );

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detalhes')),
        body: const Center(child: Text('Produto não encontrado.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          product.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite : Icons.favorite_border,
              color: product.isFavorite ? Colors.red : null,
            ),
            tooltip: product.isFavorite
                ? 'Remover dos favoritos'
                : 'Adicionar aos favoritos',
            onPressed: () => viewModel.toggleFavorite(product.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.grey.shade100,
              width: double.infinity,
              height: 320,
              child: Image.network(
                product.thumbnail,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(Icons.image_not_supported, size: 100),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 10),
                  if (product.brand.isNotEmpty || product.category.isNotEmpty)
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        if (product.brand.isNotEmpty)
                          Chip(
                            label: Text(product.brand),
                            visualDensity: VisualDensity.compact,
                          ),
                        if (product.category.isNotEmpty)
                          Chip(
                            label: Text(product.category),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  if (product.rating > 0) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          product.rating.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 24),
                  Text(
                    'Descrição',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description.isNotEmpty
                        ? product.description
                        : 'Sem descrição disponível.',
                    style: const TextStyle(fontSize: 16, height: 1.45),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Voltar'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
