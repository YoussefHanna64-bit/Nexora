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
}
