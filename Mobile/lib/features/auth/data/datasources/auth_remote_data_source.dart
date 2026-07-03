import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> login(String email, String password);
  Future<Map<String, dynamic>> register(
      String fullname, String email, String password, String passwordConfirm);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiService apiService;

  AuthRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await apiService.post(
      EndPoints.login,
      body: {
        "email": email,
        "password": password,
      },
    );
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> register(String fullname, String email,
      String password, String passwordConfirm) async {
    final response = await apiService.post(
      EndPoints.register,
      body: {
        "fullname": fullname,
        "email": email,
        "password": password,
        "passwordConfirm": passwordConfirm
      },
    );
    return response.data;
  }
}
