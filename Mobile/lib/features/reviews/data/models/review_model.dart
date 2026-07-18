import 'package:nexora/features/reviews/domain/entities/review.dart';

class ReviewModel extends Review {
  ReviewModel({
    super.id,
    required super.productId,
    required super.userId,
    required super.userName,
    super.userProfileImage,
    required super.rating,
    super.comment,
    required super.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json["_id"],
      productId: json["product"] ?? "",
      userId: json["user"]?["_id"] ?? "",
      userName: json["user"]?["fullname"] ?? "Nexora User",
      userProfileImage: json["user"]?["profileImage"],
      rating: json["rating"] ?? 0,
      comment: json["comment"],
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : DateTime.now(),
    );
  }

  factory ReviewModel.fromEntity(Review entity) {
    return ReviewModel(
      id: entity.id,
      productId: entity.productId,
      userId: entity.userId,
      userName: entity.userName,
      userProfileImage: entity.userProfileImage,
      rating: entity.rating,
      comment: entity.comment,
      createdAt: entity.createdAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product": productId,
      "rating": rating,
      if (comment != null) "comment": comment,
    };
  }
}
