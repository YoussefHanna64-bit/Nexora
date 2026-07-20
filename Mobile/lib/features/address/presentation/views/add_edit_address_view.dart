import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/utils/app_snackbars.dart';
import 'package:nexora/core/utils/validators.dart';
import 'package:nexora/core/widgets/custom_app_bar.dart';
import 'package:nexora/core/widgets/custom_primary_button.dart';
import 'package:nexora/core/widgets/custom_text_form_field.dart';
import 'package:nexora/features/address/domain/entities/shipping_address.dart';
import 'package:nexora/features/address/presentation/manager/address_cubit.dart';
import 'package:nexora/features/address/presentation/manager/address_state.dart';

class AddEditAddressView extends StatefulWidget {
  final ShippingAddress? address;

  const AddEditAddressView({super.key, this.address});

  @override
  State<AddEditAddressView> createState() => _AddEditAddressViewState();
}

class _AddEditAddressViewState extends State<AddEditAddressView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _streetController;
  late TextEditingController _apartmentController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _phoneController;

  String _label = "Home";
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    _streetController =
        TextEditingController(text: widget.address?.street ?? "");
    _apartmentController =
        TextEditingController(text: widget.address?.apartment ?? "");
    _cityController = TextEditingController(text: widget.address?.city ?? "");
    _postalCodeController =
        TextEditingController(text: widget.address?.postalCode ?? "");
    _phoneController = TextEditingController(text: widget.address?.phone ?? "");

    if (widget.address != null) {
      _label = widget.address!.label;
      _isDefault = widget.address!.isDefault;
    }
  }

  @override
  void dispose() {
    _streetController.dispose();
    _apartmentController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate()) {
      final newAddress = ShippingAddress(
        id: widget.address?.id,
        street: _streetController.text.trim(),
        apartment: _apartmentController.text.trim(),
        city: _cityController.text.trim(),
        postalCode: _postalCodeController.text.trim(),
        phone: _phoneController.text.trim(),
        isDefault: _isDefault,
        label: _label,
      );

      if (widget.address == null) {
        context.read<AddressCubit>().addAddress(newAddress);
      } else {
        context.read<AddressCubit>().updateAddress(newAddress.id!, newAddress);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final isEditing = widget.address != null;

    return Scaffold(
        appBar: CustomAppBar(
          title: isEditing ? l10n.editAddress : l10n.addAddress,
          showBackButton: true,
        ),
        body: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
          _addressBlocListener(context, state, l10n);
        }, builder: (context, state) {
          final isLoading = state is AddressLoading;

          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(children: [
                    _labelSelector(l10n),
                    const SizedBox(height: 24),
                    CustomTextFormField(
                      hintText: l10n.streetAddress,
                      showLabel: true,
                      controller: _streetController,
                      validator: (val) => Validators.street(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                        hintText: l10n.aptOptional,
                        showLabel: true,
                        controller: _apartmentController,
                        validator: null),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: l10n.city,
                      showLabel: true,
                      controller: _cityController,
                      validator: (val) => Validators.city(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: l10n.postalCode,
                      showLabel: true,
                      controller: _postalCodeController,
                      keyboardType: TextInputType.number,
                      validator: (val) => Validators.postalCode(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: l10n.phoneNumber,
                      showLabel: true,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => Validators.phone(context, val),
                    ),
                    const SizedBox(height: 24),
                    _defaultAddressSwitch(l10n),
                    const SizedBox(height: 40),
                    CustomPrimaryButton(
                      onPressed: isLoading ? () {} : _onSubmit,
                      buttonText:
                          isEditing ? l10n.saveChanges : l10n.addAddress,
                      isLoading: isLoading,
                    ),
                  ])));
        }));
  }

  void _addressBlocListener(
      BuildContext context, AddressState state, AppLocalizations l10n) {
    final isEditing = widget.address != null;
    if (state is AddressLoaded) {
      Navigator.pop(context);
      AppSnackbars.showSuccess(
        context,
        isEditing ? l10n.addressUpdated : l10n.addressAdded,
      );
    } else if (state is AddressError) {
      AppSnackbars.showError(context, state.message);
    }
  }

  Widget _labelSelector(AppLocalizations l10n) {
    final Map<String, String> labels = {
      "Home": l10n.homeLabel,
      "Work": l10n.workLabel,
      "Other": l10n.otherLabel,
    };

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.entries.map((entry) {
        final isSelected = _label == entry.key;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomPrimaryButton(
              outlineColor:
                  isSelected ? AppColors.primary : AppColors.greyColor,
              buttonText: entry.value,
              isOutlined: !isSelected,
              height: 46,
              onPressed: () {
                setState(() {
                  _label = entry.key;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _defaultAddressSwitch(AppLocalizations l10n) {
    return SwitchListTile(
      title: Text(l10n.makeDefaultAddress),
      subtitle: Text(l10n.fastCheckoutSubtitle),
      value: _isDefault,
      activeColor: AppColors.primary,
      onChanged: (val) {
        setState(() {
          _isDefault = val;
        });
      },
      contentPadding: EdgeInsets.zero,
    );
  }
}
