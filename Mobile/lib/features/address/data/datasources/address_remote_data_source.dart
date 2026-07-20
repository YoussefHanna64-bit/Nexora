import 'package:nexora/core/network/api_service.dart';
import 'package:nexora/core/network/end_points.dart';
import 'package:nexora/features/address/data/models/shipping_address_model.dart';

abstract class AddressRemoteDataSource {
  Future<List<ShippingAddressModel>> getAddresses();
  Future<List<ShippingAddressModel>> addAddress(ShippingAddressModel address);
  Future<List<ShippingAddressModel>> updateAddress(
      String addrId, ShippingAddressModel address);
  Future<List<ShippingAddressModel>> removeAddress(String addrId);
}

class AddressRemoteDataSourceImpl implements AddressRemoteDataSource {
  final ApiService apiService;

  AddressRemoteDataSourceImpl(this.apiService);

  @override
  Future<List<ShippingAddressModel>> getAddresses() async {
    final response = await apiService.get(EndPoints.addresses);

    return getAddressesList(response.data);
  }

  @override
  Future<List<ShippingAddressModel>> addAddress(
      ShippingAddressModel address) async {
    final response =
        await apiService.post(EndPoints.addresses, body: address.toJson());
    return getAddressesList(response.data);
  }

  @override
  Future<List<ShippingAddressModel>> updateAddress(
      String addrId, ShippingAddressModel address) async {
    final response = await apiService.patch(
      "${EndPoints.addresses}/$addrId",
      body: address.toJson(),
    );
    return getAddressesList(response.data);
  }

  @override
  Future<List<ShippingAddressModel>> removeAddress(String addrId) async {
    final response = await apiService.delete("${EndPoints.addresses}/$addrId");
    return getAddressesList(response.data);
  }

  List<ShippingAddressModel> getAddressesList(Map<String, dynamic> response) {
    final List<dynamic> addressList = response["data"]["addresses"] ?? [];

    return addressList.map((b) => ShippingAddressModel.fromJson(b)).toList();
  }
}
