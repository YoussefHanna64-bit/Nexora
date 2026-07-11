import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class BannerRemoteDataSource {
  Future<Map<String, dynamic>> getActiveBanners();
}

class BannerRemoteDataSourceImpl implements BannerRemoteDataSource {
  final ApiService apiService;

  BannerRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getActiveBanners() async {
    final response = await apiService.get(EndPoints.activeBanners);
    return response.data;
  }
}
