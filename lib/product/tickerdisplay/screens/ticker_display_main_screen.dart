// ticker_display_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/info_bottom_sheet.dart';
import 'package:tickerwatch/product/setting/states/ticker_setting_provider.dart';
import 'package:tickerwatch/product/tickerdisplay/entities/ticker_display_entity.dart';
import 'package:tickerwatch/product/tickerdisplay/states/ticker_display_provider.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';
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
    final tickerDisplay = ref.watch(tickerDisplayProvider);
    final tickerDisplayNotifier = ref.read(tickerDisplayProvider.notifier);
    final tickers = ref.watch(tickerProvider);
    final tickerSetting = ref.watch(tickerSettingProvider);
    final Color? upColor = tickerSetting.upColor;
    final Color? downColor = tickerSetting.downColor;

    // 검색된 tickerDisplay 리스트
    final List<TickerDisplayEntity> filteredTickerDisplays =
        tickerDisplay.where((tickerDisplay) {
      return tickerDisplay.searchKeywords.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase()) ||
          tickerDisplay.categoryExchangeEnum.name.toLowerCase().contains(
              _searchController.text.replaceAll(' ', '').toLowerCase());
    }).toList();

    // tickerDisplay에 기반하여 해당 ticker의 정보를 필터링
    final List<TickerEntity> filteredTickerList = filteredTickerDisplays
        .map((tickerDisplay) {
          return tickers
              .where((ticker) =>
                  ticker.info.categoryExchangeEnum ==
                      tickerDisplay.categoryExchangeEnum &&
                  ticker.info.symbol == tickerDisplay.symbol)
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
      body: filteredTickerList.isEmpty
          ? const Center(
              child: Text('검색 결과가 없습니다.'),
            )
          : _searchController.text.isEmpty
              ? ReorderableListView.builder(
                  itemCount: filteredTickerList.length,
                  itemBuilder: (context, index) {
                    final ticker = filteredTickerList[index];
                    final tickerDisplay = filteredTickerDisplays[index];
                    return ListTile(
                      key: ValueKey('${tickerDisplay.createdAt}'),
                      title: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft, // 왼쪽 정렬
                              child: FittedBox(
                                fit: BoxFit.scaleDown, // 공간에 맞게 자동으로 크기를 조정
                                child: Text(
                                  '${ticker.info.symbol} ${ticker.info.categoryEnum.name}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Align(
                            alignment: Alignment.centerLeft, // 왼쪽 정렬
                            child: FittedBox(
                              fit: BoxFit.scaleDown, // 공간에 맞게 자동으로 크기를 조정
                              child: Text(
                                  '${ticker.price}  ${ticker.changePercent24h}%'),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticker.volume24h),
                          Text(tickerDisplay.alarmPrice),
                          if (tickerDisplay.priceStatusEnum ==
                              PriceStatusEnum.up)
                            Icon(Icons.trending_up, color: upColor)
                          else if (tickerDisplay.priceStatusEnum ==
                              PriceStatusEnum.down)
                            Icon(Icons.trending_down, color: downColor),
                        ],
                      ),
                    );
                  },
                  onReorder: (oldIndex, newIndex) {
                    // 상태 업데이트를 위해 tickerDisplayProvider에 순서 변경을 반영
                    tickerDisplayNotifier.updateOrderBox(oldIndex, newIndex);
                    setState(() {});
                  },
                )
              : ListView.builder(
                  itemCount: filteredTickerList.length,
                  itemBuilder: (context, index) {
                    final ticker = filteredTickerList[index];
                    final tickerDisplay = filteredTickerDisplays[index];
                    return ListTile(
                      key: ValueKey('${tickerDisplay.createdAt}'),
                      title: Row(
                        children: [
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerLeft, // 왼쪽 정렬
                              child: FittedBox(
                                fit: BoxFit.scaleDown, // 공간에 맞게 자동으로 크기를 조정
                                child: Text(
                                  '${ticker.info.symbol} ${ticker.info.categoryEnum.name}',
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8), // 아이콘과 텍스트 사이의 간격
                          Align(
                            alignment: Alignment.centerLeft, // 왼쪽 정렬
                            child: FittedBox(
                              fit: BoxFit.scaleDown, // 공간에 맞게 자동으로 크기를 조정
                              child: Text(
                                  '${ticker.price}  ${ticker.changePercent24h}%'),
                            ),
                          ),
                        ],
                      ),
                      subtitle: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(ticker.volume24h),
                          Text(tickerDisplay.alarmPrice),
                          if (tickerDisplay.priceStatusEnum ==
                              PriceStatusEnum.up)
                            Icon(Icons.trending_up, color: upColor)
                          else if (tickerDisplay.priceStatusEnum ==
                              PriceStatusEnum.down)
                            Icon(Icons.trending_down, color: downColor),
                        ],
                      ),
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
