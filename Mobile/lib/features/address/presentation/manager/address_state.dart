import 'package:nexora/features/address/domain/entities/shipping_address.dart';

abstract class AddressState {}

class AddressInitial extends AddressState {}

class AddressLoading extends AddressState {}

class AddressLoaded extends AddressState {
  final List<ShippingAddress> addresses;

  AddressLoaded(this.addresses);
}

class AddressError extends AddressState {
  final String message;

  AddressError(this.message);
}
