// candle_color_sample_widget.dart

import 'package:flutter/material.dart';

class ChangePercentSampleWidget extends StatelessWidget {
  const ChangePercentSampleWidget({
    super.key,
    this.isUpIcon,
    required this.sampleColor,
    required this.sampleText,
    required this.isPercentEnabled,
  });

  final bool? isUpIcon;
  final Color? sampleColor;
  final String sampleText;
  final bool? isPercentEnabled;

  @override
  Widget build(BuildContext context) {
    String priceText = isPercentEnabled == null
        ? ''
        : isPercentEnabled!
            ? sampleText
            : sampleText.replaceAll('%', '');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(
                priceText,
                style: TextStyle(
                  color: sampleColor,
                ),
              ),
              isUpIcon == null
                  ? Icon(
                      Icons.arrow_drop_up,
                      color: sampleColor,
                    )
                  : isUpIcon!
                      ? Icon(
                          Icons.arrow_drop_up,
                          color: sampleColor,
                        )
                      : Icon(
                          Icons.arrow_drop_down,
                          color: sampleColor,
                        )
            ],
          ),
        ),
      ],
    );
  }
}
