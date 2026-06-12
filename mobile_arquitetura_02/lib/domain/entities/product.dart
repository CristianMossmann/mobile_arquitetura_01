class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final String thumbnail;
  final String brand;
  final String category;
  final double rating;
  final bool isFavorite;

  const Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.thumbnail,
    this.brand = '',
    this.category = '',
    this.rating = 0.0,
    this.isFavorite = false,
  });

  Product copyWith({
    int? id,
    String? title,
    String? description,
    double? price,
    String? thumbnail,
    String? brand,
    String? category,
    double? rating,
    bool? isFavorite,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      thumbnail: thumbnail ?? this.thumbnail,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
