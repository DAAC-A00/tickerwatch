// price_sample_widget.dart

import 'package:flutter/material.dart';

class PriceSampleWidget extends StatelessWidget {
  final String sampleText;
  final Color color;
  final bool isQuoteUnitEnabled;
  final bool isBorderEnabled;
  final double baseSize;

  const PriceSampleWidget({
    super.key,
    required this.sampleText,
    required this.color,
    required this.isQuoteUnitEnabled,
    required this.isBorderEnabled,
    required this.baseSize,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = Theme.of(context).colorScheme;

    String changePercentText =
        isQuoteUnitEnabled ? sampleText : sampleText.replaceAll('\$ ', '');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text('price'),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            decoration: BoxDecoration(
                border: isBorderEnabled
                    ? Border.all(color: color)
                    : Border.all(
                        color: currentTheme.primary
                            .withOpacity(0))), // Apply decoration conditionally
            child: Text(
              changePercentText,
              style: TextStyle(
                // fontWeight: FontWeight.normal,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
