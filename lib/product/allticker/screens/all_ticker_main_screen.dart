// all_ticker_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../tickers/states/ticker_provider.dart';
import '../../watch/screens/watch_main_screen.dart';

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

  @override
  Widget build(BuildContext context) {
    final tickers = ref.watch(tickerProvider);

    // 검색된 ticker 리스트
    final filteredTickers = tickers.where((ticker) {
      return ticker.info.searchKeywords
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            setState(() {});
          },
          decoration: InputDecoration(
            hintText: 'Search Tickers',
            // border: const OutlineInputBorder(),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear(); // 컨트롤러를 통해 입력값을 지웁니다.
                setState(() {}); // 상태를 갱신하여 필터링
              },
            ),
          ),
        ),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const WatchMainScreen(),
            ),
          );
        },
        tooltip: 'Go to New Screen',
        child: const Icon(Icons.watch_later_outlined),
      ),
    );
  }
}
