import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:nexora/core/theme/text_styles.dart';


class CustomPrimaryButton extends StatefulWidget {
  final String buttonText;
  final Color? fillColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final bool isLoading;

  const CustomPrimaryButton({
    super.key,
    required this.buttonText,
    this.fillColor,
    this.width = double.infinity,
    this.height,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  State<CustomPrimaryButton> createState() => _CustomPrimaryButtonState();
}

class _CustomPrimaryButtonState extends State<CustomPrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:widget.width??double.infinity,
      height: widget.height,
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(widget.isLoading
              ? AppColors.greyColor
              : AppColors.primary),
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
        onPressed: widget.isLoading ? null : widget.onPressed,
        child: widget.isLoading
            ? const CircularProgressIndicator(
          color: AppColors.whiteColor,
          strokeWidth: 2,
        )
            : Text(widget.buttonText, style: AppTextStyles.bold16White),
      ),
    );
  }
}
