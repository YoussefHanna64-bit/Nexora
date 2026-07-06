import 'package:nexora/core/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.brand,
    required super.description,
    required super.price,
    required super.discount,
    required super.stock,
    required super.sold,
    required super.ratingRate,
    required super.ratingCount,
    required super.categoryId,
    required super.categoryName,
    required super.thumbnail,
    required super.images,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Unknown Product",
      brand: json["brand"] ?? "Unknown Brand",
      description: json["description"] ?? "No description available.",
      price: json["price"] ?? 0,
      discount: json["discount"] ?? 0,
      stock: json["stock"] ?? 0,
      sold: json["sold"] ?? 0,
      ratingRate: json["rating"]?["rate"] ?? 0,
      ratingCount: json["rating"]?["count"] ?? 0,
      categoryId: json["category"]?["_id"] ?? "",
      categoryName: json["category"]?["name"] ?? "Unknown Category",
      thumbnail: json["thumbnail"] ?? "",
      images: json["images"] != null ? List<String>.from(json["images"]) : [],
    );
  }
}
