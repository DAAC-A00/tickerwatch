// image_test_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';

class ImageTestScreen extends ConsumerStatefulWidget {
  const ImageTestScreen({super.key});

  @override
  ConsumerState<ImageTestScreen> createState() => _ImageTestScreenState();
}

class _ImageTestScreenState extends ConsumerState<ImageTestScreen> {
  @override
  Widget build(BuildContext context) {
    final currentTextTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Test'),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: const Text(
                    'CategoryExchangeEnum',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '성공',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: Text(
                      '실패',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: const Text('Spot Bybit'),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                        height: currentTextTheme.titleMedium?.fontSize,
                        child: CategoryExchangeEnum.spotBybit.logoImage),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Center(
                    child: SizedBox(
                        height: currentTextTheme.titleMedium?.fontSize,
                        child: CategoryExchangeEnum.none.logoImage),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
