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
  factory ShippingAddressModel.fromEntity(ShippingAddress entity) {
    return ShippingAddressModel(
      street: entity.street,
      apartment: entity.apartment,
      city: entity.city,
      postalCode: entity.postalCode,
      phone: entity.phone,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "street": street,
      "apartment": apartment,
      "city": city,
      "postalCode": postalCode,
      "phone": phone,
    };
  }
}
