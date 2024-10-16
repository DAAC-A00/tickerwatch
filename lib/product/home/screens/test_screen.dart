// test_screen.dart

import 'package:flutter/material.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  final List<bool> _borderVisible = [false, false, false, false];

  @override
  void initState() {
    super.initState();
    _startBorderAnimation();
  }

  void _startBorderAnimation() {
    for (int i = 0; i < _borderVisible.length; i++) {
      Future.delayed(Duration(milliseconds: 500 * i), () {
        _animateBorder(i);
      });
    }
  }

  void _animateBorder(int index) {
    setState(() {
      _borderVisible[index] = true; // 테두리 보이기
    });

    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _borderVisible[index] = false; // 0.5초 후에 테두리 숨기기
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (index) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: BoxDecoration(
            border: Border.all(
              color: _borderVisible[index] ? Colors.blue : Colors.transparent,
              width: 2,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Text('Example Text ${index + 1}'),
        );
      }),
    );
  }
}
