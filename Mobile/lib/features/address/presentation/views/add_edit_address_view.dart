import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nexora/core/theme/colors.dart';
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
    final isEditing = widget.address != null;

    return Scaffold(
        appBar: CustomAppBar(
          title: isEditing ? "Edit Address" : "Add Address",
          showBackButton: true,
        ),
        body: BlocConsumer<AddressCubit, AddressState>(
            listener: (context, state) {
          _addressBlocListener(context, state);
        }, builder: (context, state) {
          final isLoading = state is AddressLoading;

          return Form(
              key: _formKey,
              child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Column(children: [
                    _labelSelector(),
                    const SizedBox(height: 24),
                    CustomTextFormField(
                      hintText: "Street Address",
                      showLabel: true,
                      controller: _streetController,
                      validator: (val) => Validators.street(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                        hintText: "Apt (Optional)",
                        showLabel: true,
                        controller: _apartmentController,
                        validator: null),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: "City",
                      showLabel: true,
                      controller: _cityController,
                      validator: (val) => Validators.city(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: "Postal Code",
                      showLabel: true,
                      controller: _postalCodeController,
                      keyboardType: TextInputType.number,
                      validator: (val) => Validators.postalCode(context, val),
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      hintText: "Phone Number",
                      showLabel: true,
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      validator: (val) => Validators.phone(context, val),
                    ),
                    const SizedBox(height: 24),
                    _defaultAddressSwitch(),
                    const SizedBox(height: 40),
                    CustomPrimaryButton(
                      onPressed: isLoading ? () {} : _onSubmit,
                      buttonText: isEditing ? "Save Changes" : "Add Address",
                      isLoading: isLoading,
                    ),
                  ])));
        }));
  }

  void _addressBlocListener(BuildContext context, AddressState state) {
    final isEditing = widget.address != null;
    if (state is AddressLoaded) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isEditing ? "Address updated" : "Address added"),
          backgroundColor: AppColors.primary,
        ),
      );
    } else if (state is AddressError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(state.message),
          backgroundColor: AppColors.redColor,
        ),
      );
    }
  }

  Widget _labelSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: ["Home", "Work", "Other"].map((label) {
        final isSelected = _label == label;
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: CustomPrimaryButton(
              outlineColor:
                  isSelected ? AppColors.primary : AppColors.greyColor,
              buttonText: label,
              isOutlined: !isSelected,
              height: 46,
              onPressed: () {
                setState(() {
                  _label = label;
                });
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _defaultAddressSwitch() {
    return SwitchListTile(
      title: const Text("Make this my default address"),
      subtitle: const Text("Used automatically for fast checkout"),
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
