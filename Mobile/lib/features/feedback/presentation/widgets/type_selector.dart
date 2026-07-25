import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TypeSelector extends StatelessWidget {
  final String selectedType;
  final ValueChanged<String>? onTypeSelected;

  const TypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final List<({String value, String label})> types = [
      (value: "bug", label: l10n.typeBug),
      (value: "feedback", label: l10n.typeFeedback),
      (value: "question", label: l10n.typeQuestion),
    ];

    return Wrap(
      spacing: 8,
      children: types.map((t) {
        final isSelected = selectedType == t.value;

        return ChoiceChip(
          label: Text(t.label),
          selected: isSelected,
          selectedColor: AppColors.primary,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.whiteColor : AppColors.greyColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).dividerColor,
            ),
          ),
          onSelected: onTypeSelected == null
              ? null
              : (v) {
                  onTypeSelected!(t.value);
                },
        );
      }).toList(),
    );
  }
}
