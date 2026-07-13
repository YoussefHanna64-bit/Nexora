import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class User {
  final String id;
  final String fullname;
  final String email;
  final String role;
  final String? profileImage;
  final List<ShippingAddress> addresses;

  User({
    required this.id,
    required this.fullname,
    required this.email,
    required this.role,
    this.profileImage,
    required this.addresses,
  });
}
