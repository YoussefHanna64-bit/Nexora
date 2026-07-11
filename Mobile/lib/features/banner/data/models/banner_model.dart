import 'package:nexora/features/banner/domain/entities/banner.dart';

class BannerModel extends PromoBanner {
  BannerModel({
    required super.id,
    required super.title,
    required super.image,
    required super.type,
    required super.target,
    required super.isActive,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json["_id"] ?? "",
      title: json["title"] ?? "",
      image: json["image"] ?? "",
      type: json["type"] ?? "product",
      target: json["target"] ?? "",
      isActive: json["isActive"] ?? true,
    );
  }
}
