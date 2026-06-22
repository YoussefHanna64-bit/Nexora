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

ShippingAddress currentAddress = ShippingAddress(
  street: "Grove ST",
  apartment: "Grove",
  city: "Alex",
  postalCode: "21500",
  phone: "01234567891",
);
