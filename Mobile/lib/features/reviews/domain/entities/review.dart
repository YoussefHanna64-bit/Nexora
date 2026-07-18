class Review {
  final String id;
  final String productId;
  final String userId;
  final String userName;
  final String? userProfileImage;
  final num rating;
  final String? comment;
  final DateTime createdAt;

  Review({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userProfileImage,
    required this.rating,
    this.comment,
    required this.createdAt,
  });
}
