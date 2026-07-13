import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/address/presentation/manager/address_state.dart';
import 'package:nexora/features/address/presentation/widgets/address_selection_sheet.dart';
import 'package:nexora/features/cart/presentation/manager/cart_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_cubit.dart';
import 'package:nexora/features/orders/presentation/manager/checkout/checkout_state.dart';
import 'package:nexora/features/orders/presentation/widgets/payment_method_tile.dart';
import 'package:nexora/features/address/presentation/widgets/shipping_address_card.dart';

class CheckoutView extends StatefulWidget {
  const CheckoutView({super.key});

  @override
  State<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends State<CheckoutView> {
  String selectedPaymentMethod = "card";
  ShippingAddress? selectedAddress;

  ShippingAddress? _findDefaultAddress(List<ShippingAddress> addresses) {
    if (addresses.isEmpty) {
      return null;
    }

    final defaultAddresses = addresses.where((addr) => addr.isDefault);
    return defaultAddresses.isNotEmpty
        ? defaultAddresses.first
        : addresses.first;
  }

  @override
  void initState() {
    super.initState();
    final addressCubit = context.read<AddressCubit>();

    if (addressCubit.state is AddressLoaded) {
      final loadedState = addressCubit.state as AddressLoaded;
      selectedAddress = _findDefaultAddress(loadedState.addresses);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressCubit>().fetchAddresses();
    });
  }

  void _openAddressSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        showDragHandle: true,
        builder: (context) {
          return AddressSelectionSheet(
            currentSelectedAddress: selectedAddress,
            onAddressSelected: (addr) => setState(() => selectedAddress = addr),
            onAddNewAddress: () {
              context.push(Routes.addEditAddress);
            },
          );
        });
  }

  void _placeOrder(AppLocalizations l10n) {
    if (selectedAddress == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(l10n.pleaseSelectAddressFirst),
            backgroundColor: AppColors.secondary),
      );
      return;
    }

    context.read<CheckoutCubit>().processCheckout(
          shippingAddress: selectedAddress!,
          paymentMethodType: selectedPaymentMethod,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      appBar: CustomAppBar(
        title: l10n.checkout,
        showBackButton: true,
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<AddressCubit, AddressState>(
            listener: (context, state) {
              if (state is AddressLoaded && selectedAddress == null) {
                final defaultAddr = _findDefaultAddress(state.addresses);

                if (defaultAddr != null) {
                  setState(() => selectedAddress = defaultAddr);
                }
              }
            },
          ),
          BlocListener<CheckoutCubit, CheckoutState>(
            listener: (context, state) {
              if (state is CheckoutError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.redColor));
              } else if (state is CheckoutSuccess) {
                context.read<CartCubit>().fetchCart();
                context.go(Routes.orderSuccess, extra: state.order);
              }
            },
          ),
        ],
        child: BlocBuilder<CheckoutCubit, CheckoutState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _shippingSection(onSurface, l10n),
                  const SizedBox(height: 32),
                  _paymentSection(onSurface, l10n),
                  const Spacer(),
                  CustomPrimaryButton(
                    buttonText: l10n.placeOrder,
                    onPressed: () => _placeOrder(l10n),
                    isLoading: state is CheckoutLoading,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _shippingSection(Color onSurface, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(l10n.shippingAddress,
                style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
            TextButton(onPressed: _openAddressSheet, child: Text(l10n.change)),
          ],
        ),
        if (selectedAddress != null)
          ShippingAddressCard(address: selectedAddress!)
        else
          Card(
            child: ListTile(
              leading:
                  const Icon(AppIcons.locationOff, color: AppColors.greyColor),
              title: Text(l10n.noAddressSelectedTitle),
              subtitle: Text(l10n.noAddressSelectedSubtitle),
              onTap: _openAddressSheet,
            ),
          ),
      ],
    );
  }

  Widget _paymentSection(Color onSurface, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.paymentMethod,
            style: AppTextStyles.bold18Black.copyWith(color: onSurface)),
        const SizedBox(height: 12),
        PaymentMethodTile(
          title: l10n.creditDebitCard,
          subtitle: l10n.stripeSubtitle,
          icon: AppIcons.creditCard,
          value: "card",
          groupValue: selectedPaymentMethod,
          onChanged: (val) => setState(() => selectedPaymentMethod = val!),
        ),
        const SizedBox(height: 8),
        PaymentMethodTile(
          title: l10n.cashOnDelivery,
          subtitle: l10n.codSubtitle,
          icon: AppIcons.money,
          value: "cash",
          groupValue: selectedPaymentMethod,
          onChanged: (val) => setState(() => selectedPaymentMethod = val!),
        ),
      ],
    );
  }
}
