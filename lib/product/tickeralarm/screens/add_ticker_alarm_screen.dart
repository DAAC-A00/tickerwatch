// add_ticker_alarm_screen.dart

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/custom_modal_bottom_sheet.dart';
import 'package:tickerwatch/product/tickeralarm/entities/ticker_alarm_entity.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';
import '../../tickers/states/ticker_provider.dart';
import 'package:tickerwatch/product/tickeralarm/states/ticker_alarm_provider.dart';

class AddTickerAlarmScreen extends ConsumerStatefulWidget {
  final int? index; // 수정할 TickerAlarm의 인덱스
  final TickerAlarmEntity? tickerAlarm; // 수정할 TickerAlarm

  const AddTickerAlarmScreen({super.key, this.index, this.tickerAlarm});

  @override
  ConsumerState<AddTickerAlarmScreen> createState() =>
      _AddTickerAlarmScreenState();
}

class _AddTickerAlarmScreenState extends ConsumerState<AddTickerAlarmScreen> {
  final List<String> contentList = [
    '개요',
    'ticker alarm를 등록해 실시간 정보를 확인할 수 있습니다. 설정한 가격을 돌파한 상태가 유지되는 동안 해당 ticker card에 알림을 노출해줍니다.',
    '추가 가능 ticker 조건',
    '선택한 category와 symbol이 모두 유효한 경우에만 추가가 가능합니다.',
  ];

  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _alarmPriceController = TextEditingController();

  List<CategoryExchangeEnum> availableCategoryExchangeEnumList = [];
  List<String> availableSymbolList = [];

  CategoryExchangeEnum? selectedCategoryExchangeEnum;
  String? selectedSymbol;

  @override
  void initState() {
    super.initState();
    _loadAvailableCategoryExchangeEnumList();

    // 수정 모드일 경우 기존 TickerAlarm 정보 로드
    if (widget.index != null && widget.tickerAlarm != null) {
      selectedCategoryExchangeEnum = widget.tickerAlarm!.categoryExchangeEnum;
      _searchController.text = widget.tickerAlarm!.symbol;
      selectedSymbol = widget.tickerAlarm!.symbol;
      _alarmPriceController.text = widget.tickerAlarm!.alarmPrice;
    }
  }

  void _loadAvailableCategoryExchangeEnumList() {
    final tickers = ref.read(tickerProvider);
    final categories = tickers
        .map((ticker) => ticker.info.categoryExchangeEnum)
        .toSet()
        .toList();
    availableCategoryExchangeEnumList = categories;
  }

  void _loadAvailableSymbolList(String query) {
    final tickers = ref.read(tickerProvider);
    availableSymbolList = tickers
        .where((ticker) =>
            (ticker.info.symbol != '' &&
                ticker.info.categoryExchangeEnum ==
                    selectedCategoryExchangeEnum) &&
            ticker.info.searchKeywords
                .toLowerCase()
                .contains(query.toLowerCase()))
        .map((ticker) => ticker.info.symbol)
        .toList();
    setState(() {});
  }

