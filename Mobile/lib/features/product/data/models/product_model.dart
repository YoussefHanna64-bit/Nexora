import 'package:nexora/features/brands/data/models/brand_model.dart';
import 'package:nexora/features/category/data/models/category_model.dart';
import 'package:nexora/features/product/domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.category,
    required super.description,
    required super.price,
    required super.discount,
    required super.stock,
    required super.sold,
    required super.ratingRate,
    required super.ratingCount,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Unknown Product",
      brand: BrandModel.fromJson(json["brand"] ?? {}),
      category: CategoryModel.fromJson(json["category"] ?? {}),
      description: json["description"] ?? "No description available.",
      price: json["price"] ?? 0,
      discount: json["discount"] ?? 0,
      stock: json["stock"] ?? 0,
      sold: json["sold"] ?? 0,
      ratingRate: json["rating"]?["rate"] ?? 0,
      ratingCount: json["rating"]?["count"] ?? 0,
      thumbnail: json["thumbnail"] ?? "",
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
    );
  }
}
