// price_sample_widget.dart

import 'package:flutter/material.dart';

class PriceSampleWidget extends StatelessWidget {
  final String sampleText;
  final Color? color;
  final bool? isQuoteUnitEnabled;
  final bool? isBorderEnabled;

  const PriceSampleWidget({
    super.key,
    required this.sampleText,
    required this.color,
    required this.isQuoteUnitEnabled,
    required this.isBorderEnabled,
  });

  @override
  Widget build(BuildContext context) {
    String changePercentText = isQuoteUnitEnabled != null
        ? isQuoteUnitEnabled!
            ? sampleText
            : sampleText.replaceAll('\$ ', '')
        : '';

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
              border: isBorderEnabled != null
                  ? isBorderEnabled!
                      ? Border.all(
                          color: color != null
                              ? color!
                              : Colors.transparent.withOpacity(0))
                      : Border.all(color: Colors.transparent.withOpacity(0))
                  : Border.all(),
            ), // Apply decoration conditionally
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
