import 'package:nexora/features/category/domain/entities/category.dart';

class CategoryModel extends Category {
  CategoryModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Unknown Category",
      image: json["image"] ?? "",
    );
  }
}
