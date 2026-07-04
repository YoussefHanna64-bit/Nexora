import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class ShippingAddressModel extends ShippingAddress {
  ShippingAddressModel({
    super.id,
    required super.street,
    super.apartment,
    required super.city,
    required super.postalCode,
    required super.phone,
    required super.label,
    required super.isDefault,
  });

  factory ShippingAddressModel.fromJson(Map<String, dynamic> json) {
    return ShippingAddressModel(
      id: json["_id"],
      street: json["street"] ?? "",
      apartment: json["apartment"],
      city: json["city"] ?? "",
      postalCode: json["postalCode"] ?? "",
      phone: json["phone"] ?? "",
      label: json["label"] ?? "Home",
      isDefault: json["isDefault"] ?? false,
    );
  }

  factory ShippingAddressModel.fromEntity(ShippingAddress entity) {
    return ShippingAddressModel(
      id: entity.id,
      street: entity.street,
      apartment: entity.apartment,
      city: entity.city,
      postalCode: entity.postalCode,
      phone: entity.phone,
      label: entity.label,
      isDefault: entity.isDefault,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) "_id": id,
      "street": street,
      "apartment": apartment,
      "city": city,
      "postalCode": postalCode,
      "phone": phone,
      "label": label,
      "isDefault": isDefault,
    };
  }
}
