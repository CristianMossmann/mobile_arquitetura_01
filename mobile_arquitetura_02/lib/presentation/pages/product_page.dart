import 'package:flutter/material.dart';
import 'package:mobile_arquitetura_01/data/session/auth_session.dart';
import 'package:mobile_arquitetura_01/presentation/pages/product_detail_page.dart';
import 'package:mobile_arquitetura_01/presentation/viewmodel/product_viewmodel.dart';
import 'package:provider/provider.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  bool _showOnlyFavorites = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductViewModel>().loadProducts();
    });
  }

  void _confirmLogout() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sair'),
        content: const Text('Deseja realmente encerrar a sessão?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.read<ProductViewModel>().reset();
              context.read<AuthSession>().logout();
            },
            child: const Text('Sair'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<ProductViewModel>();
    final state = viewModel.state;
    final session = context.watch<AuthSession>();
    final user = session.currentUser;

    final displayed = _showOnlyFavorites
        ? state.products.where((p) => p.isFavorite).toList()
        : state.products;

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 16,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Produtos',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            if (user != null)
              Text(
                'Olá, ${user.firstName.isNotEmpty ? user.firstName : user.username}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.normal,
                ),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              _showOnlyFavorites ? Icons.favorite : Icons.favorite_border,
              color: _showOnlyFavorites ? Colors.red : null,
            ),
            tooltip: _showOnlyFavorites
                ? 'Mostrar todos'
                : 'Mostrar apenas favoritos',
            onPressed: () =>
                setState(() => _showOnlyFavorites = !_showOnlyFavorites),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Atualizar',
            onPressed: viewModel.loadProducts,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _confirmLogout,
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          if (state.isLoading && state.products.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null && state.products.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      state.error!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 16),
                    FilledButton.icon(
                      onPressed: viewModel.loadProducts,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (displayed.isEmpty) {
            return Center(
              child: Text(
                _showOnlyFavorites
                    ? 'Você ainda não favoritou nenhum produto.'
                    : 'Nenhum produto encontrado.',
                textAlign: TextAlign.center,
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: viewModel.loadProducts,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: displayed.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final product = displayed[index];
                return ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.thumbnail,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.image_not_supported),
                      ),
                    ),
                  ),
                  title: Text(
                    product.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      product.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: product.isFavorite ? Colors.red : null,
                    ),
                    tooltip: product.isFavorite
                        ? 'Remover dos favoritos'
                        : 'Adicionar aos favoritos',
                    onPressed: () => viewModel.toggleFavorite(product.id),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailPage(productId: product.id),
                      ),
                    );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
