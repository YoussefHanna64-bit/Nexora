class Product {
  final String id;
  final String name;
  final String brand;
  final String description;
  final num price;
  final num discount;
  final int stock;
  final int sold;
  final num ratingRate;
  final int ratingCount;
  final String categoryId;
  final String categoryName;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.description,
    required this.price,
    required this.discount,
    required this.stock,
    required this.sold,
    required this.ratingRate,
    required this.ratingCount,
    required this.categoryId,
    required this.categoryName,
    required this.thumbnail,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? 'Unknown Product',
      brand: json['brand'] ?? 'Unknown Brand',
      description: json['description'] ?? 'No description available.',
      price: json['price'] ?? 0,
      discount: json['discount'] ?? 0,
      stock: json['stock'] ?? 0,
      sold: json['sold'] ?? 0,
      ratingRate: json['rating']?['rate'] ?? 0,
      ratingCount: json['rating']?['count'] ?? 0,
      categoryId: json['category']['_id'] ?? '',
      categoryName: json['category']['name'] ?? 'Unknown Category',
      thumbnail: json['thumbnail'] ?? '',
      images: json['images'] != null ? List<String>.from(json['images']) : [],
    );
  }
}

class Rating {
  final double rate;
  final int count;

  Rating({required this.rate, required this.count});
}

class ProductModel {
  final String id;
  final String category;
  final String name;
  final String description;
  final Rating rating;
  final double price;
  final bool isFavorite;
  final double? discount;
  final List<String> imageUrls;

  ProductModel({
    required this.id,
    required this.category,
    required this.name,
    required this.description,
    required this.rating,
    required this.price,
    this.isFavorite = false,
    this.discount,
    required this.imageUrls,
  });
}

final List<ProductModel> dummyProducts = [
  ProductModel(
      id: '1',
      category: 'Electronics',
      name: 'Premium Wireless Headphones',
      description:
          'Experience unparalleled sound quality with our Premium Wireless Headphones. Featuring advanced noise-cancellation technology, a comfortable over-ear design, and up to 30 hours of battery life, these headphones are perfect for music lovers and professionals alike.',
      rating: Rating(rate: 4.8, count: 124),
      price: 299.99,
      isFavorite: true,
      discount: 20.0,
      imageUrls: [
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg',
        'https://i.imgur.com/yVeIeDa.jpeg'
      ]),
];
