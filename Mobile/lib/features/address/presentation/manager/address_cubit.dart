import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/domain/usecases/add_address_use_case.dart';
import 'package:nexora/features/address/domain/usecases/get_addresses_use_case.dart';
import 'package:nexora/features/address/domain/usecases/remove_address_use_case.dart';
import 'package:nexora/features/address/domain/usecases/update_address_use_case.dart';
import 'package:nexora/features/address/presentation/manager/address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  final GetAddressesUseCase getAddressesUseCase;
  final AddAddressUseCase addAddressUseCase;
  final UpdateAddressUseCase updateAddressUseCase;
  final RemoveAddressUseCase removeAddressUseCase;

  AddressCubit(this.getAddressesUseCase, this.addAddressUseCase,
      this.updateAddressUseCase, this.removeAddressUseCase)
      : super(AddressInitial());

  Future<void> fetchAddresses() async {
    emit(AddressLoading());

    final result = await getAddressesUseCase();

    result.fold(
      (failure) {
        emit(AddressError(failure.message));
      },
      (addresses) {
        emit(AddressLoaded(addresses));
      },
    );
  }

  Future<void> addAddress(ShippingAddress address) async {
    emit(AddressLoading());

    final result = await addAddressUseCase(address);

    result.fold(
      (failure) {
        emit(AddressError(failure.message));
      },
      (addresses) {
        emit(AddressLoaded(addresses));
      },
    );
  }

  Future<void> updateAddress(String addrId, ShippingAddress address) async {
    emit(AddressLoading());

    final result = await updateAddressUseCase(addrId: addrId, address: address);

    result.fold(
      (failure) {
        emit(AddressError(failure.message));
      },
      (addresses) {
        emit(AddressLoaded(addresses));
      },
    );
  }

  Future<void> removeAddress(String addrId) async {
    emit(AddressLoading());

    final result = await removeAddressUseCase(addrId);

    result.fold(
      (failure) {
        emit(AddressError(failure.message));
      },
      (addresses) {
        emit(AddressLoaded(addresses));
      },
    );
  }
}
