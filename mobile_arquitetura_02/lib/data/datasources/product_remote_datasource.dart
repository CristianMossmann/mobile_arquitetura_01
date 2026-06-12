import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_01/data/models/product_model.dart';

class ProductRemoteDatasource {
  static const _baseUrl = 'https://dummyjson.com';
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response =
        await client.get(Uri.parse('$_baseUrl/products?limit=30'));

    if (response.statusCode != 200) {
      throw Exception('Erro ao carregar produtos (${response.statusCode})');
    }

    final Map<String, dynamic> data = jsonDecode(response.body);
    final List products = data['products'] ?? [];
    return products
        .map((json) => ProductModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<ProductModel> getProductById(int id) async {
    final response = await client.get(Uri.parse('$_baseUrl/products/$id'));

    if (response.statusCode != 200) {
      throw Exception('Produto não encontrado');
    }

    return ProductModel.fromJson(jsonDecode(response.body));
  }
}
