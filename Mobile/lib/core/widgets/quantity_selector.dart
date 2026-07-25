import 'package:flutter/material.dart';
import 'package:nexora/core/constants/app_icons.dart';
import 'package:nexora/core/theme/text_styles.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback? onRemove;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
    this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final isDeleteMode = quantity == 1 && onRemove != null;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: isDeleteMode
                ? onRemove
                : quantity > 1
                    ? onDecrement
                    : null,
            child: Icon(
                isDeleteMode ? AppIcons.deleteOutlined : AppIcons.remove,
                size: 20),
          ),
          SizedBox(width: 16),
          Text(
            quantity.toString(),
            style: AppTextStyles.bold16White.copyWith(
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(width: 16),
          GestureDetector(
            onTap: onIncrement,
            child: const Icon(AppIcons.add, size: 20),
          ),
        ],
      ),
    );
  }
}
