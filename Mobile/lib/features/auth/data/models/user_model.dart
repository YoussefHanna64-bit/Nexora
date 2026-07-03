import 'package:nexora/features/address/data/models/shipping_address_model.dart';
import 'package:nexora/features/auth/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    required super.id,
    required super.fullname,
    required super.email,
    required super.role,
    required super.addresses,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["_id"] ?? "",
      fullname: json["fullname"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "user",
      addresses: json["addresses"] != null
          ? (json["addresses"] as List)
              .map((addr) => ShippingAddressModel.fromJson(addr))
              .toList()
          : [],
    );
  }

  factory UserModel.fromEntity(User entity) {
    return UserModel(
      id: entity.id,
      fullname: entity.fullname,
      email: entity.email,
      role: entity.role,
      addresses: entity.addresses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "fullname": fullname,
      "email": email,
      "role": role,
      "addresses": addresses.map((addr) {
        if (addr is ShippingAddressModel) {
          return addr.toJson();
        } else {
          return ShippingAddressModel.fromEntity(addr).toJson();
        }
      }).toList(),
    };
  }
}
