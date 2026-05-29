import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile_arquitetura_02/data/models/product_model.dart';

class ProductRemoteDatasource {
  final http.Client client;

  ProductRemoteDatasource(this.client);

  Future<List<ProductModel>> getProducts() async {
    final response =
        await client.get(Uri.parse("https://fakestoreapi.com/products"));

    final List data = jsonDecode(response.body);

    return data.map((json) => ProductModel.fromJson(json)).toList();
  }

  Future<ProductModel> addProduct(ProductModel product) async {
    final response = await client.post(
      Uri.parse("https://fakestoreapi.com/products"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    return ProductModel.fromJson(jsonDecode(response.body));
  }

  Future<ProductModel> updateProduct(ProductModel product) async {
    final response = await client.put(
      Uri.parse("https://fakestoreapi.com/products/${product.id}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(product.toJson()),
    );
    return ProductModel.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteProduct(int id) async {
    await client.delete(Uri.parse("https://fakestoreapi.com/products/$id"));
  }
}
