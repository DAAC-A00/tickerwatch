// division_space_widget.dart

import 'package:flutter/material.dart';

class DivisionSpaceWidget extends StatelessWidget {
  const DivisionSpaceWidget({
    super.key,
    required this.size,
  });

  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: size * 0.03);
  }
}
