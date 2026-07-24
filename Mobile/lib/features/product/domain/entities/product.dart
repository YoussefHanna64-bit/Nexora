import 'package:nexora/features/brands/domain/entities/brand.dart';
import 'package:nexora/features/category/domain/entities/category.dart';

class Product {
  final String id;
  final String name;
  final String description;
  final Brand brand;
  final Category category;
  final num price;
  final num discount;
  final int stock;
  final int sold;
  final num ratingRate;
  final int ratingCount;
  final String thumbnail;
  final List<String> images;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.brand,
    required this.category,
    required this.price,
    required this.discount,
    required this.stock,
    required this.sold,
    required this.ratingRate,
    required this.ratingCount,
    required this.thumbnail,
    required this.images,
  });
}
