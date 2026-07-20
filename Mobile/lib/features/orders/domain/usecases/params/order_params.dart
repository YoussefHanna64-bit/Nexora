import 'package:nexora/features/address/data/models/shipping_address_model.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';

class CreateOrderParams {
  final ShippingAddress shippingAddress;
  final String paymentMethodType;

  CreateOrderParams({
    required this.shippingAddress,
    required this.paymentMethodType,
  });

  Map<String, dynamic> toJson() {
    return {
      "shippingAddress":
          ShippingAddressModel.fromEntity(shippingAddress).toJson(),
      "paymentMethodType": paymentMethodType,
    };
  }
}
