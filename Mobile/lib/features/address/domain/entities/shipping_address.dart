class ShippingAddress {
  final String street;
  final String? apartment;
  final String city;
  final String postalCode;
  final String phone;

  ShippingAddress({
    required this.street,
    this.apartment,
    required this.city,
    required this.postalCode,
    required this.phone,
  });
}
