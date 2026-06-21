import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class ShippingAddressModel extends ShippingAddress {
  ShippingAddressModel({
    required super.street,
    super.apartment,
    required super.city,
    required super.postalCode,
    required super.phone,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      street: json['street'] ?? '',
      apartment: json['apartment'],
      city: json['city'] ?? '',
      postalCode: json['postalCode'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}
