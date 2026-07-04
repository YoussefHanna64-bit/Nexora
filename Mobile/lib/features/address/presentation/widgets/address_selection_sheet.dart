import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';
import 'package:nexora/core/widgets/custom_bottom_sheet_container.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/address/presentation/manager/address_state.dart';
import 'package:nexora/features/address/presentation/widgets/empty_address_state.dart';
import 'package:nexora/features/address/presentation/widgets/shipping_address_card.dart';

class AddressSelectionSheet extends StatelessWidget {
  final ShippingAddress? currentSelectedAddress;
  final Function(ShippingAddress) onAddressSelected;
  final VoidCallback onAddNewAddress;

  const AddressSelectionSheet(
      {super.key,
      this.currentSelectedAddress,
      required this.onAddressSelected,
      required this.onAddNewAddress});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return CustomBottomSheetContainer(
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Select Shipping Address",
                    style: AppTextStyles.bold18Black),
                IconButton(
                  icon: Icon(AppIcons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<AddressCubit, AddressState>(
                builder: (context, state) {
                  if (state is AddressError) {
                    return Center(
                      child: Text(
                        state.message,
                        style: const TextStyle(color: AppColors.redColor),
                      ),
                    );
                  }

                  if (state is AddressLoaded) {
                    if (state.addresses.isEmpty) {
                      return EmptyAddressState(
                        onAddPressed: () {
                          Navigator.pop(context);
                          onAddNewAddress();
                        },
                      );
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.separated(
                            itemCount: state.addresses.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final address = state.addresses[index];
                              final isSelected =
                                  currentSelectedAddress?.id == address.id;

                              return ShippingAddressCard(
                                address: address,
                                onTap: () {
                                  onAddressSelected(address);
                                  Navigator.pop(context);
                                },
                                trailing: isSelected
                                    ? const Icon(AppIcons.checkCircle,
                                        color: AppColors.primary)
                                    : null,
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        CustomPrimaryButton(
                            onPressed: () {
                              Navigator.pop(context);
                              onAddNewAddress();
                            },
                            isOutlined: true,
                            icon: AppIcons.add,
                            buttonText: l10n.addAddress),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
