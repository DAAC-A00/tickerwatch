// ticker_display_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/info_bottom_sheet.dart';
import 'package:tickerwatch/product/tickerdisplay/states/ticker_display_provider.dart';
import '../../tickers/states/ticker_provider.dart';
import 'add_ticker_display_screen.dart';

class TickerDisplayMainScreen extends ConsumerStatefulWidget {
  const TickerDisplayMainScreen({super.key});

  @override
  ConsumerState<TickerDisplayMainScreen> createState() =>
      _TickerDisplayMainScreenState();
}

class _TickerDisplayMainScreenState
    extends ConsumerState<TickerDisplayMainScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> contentList = [
    '개요',
    '등록한 ticker의 실시간 정보를 모니터링할 수 있습니다.',
    '순서 변경 방법',
    '꾹 누른 후 위치를 옮겨 순서를 변경할 수 있습니다. 단, 검색어가 입력된 상태에서는 순서를 변경할 수 없습니다.',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _navigateToAddTickerDisplay() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddTickerDisplayScreen()),
    ); // 추가하기 화면으로 이동
  }

  @override
  Widget build(BuildContext context) {
    final tickerDisplaysList = ref.watch(tickerDisplayProvider);
    final tickerDisplayNotifier = ref.read(tickerDisplayProvider.notifier);
    final tickers = ref.watch(tickerProvider);

    // 검색된 tickerDisplay 리스트
    final filteredTickerDisplays = tickerDisplaysList.where((tickerDisplay) {
      return tickerDisplay.rawSymbol.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase()) ||
          tickerDisplay.exchangeRawCategoryEnum.name.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase());
    }).toList();

    // tickerDisplay에 기반하여 해당 ticker의 정보를 필터링
    final tickerInfoList = tickerDisplaysList
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

    // tickerDisplay에 기반하여 해당 ticker의 정보를 필터링
    final filteredTickerInfoList = filteredTickerDisplays
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
                      _searchController.clear();
                      setState(() {});
                    },
                  )
                : null,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoBottomSheet(context, contentList),
          ),
        ],
      ),
      body: tickerInfoList.isEmpty
          ? const Center(
              child: Text('검색 결과가 없습니다.'),
            )
          : _searchController.text.isEmpty
              ? ReorderableListView.builder(
                  itemCount: tickerInfoList.length,
                  itemBuilder: (context, index) {
                    final ticker = tickerInfoList[index];
                    return ListTile(
                      key: ValueKey(
                          '${ticker.info.exchangeRawCategoryEnum.name}_${ticker.info.rawSymbol}_${ticker.updatedAt}'), // 키 설정
                      title: Text(
                          '${ticker.info.rawSymbol} ${ticker.info.exchangeRawCategoryEnum.name}'),
                      subtitle: Text(
                          '가격: ${ticker.price} / 변동률: ${ticker.changePercent24h}'),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    // 상태 업데이트를 위해 tickerDisplayProvider에 순서 변경을 반영
                    tickerDisplayNotifier.updateOrderBox(oldIndex, newIndex);
                    setState(() {});
                  },
                )
              : ListView.builder(
                  itemCount: filteredTickerInfoList.length,
                  itemBuilder: (context, index) {
                    final ticker = filteredTickerInfoList[index];
                    return ListTile(
                      title: Text(
                          '${ticker.info.rawSymbol} ${ticker.info.exchangeRawCategoryEnum.name}'),
                      subtitle: Text(
                          '가격: ${ticker.price} / 변동률: ${ticker.changePercent24h}'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddTickerDisplay,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
