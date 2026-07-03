import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class ProfileRemoteDataSource {
  Future<Map<String, dynamic>> getUserProfile();
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data);
  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data);
  Future<Map<String, dynamic>> deleteAccount();
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiService apiService;

  ProfileRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> getUserProfile() async {
    final response = await apiService.get(EndPoints.me);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await apiService.patch(EndPoints.updateUser, body: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> updatePassword(Map<String, dynamic> data) async {
    final response =
        await apiService.patch(EndPoints.updatePassword, body: data);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> deleteAccount() async {
    final response = await apiService.delete(EndPoints.users);
    return response.data;
  }
}
