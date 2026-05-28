import 'package:flutter/material.dart';
import 'package:nexora/core/theme/colors.dart';

class PriceRangeSlider extends StatelessWidget {
  final RangeValues currentRange;
  final double max;
  final ValueChanged<RangeValues> onChanged;

  const PriceRangeSlider(
      {super.key,
      required this.currentRange,
      required this.max,
      required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return RangeSlider(
      values: currentRange,
      min: 0,
      max: max,
      divisions: 20,
      activeColor: AppColors.primary,
      inactiveColor: Theme.of(context).dividerColor,
      labels: RangeLabels(
        '\$${currentRange.start.round()}',
        '\$${currentRange.end.round()}',
      ),
      onChanged: onChanged,
    );
  }
}
