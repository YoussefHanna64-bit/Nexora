import 'package:nexora/core/models/category_model.dart';
import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryModel>> getCategories();
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final ApiService apiService;

  CategoryRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final response = await apiService.get(EndPoints.categories);

    return getCategoriesList(response.data);
  }

  List<CategoryModel> getCategoriesList(Map<String, dynamic> response) {
    final List<dynamic> categoriesList = response["data"]["categories"] ?? [];

    return categoriesList.map((cat) => CategoryModel.fromJson(cat)).toList();
  }
}
