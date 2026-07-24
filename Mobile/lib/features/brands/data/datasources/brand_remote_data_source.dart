import 'package:nexora/features/brands/data/models/brand_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class BrandRemoteDataSource {
  Future<List<BrandModel>> getBrands();
}

class BrandRemoteDataSourceImpl implements BrandRemoteDataSource {
  final ApiService apiService;

  BrandRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<BrandModel>> getBrands() async {
    final response = await apiService.get(EndPoints.brands);

    return getBrandsList(response.data);
  }

  List<BrandModel> getBrandsList(Map<String, dynamic> response) {
    final List<dynamic> brandsList = response["data"]["brands"] ?? [];

    return brandsList.map((brand) => BrandModel.fromJson(brand)).toList();
  }
}
