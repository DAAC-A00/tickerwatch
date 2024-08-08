import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ChangeTitleWidget extends StatelessWidget {
  const ChangeTitleWidget({
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
    String changePercentText =
        isPercentEnabled ? sampleText : sampleText.replaceAll('%', '');

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const FittedBox(
          fit: BoxFit.scaleDown,
          child: Text("Change"),
        ),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            children: [
              Text(
                changePercentText,
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
        ),
      ],
    );
  }
}
