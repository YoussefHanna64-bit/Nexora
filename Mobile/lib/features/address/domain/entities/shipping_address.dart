class ShippingAddress {
  final String? id;
  final String street;
  final String? apartment;
  final String city;
  final String postalCode;
  final String phone;
  final String label;
  final bool isDefault;

  ShippingAddress({
    this.id,
    required this.street,
    this.apartment,
    required this.city,
    required this.postalCode,
    required this.phone,
    this.label = "Home",
    this.isDefault = false,
  });
}

ShippingAddress currentAddress = ShippingAddress(
  street: "Grove ST",
  apartment: "Grove",
  city: "Alex",
  postalCode: "21500",
  phone: "01234567891",
);
