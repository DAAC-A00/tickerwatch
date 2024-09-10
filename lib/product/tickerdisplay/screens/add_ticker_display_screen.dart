// add_ticker_display_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/external/default/exchange_raw_category_enum.dart';
import 'package:tickerwatch/product/tickerdisplay/entities/ticker_display_entity.dart';
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
  List<ExchangeRawCategoryEnum> availableCategories = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredRawSymbols = [];
  ExchangeRawCategoryEnum? selectedExchangeRawCategoryEnum;
  String? selectedRawSymbol;

  @override
  void initState() {
    super.initState();
    _loadAvailableCategories();
  }

  void _loadAvailableCategories() {
    final tickers = ref.read(tickerProvider);
    final categories = tickers
        .map((ticker) => ticker.info.exchangeRawCategoryEnum)
        .toSet()
        .toList();
    availableCategories = categories;
  }

  void _filterSymbols(String query) {
    final tickers = ref.read(tickerProvider);
    filteredRawSymbols = tickers
        .where((ticker) => ticker.info.searchKeywords
            .toLowerCase()
            .contains(query.toLowerCase()))
        .map((ticker) => ticker.info.rawSymbol)
        .toList();
    setState(() {});
  }

  void _addTickerDisplay() {
    if (selectedRawSymbol != null && selectedExchangeRawCategoryEnum != null) {
      final tickers = ref.read(tickerProvider);
      final selectedTicker = tickers.firstWhere((ticker) =>
          ticker.info.rawSymbol == selectedRawSymbol &&
          ticker.info.exchangeRawCategoryEnum ==
              selectedExchangeRawCategoryEnum);

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
        title: const Text('Ticker Display 추가'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _addTickerDisplay,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<ExchangeRawCategoryEnum>(
              value: selectedExchangeRawCategoryEnum,
              hint: const Text('카테고리 선택'),
              items: availableCategories
                  .map((ExchangeRawCategoryEnum exchangeRawCategoryEnum) {
                return DropdownMenuItem<ExchangeRawCategoryEnum>(
                  value: exchangeRawCategoryEnum,
                  child: Text(exchangeRawCategoryEnum.name),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedExchangeRawCategoryEnum = value;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              onChanged: _filterSymbols,
              decoration: const InputDecoration(
                hintText: 'Symbol 검색',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredRawSymbols.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(filteredRawSymbols[index]),
                    onTap: () {
                      setState(() {
                        selectedRawSymbol = filteredRawSymbols[index];
                      });
                    },
                  );
                },
              ),
            ),
            if (selectedRawSymbol != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('선택된 Symbol: $selectedRawSymbol'),
              ),
          ],
        ),
      ),
    );
  }
}
