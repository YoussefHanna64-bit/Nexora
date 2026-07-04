import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';

class CustomTextFormField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextStyle? hintStyle;
  final bool? showLabel;
  final Color? fillColor;
  final Color? cursorColor;
  final IconData? prefixIcon;
  final bool obscureText;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final double? width;
  final double? height;
  final String? Function(String?)? validator;
  final bool autoFocus;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.controller,
    this.showLabel = false,
    this.prefixIcon,
    this.obscureText = false,
    this.onTap,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.hintStyle,
    this.fillColor,
    this.cursorColor,
    this.width,
    this.height,
    required this.validator,
    this.autoFocus = false,
  });

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  late bool isSecure;

  @override
  void initState() {
    super.initState();
    isSecure = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final onSurface = colorScheme.onSurface;
    final surfaceColor = widget.fillColor ?? colorScheme.surface;
    final textStyle = AppTextStyles.regular14Black.copyWith(color: onSurface);

    return Container(
      width: widget.width,
      height: widget.height,
      alignment: Alignment.center,
      child: TextFormField(
        onChanged: widget.onChanged,
        autofocus: widget.autoFocus,
        style: textStyle,
        cursorColor: AppColors.primary,
        controller: widget.controller,
        obscureText: widget.obscureText ? isSecure : false,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: AppColors.greyColor, size: 24)
              : null,
          suffixIcon: widget.obscureText
              ? IconButton(
                  icon: isSecure
                      ? Icon(AppIcons.visibilityOff,
                          color: AppColors.greyColor, size: 24)
                      : const Icon(AppIcons.visibility,
                          color: AppColors.primary, size: 24),
                  onPressed: () {
                    setState(() {
                      isSecure = !isSecure;
                    });
                  },
                )
              : null,
          filled: true,
          fillColor: surfaceColor,
          enabledBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: AppColors.greyColor)),
          focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: AppColors.primary)),
          errorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: AppColors.redColor)),
          focusedErrorBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
              borderSide: BorderSide(color: AppColors.redColor)),
          errorStyle:
              AppTextStyles.regular14Black.copyWith(color: AppColors.redColor),
          hintText: widget.hintText,
          hintStyle: widget.hintStyle ??
              AppTextStyles.regular14Black
                  .copyWith(color: onSurface.withAlpha(102)),
          labelText: widget.showLabel == true ? widget.hintText : null,
          labelStyle: widget.showLabel == true
              ? AppTextStyles.regular14Black.copyWith(color: onSurface)
              : null,
        ),
        validator: widget.validator,
        readOnly: widget.onTap != null,
        onTap: widget.onTap,
      ),
    );
  }
}
