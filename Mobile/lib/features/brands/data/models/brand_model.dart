import 'package:nexora/features/brands/domain/entities/brand.dart';

class BrandModel extends Brand {
  BrandModel({
    required super.id,
    required super.name,
    required super.image,
  });

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json["_id"] ?? "",
      name: json["name"] ?? "Unknown Brand",
      image: json["image"] ?? "",
    );
  }
}
