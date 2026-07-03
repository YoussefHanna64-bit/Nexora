import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';

abstract class AddressRemoteDataSource {
  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> addressData);
  Future<Map<String, dynamic>> updateAddress(
      String addrId, Map<String, dynamic> addressData);
  Future<Map<String, dynamic>> removeAddress(String addrId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService apiService;

  AddressRemoteDataSourceImpl(this.apiService);

  @override
  Future<Map<String, dynamic>> addAddress(
      Map<String, dynamic> addressData) async {
    final response =
        await apiService.post(EndPoints.addresses, body: addressData);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> updateAddress(
      String addrId, Map<String, dynamic> addressData) async {
    final response = await apiService.patch("${EndPoints.addresses}/$addrId",
        body: addressData);
    return response.data;
  }

  @override
  Future<Map<String, dynamic>> removeAddress(String addrId) async {
    final response = await apiService.delete("${EndPoints.addresses}/$addrId");
    return response.data;
  }
}
