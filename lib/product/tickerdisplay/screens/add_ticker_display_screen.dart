// add_ticker_display_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickerdisplay/entities/ticker_display_entity.dart';
import 'package:tickerwatch/product/tickers/entities/ticker_entity.dart';
import '../../tickers/states/ticker_provider.dart';
import 'package:tickerwatch/product/tickerdisplay/states/ticker_display_provider.dart';

class AddTickerDisplayScreen extends ConsumerStatefulWidget {
  const AddTickerDisplayScreen({super.key});

  @override
  ConsumerState<AddTickerDisplayScreen> createState() =>
      _AddTickerDisplayScreenState();
}

class _AddTickerDisplayScreenState
    extends ConsumerState<AddTickerDisplayScreen> {
  final TextEditingController _searchController = TextEditingController();

  List<ExchangeRawCategoryEnum> availableExchangeRawCategories = [];
  List<String> availableRawSymbols = [];

  ExchangeRawCategoryEnum? selectedExchangeRawCategoryEnum;
  String? selectedRawSymbol;

  final int keyFlex = 2;
  final int valueFlex = 5;

  @override
  void initState() {
    super.initState();
    _loadAvailableExchangeRawCategories();
  }

  void _loadAvailableExchangeRawCategories() {
    final tickers = ref.read(tickerProvider);
    final categories = tickers
        .map((ticker) => ticker.info.exchangeRawCategoryEnum)
        .toSet()
        .toList();
    availableExchangeRawCategories = categories;
  }

  void _loadAvailableSymbols(String query) {
    final tickers = ref.read(tickerProvider);
    availableRawSymbols = tickers
        .where((ticker) =>
            (ticker.info.exchangeRawCategoryEnum ==
                selectedExchangeRawCategoryEnum) &&
            ticker.info.searchKeywords
                .toLowerCase()
                .contains(query.toLowerCase()))
        .map((ticker) => ticker.info.rawSymbol)
        .toList();
    setState(() {});
  }

  void _addTickerDisplay() {
    if (selectedRawSymbol != null && selectedExchangeRawCategoryEnum != null) {
      final tickers = ref.read(tickerProvider);

      TickerEntity? selectedTicker;

      try {
        // 조건에 맞는 ticker를 찾음.
        selectedTicker = tickers.firstWhere((ticker) =>
            ticker.info.rawSymbol == selectedRawSymbol &&
            ticker.info.exchangeRawCategoryEnum ==
                selectedExchangeRawCategoryEnum);
      } catch (e) {
        // 선택한 Symbol에 해당하는 ticker가 없을 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('선택한 Symbol에 해당하는 ticker가 없습니다.')),
        );
        return; // 함수 종료
      }

      // selectedTicker가 null인지 확인 (이 경우는 catch에서 처리됨)
      // TickerDisplayEntity 생성 및 추가
      ref.read(tickerDisplayProvider.notifier).insertBox(TickerDisplayEntity(
            categoryExchangeEnum: selectedTicker.info.categoryExchangeEnum,
            name: selectedTicker.info.unit == 1
                ? '${selectedTicker.info.baseCode}/${selectedTicker.info.quoteCode}'
                : '${selectedTicker.info.unit}${selectedTicker.info.baseCode}/${selectedTicker.info.quoteCode}',
            price: selectedTicker.price,
            priceStatusEnum: selectedTicker.priceStatusEnum,
            exchangeRawCategoryEnum:
                selectedTicker.info.exchangeRawCategoryEnum,
            rawSymbol: selectedTicker.info.rawSymbol,
          ));

      Navigator.of(context).pop(); // 화면을 닫고 이전 화면으로 돌아감
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _addTickerDisplay,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: keyFlex, child: const Text('Category')),
                        Expanded(
                          flex: valueFlex,
                          child: DropdownButton<ExchangeRawCategoryEnum>(
                            value: selectedExchangeRawCategoryEnum,
                            hint: const Text('Select Category'),
                            items: availableExchangeRawCategories.map(
                                (ExchangeRawCategoryEnum
                                    exchangeRawCategoryEnum) {
                              return DropdownMenuItem<ExchangeRawCategoryEnum>(
                                value: exchangeRawCategoryEnum,
                                child: Text(exchangeRawCategoryEnum.name),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedExchangeRawCategoryEnum = value;
                                _loadAvailableSymbols('');
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(flex: keyFlex, child: const Text('Symbol')),
                        Expanded(
                          flex: valueFlex,
                          child: TextField(
                            controller: _searchController,
                            onChanged: _loadAvailableSymbols,
                            decoration: const InputDecoration(
                              hintText: 'Search Symbol',
                              prefixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(flex: keyFlex, child: const Text('')),
                        Expanded(
                          flex: valueFlex,
                          child: ListView.builder(
                            shrinkWrap:
                                true, // ListView의 크기를 부모에 맞추기 위해 shrinkWrap을 true로 설정
                            physics:
                                const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                            itemCount: availableRawSymbols.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(availableRawSymbols[index]),
                                onTap: () {
                                  setState(() {
                                    selectedRawSymbol =
                                        availableRawSymbols[index];
                                  });
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  // 취소 버튼을 OutlinedButton으로 변경
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: selectedRawSymbol != null
                      ? _addTickerDisplay
                      : null, // selectedRawSymbol이 있을 때만 활성화
                  child: const Text('저장하기'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
