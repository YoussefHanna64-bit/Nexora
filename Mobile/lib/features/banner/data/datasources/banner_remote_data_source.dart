import 'package:nexora/features/banner/data/models/banner_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class BannerRemoteDataSource {
  Future<List<BannerModel>> getActiveBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiService apiService;

  BannerRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<BannerModel>> getActiveBanners() async {
    final response = await apiService.get(EndPoints.activeBanners);

    return getBannersList(response.data);
  }

  List<BannerModel> getBannersList(Map<String, dynamic> response) {
    final List<dynamic> bannersList = response["data"]["banners"] ?? [];

    return bannersList.map((b) => BannerModel.fromJson(b)).toList();
  }
}
