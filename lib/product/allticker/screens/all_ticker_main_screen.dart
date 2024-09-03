// all_ticker_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tickers/states/ticker_provider.dart';

class AllTickerMainScreen extends ConsumerStatefulWidget {
  const AllTickerMainScreen({super.key});

  @override
  ConsumerState<AllTickerMainScreen> createState() =>
      _AllTickerMainScreenState();
}

class _AllTickerMainScreenState extends ConsumerState<AllTickerMainScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showInfoBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(
              (Theme.of(context).textTheme.bodyMedium?.fontSize ?? 20) * 2),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  '개요',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('현재 디바이스에 저장된 모든 ticker 정보를 조회하고 검색할 수 있는 화면입니다.'),
                const Text(
                  '\n주의사항',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text('현재는 bybit spot 정보만 수집 및 저장하고 있습니다.'),
                const Text(
                  '\n기능 추가 예정 내용',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    '현재는 binance, okx 등 거래소가 추가될 예정이며 spot 외에 cm(coin-margined), um(usdS-margined) 등의 정보 수집 및 저장 또한 추가될 예정입니다.'),
                const Text(
                  '\n슈퍼 모드 활성화 여부에 따른 차이점',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Text(
                    '슈퍼 모드 활성화시 bybit spot의 모든 정보를 실시간으로 업데이트합니다.\n단, 슈퍼 모드 비활성화시 앱 실행했을때에만 정보를 수집해 저장하고 이후 실시간으로 최신회된 정보로 업데이트되지는 않습니다.'),
                TextButton(
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
    final tickers = ref.watch(tickerProvider);

    // 검색된 ticker 리스트
    final filteredTickers = tickers.where((ticker) {
      return ticker.info.searchKeywords
          .toLowerCase()
          .contains(_searchController.text.replaceAll(' ', '').toLowerCase());
    }).toList();

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
            // border: InputBorder.none,
            suffixIcon: _searchController.text != ''
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
      body: filteredTickers.isEmpty
          ? const Center(
              child: Text('검색 결과가 없습니다.'),
            )
          : ListView.builder(
              itemCount: filteredTickers.length,
              itemBuilder: (context, index) {
                final ticker = filteredTickers[index];
                return ListTile(
                  title: Text(
                      '${ticker.info.rawSymbol}     ${ticker.info.exchangeRawCategoryEnum.name}'),
                  subtitle: Text(
                    '${ticker.price}    ${ticker.changePercent24h}',
                  ),
                );
              },
            ),
    );
  }
}
