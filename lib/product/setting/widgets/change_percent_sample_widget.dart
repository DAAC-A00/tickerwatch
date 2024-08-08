// candle_color_sample_widget.dart

import 'package:flutter/material.dart';

class ChangePercentSampleWidget extends StatelessWidget {
  const ChangePercentSampleWidget({
    super.key,
    required this.sampleIcon,
    required this.sampleColor,
    required this.sampleText,
    required this.isPercentEnabled,
  });

  final IconData sampleIcon;
  final Color sampleColor;
  final String sampleText;
  final bool isPercentEnabled;

  @override
  Widget build(BuildContext context) {
    String priceText =
        isPercentEnabled ? sampleText : sampleText.replaceAll('%', '');

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        children: [
          Text(
            priceText,
            style: TextStyle(
              color: sampleColor,
            ),
          ),
          Icon(
            sampleIcon,
            color: sampleColor,
          ),
        ],
      ),
    );
  }
}
