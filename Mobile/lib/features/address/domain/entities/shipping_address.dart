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

  static List<ShippingAddress> get mockAddresses => List.generate(
      3,
      (index) => ShippingAddress(
            id: index.toString(),
            label: "Home",
            street: "Grove ST",
            apartment: "Grove",
            city: "Alex",
            postalCode: "21500",
            phone: "01234567891",
            isDefault: index == 0,
          ));
}
