class ReviewParams {
  final String productId;
  final double rating;
  final String? comment;

  ReviewParams({
    required this.productId,
    required this.rating,
    this.comment,
  });

  Map<String, dynamic> toJson() {
    return {
      "productId": productId,
      "rating": rating,
      if (comment != null && comment!.trim().isNotEmpty) "comment": comment,
    };
  }
}
