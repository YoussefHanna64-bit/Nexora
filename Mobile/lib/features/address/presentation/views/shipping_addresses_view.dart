import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/routers/routes.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/utils/mock_data.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/address/presentation/manager/address_state.dart';
import 'package:nexora/features/address/presentation/widgets/empty_address_state.dart';
import 'package:nexora/features/address/presentation/widgets/shipping_address_list.dart';
import 'package:skeletonizer/skeletonizer.dart';

class ShippingAddressesView extends StatefulWidget {
  const ShippingAddressesView({super.key});

  @override
  State<ShippingAddressesView> createState() => _ShippingAddressesViewState();
}

class _ShippingAddressesViewState extends State<ShippingAddressesView> {
  @override
  void initState() {
    super.initState();
    context.read<AddressCubit>().fetchAddresses();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.shippingAddresses, showBackButton: true),
      body: BlocConsumer<AddressCubit, AddressState>(
        listener: (context, state) {
          if (state is AddressError) {
            AppSnackbars.showError(context, state.message);
          }
        },
        builder: (context, state) {
          final bool isLoading = state is AddressLoading;

          final List<ShippingAddress> addresses = isLoading
              ? MockData.addresses
              : (state is AddressLoaded ? state.addresses : []);

          if (!isLoading && addresses.isEmpty) {
            return EmptyAddressState(onAddPressed: () {
              context.push(Routes.addEditAddress);
            });
          }

          return Skeletonizer(
              enabled: isLoading,
              child: ShippingAddressList(addresses: addresses));
        },
      ),
      floatingActionButton: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, state) {
          if (state is AddressLoaded && state.addresses.isNotEmpty) {
            return FloatingActionButton(
              onPressed: () {
                context.push(Routes.addEditAddress);
              },
              backgroundColor: AppColors.primary,
              child: const Icon(AppIcons.add, color: AppColors.whiteColor),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
