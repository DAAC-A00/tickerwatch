// add_ticker_display_screen.dart

import 'dart:developer';

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
  List<ExchangeRawCategoryEnum> availableCategories = [];
  final TextEditingController _searchController = TextEditingController();
  List<String> availableRawSymbols = [];
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

      log('selectedRawSymbol : $selectedRawSymbol');
      log('selectedExchangeRawCategoryEnum : $selectedExchangeRawCategoryEnum');

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
              onChanged: _loadAvailableSymbols,
              decoration: const InputDecoration(
                hintText: 'Symbol 검색',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: availableRawSymbols.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(availableRawSymbols[index]),
                    onTap: () {
                      setState(() {
                        selectedRawSymbol = availableRawSymbols[index];
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
