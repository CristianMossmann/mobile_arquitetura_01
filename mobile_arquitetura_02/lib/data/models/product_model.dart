class ProductModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String brand;
  final String category;
  final double rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    required this.brand,
    required this.category,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    String thumbnail = (json['thumbnail'] ?? '').toString();
    if (thumbnail.isEmpty) {
      final images = json['images'];
      if (images is List && images.isNotEmpty) {
        thumbnail = images.first.toString();
      }
    }

    return ProductModel(
      id: (json['id'] ?? 0) as int,
      title: (json['title'] ?? '').toString(),
      description: (json['description'] ?? '').toString(),
      price: (json['price'] ?? 0).toDouble(),
      thumbnail: thumbnail,
      brand: (json['brand'] ?? '').toString(),
      category: (json['category'] ?? '').toString(),
      rating: (json['rating'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'thumbnail': thumbnail,
      'brand': brand,
      'category': category,
      'rating': rating,
    };
  }
}