  void _addOrUpdateTickerAlarm() {
    if (selectedSymbol != null && selectedCategoryExchangeEnum != null) {
      final tickers = ref.read(tickerProvider);

      // 조건에 맞는 ticker 목록 필터링
      final matchingTickers = tickers
          .where((ticker) =>
              ticker.info.symbol == selectedSymbol &&
              ticker.info.categoryExchangeEnum == selectedCategoryExchangeEnum)
          .toList();

      if (matchingTickers.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('선택한 Category와 Symbol에 해당하는 ticker가 없습니다.')),
        );
      } else if (matchingTickers.length > 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('선택한 Category와 Symbol에 해당하는 ticker가 2개 이상입니다.')),
        );
      } else {
        final selectedTicker = matchingTickers.first;

        final alarmPrice = double.tryParse(_alarmPriceController.text);
        final currentPrice = double.tryParse(selectedTicker.price);
        // priceStatusEnum 설정
        PriceStatusEnum priceStatusEnum;
        if (currentPrice == null) {
          // 현재 가격 정보가 없는 경우
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('해당 거래소에서 현재 가격을 불러오지 못하고 있어 알람을 등록할 수 없습니다.')),
          );
          return;
        } else if (alarmPrice == null) {
          // 알람 가격 정보가 잘못된 경우 ex. 숫자가 아니거나 값이 없는 경우
          log('[WARN][AddTickerAlarmScreen._addTickerAlarm] Add 버튼 활성화가 안되어있어야하는데 활성화되어 잘못 처리됨');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text(
                    '잘못된 Alarm Price가 입력되었습니다. 정상적인 Alarm Price를 입력해주세요.')),
          );
          return;
        } else {
          // 정상인 경우
          if (alarmPrice > currentPrice) {
            // 상승 돌파시 알람
            priceStatusEnum = PriceStatusEnum.up;
          } else if (alarmPrice < currentPrice) {
            // 하락 돌파시 알람
            priceStatusEnum = PriceStatusEnum.down;
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Alarm Price가 현재 가격과 같습니다. 다른 값으로 설정해주세요.')),
            );
            return; // 동일하면 추가하지 않음
          }
        }

        // currentPrice의 소수점 자릿수 결정
        final currentPriceText = selectedTicker.price;
        final currentDecimalPlaces = currentPriceText.contains('.')
            ? currentPriceText.split('.').last.length
            : 0;

        // alarmPrice의 소수점 자릿수 결정
        final alarmPriceText = _alarmPriceController.text;
        final alarmDecimalPlaces = alarmPriceText.contains('.')
            ? alarmPriceText.split('.').last.length
            : 0;

        // 더 긴 소수점 자릿수에 맞춰 포맷팅
        final maxDecimalPlaces = alarmDecimalPlaces > currentDecimalPlaces
            ? alarmDecimalPlaces
            : currentDecimalPlaces;

        // alarmPriceText 포맷팅
        final formattedAlarmPriceText =
            alarmPrice.toStringAsFixed(maxDecimalPlaces);

        if (widget.index != null) {
          // 수정 로직
          ref.read(tickerAlarmProvider.notifier).updateBox(
              widget.index!,
              TickerAlarmEntity(
                categoryExchangeEnum: selectedTicker.info.categoryExchangeEnum,
                symbol: selectedTicker.info.symbol,
                alarmPrice: formattedAlarmPriceText,
                priceStatusEnum: priceStatusEnum,
                searchKeywords: selectedTicker.info.searchKeywords,
              ));
        } else {
          // 추가 로직
          ref.read(tickerAlarmProvider.notifier).insertBox(TickerAlarmEntity(
                categoryExchangeEnum: selectedTicker.info.categoryExchangeEnum,
                symbol: selectedTicker.info.symbol,
                alarmPrice: formattedAlarmPriceText,
                priceStatusEnum: priceStatusEnum,
                searchKeywords: selectedTicker.info.searchKeywords,
              ));
        }

        Navigator.of(context).pop(); // 화면을 닫고 이전 화면으로 돌아감
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final alarmPrice = double.tryParse(_alarmPriceController.text);

    return Scaffold(
      appBar: AppBar(
        title: widget.index == null
            ? const Text('Add Ticker Alarm')
            : const Text('Edit Ticker Alarm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showCustomModalBottomSheet(context, contentList),
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
                    DropdownButton<CategoryExchangeEnum>(
                      value: selectedCategoryExchangeEnum,
                      hint: const Text('Select Category'),
                      items: availableCategoryExchangeEnumList
                          .map((CategoryExchangeEnum categoryExchangeEnum) {
                        return DropdownMenuItem<CategoryExchangeEnum>(
                          value: categoryExchangeEnum,
                          child: Text(categoryExchangeEnum.getDescription),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategoryExchangeEnum = value;
                          _loadAvailableSymbolList(_searchController.text);
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onTap: () {
                        _loadAvailableSymbolList(_searchController.text);
                      },
                      onChanged: _loadAvailableSymbolList,
                      decoration: InputDecoration(
                        hintText: 'Search Symbol',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _loadAvailableSymbolList(
                                      _searchController.text);
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap:
                          true, // ListView의 크기를 부모에 맞추기 위해 shrinkWrap을 true로 설정
                      physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                      itemCount: availableSymbolList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(availableSymbolList[index]),
                          onTap: () {
                            setState(() {
                              selectedSymbol = availableSymbolList[index];
                              _searchController.text =
                                  availableSymbolList[index];
                              availableSymbolList.clear();
                            });
                          },
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    // Alarm Price
                    TextField(
                      controller: _alarmPriceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Enter Alarm Price',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                    const SizedBox(height: 16),
                    ListView.builder(
                      shrinkWrap:
                          true, // ListView의 크기를 부모에 맞추기 위해 shrinkWrap을 true로 설정
                      physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화
                      itemCount: availableSymbolList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(availableSymbolList[index]),
                          onTap: () {
                            setState(() {
                              selectedSymbol = availableSymbolList[index];
                              _searchController.text =
                                  availableSymbolList[index];
                              availableSymbolList.clear();
                            });
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: selectedSymbol != null &&
                          selectedCategoryExchangeEnum != null &&
                          // 선택된 symbol 값과 symbol search 값이 동일한지 확인
                          selectedSymbol == _searchController.text &&
                          alarmPrice != null &&
                          alarmPrice > 0 &&
                          // 유효한 ticker symbol & categoryExchangeEnum인지 확인
                          ref.read(tickerProvider).any((ticker) =>
                              ticker.info.symbol == selectedSymbol &&
                              ticker.info.categoryExchangeEnum ==
                                  selectedCategoryExchangeEnum)
                      ? _addOrUpdateTickerAlarm
                      : null,
                  child: widget.index == null
                      ? const Text('Add')
                      : const Text('Edit'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
