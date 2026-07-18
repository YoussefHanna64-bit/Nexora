import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/reviews/data/models/review_model.dart';
import 'package:nexora/features/reviews/domain/usecases/params/review_params.dart';

abstract class ReviewRemoteDataSource {
  Future<List<ReviewModel>> getProductReviews(String productId);
  Future<ReviewModel> addReview(ReviewParams reviewParams);
  Future<ReviewModel> updateReview(String reviewId, ReviewParams reviewParams);
  Future<void> deleteReview(String reviewId);
}

class ReviewRemoteDataSourceImpl implements ReviewRemoteDataSource {
  final ApiService apiService;

  ReviewRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ReviewModel>> getProductReviews(String productId) async {
    final response = await apiService.get("${EndPoints.reviews}/$productId");

    return getReviewsList(response.data);
  }

  @override
  Future<ReviewModel> addReview(ReviewParams reviewParams) async {
    final response =
        await apiService.post(EndPoints.reviews, body: reviewParams.toJson());

    return getReview(response.data);
  }

  @override
  Future<ReviewModel> updateReview(
      String reviewId, ReviewParams reviewParams) async {
    final response = await apiService.patch("${EndPoints.reviews}/$reviewId",
        body: reviewParams.toJson());

    return getReview(response.data);
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    await apiService.delete("${EndPoints.reviews}/$reviewId");
  }

  ReviewModel getReview(Map<String, dynamic> response) {
    return ReviewModel.fromJson(response["data"]["review"]);
  }

  List<ReviewModel> getReviewsList(Map<String, dynamic> response) {
    final List<dynamic> reviewsList = response["data"]["reviews"] ?? [];

    return reviewsList.map((r) => ReviewModel.fromJson(r)).toList();
  }
}
