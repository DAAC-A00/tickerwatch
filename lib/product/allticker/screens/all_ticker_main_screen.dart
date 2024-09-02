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
        // final double text = Theme.of(context).textTheme.bodyLarge?.fontSize;
        // final ColorScheme currentTheme = Theme.of(context).colorScheme;
        return Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                '안내 정보',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text('여기에 해당 화면에 대한 안내 정보를 작성합니다.'),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // 바텀 시트를 닫기
                },
                child: const Text('확인'),
              ),
            ],
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
