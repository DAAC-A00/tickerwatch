// ticker_display_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/tickerdisplay/states/ticker_display_provider.dart';
import '../../tickers/states/ticker_provider.dart';

class TickerDisplayMainScreen extends ConsumerStatefulWidget {
  const TickerDisplayMainScreen({super.key});

  @override
  ConsumerState<TickerDisplayMainScreen> createState() =>
      _TickerDisplayMainScreenState();
}

class _TickerDisplayMainScreenState
    extends ConsumerState<TickerDisplayMainScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (BuildContext context) {
        final double paddingSize =
            Theme.of(context).textTheme.bodySmall?.fontSize ?? 20;
        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: paddingSize,
            horizontal: paddingSize * 2,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(''),
                const Text(
                  '개요',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('모니터링을 원하는 ticker 정보를 조회할 수 있습니다.'),
                const Text(
                  '\n주의사항',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('현재는 bybit spot 정보만 수집 및 저장하고 있습니다.'),
                const Text(''),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // 바텀 시트를 닫기
                  },
                  child: const Text('닫기'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final tickerDisplays = ref.watch(tickerDisplayProvider);
    final tickers = ref.watch(tickerProvider);

    // 검색된 tickerDisplay 리스트
    final filteredTickerDisplays = tickerDisplays.where((tickerDisplay) {
      return tickerDisplay.rawSymbol.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase()) ||
          tickerDisplay.exchangeRawCategoryEnum.name.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase());
    }).toList();

    // tickerDisplay에 기반하여 해당 ticker의 정보를 필터링
    final filteredTickerInfo = filteredTickerDisplays
        .map((tickerDisplay) {
          return tickers
              .where((ticker) =>
                  ticker.info.exchangeRawCategoryEnum ==
                      tickerDisplay.exchangeRawCategoryEnum &&
                  ticker.info.rawSymbol == tickerDisplay.rawSymbol)
              .toList();
        })
        .expand((element) => element)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: '검색',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear(); // 컨트롤러를 통해 입력값을 지웁니다.
                      setState(() {}); // 상태를 갱신하여 필터링
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoBottomSheet,
          ),
        ],
      ),
      body: filteredTickerInfo.isEmpty
          ? const Center(
              child: Text('검색 결과가 없습니다.'),
            )
          : ListView.builder(
              itemCount: filteredTickerInfo.length,
              itemBuilder: (context, index) {
                final ticker = filteredTickerInfo[index];
                return ListTile(
                  title: Text(
                      '${ticker.info.rawSymbol} ${ticker.info.exchangeRawCategoryEnum.name}'),
                  subtitle: Text(
                      '가격: ${ticker.price} / 변동률: ${ticker.changePercent24h}'),
                );
              },
            ),
    );
  }
}
