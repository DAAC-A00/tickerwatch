// add_ticker_display_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/info_bottom_sheet.dart';
import 'package:tickerwatch/product/tickeralarm/entities/ticker_alarm_entity.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
import 'package:tickerwatch/product/tickers/enums/price_status_enum.dart';
import '../../tickers/states/ticker_provider.dart';
import 'package:tickerwatch/product/tickeralarm/states/ticker_alarm_provider.dart';

class AddTickerAlarmScreen extends ConsumerStatefulWidget {
  const AddTickerAlarmScreen({super.key});

  @override
  ConsumerState<AddTickerAlarmScreen> createState() =>
      _AddTickerAlarmScreenState();
}

class _AddTickerAlarmScreenState extends ConsumerState<AddTickerAlarmScreen> {
  final List<String> contentList = [
    '개요',
    'ticker display를 등록해 실시간 정보를 확인할 수 있습니다. 설정한 가격을 돌파한 상태가 유지되는 동안 해당 ticker card에 알림을 노출해줍니다.',
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
            (ticker.info.categoryExchangeEnum ==
                selectedCategoryExchangeEnum) &&
            ticker.info.searchKeywords
                .toLowerCase()
                .contains(query.toLowerCase()))
        .map((ticker) => ticker.info.symbol)
        .toList();
    setState(() {});
  }

  void _addTickerDisplay() {
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

        // alarmPrice 입력값 검증
        final alarmPriceText = _alarmPriceController.text;
        if (alarmPriceText.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alarm Price를 입력해주세요.')),
          );
          return;
        }

        final alarmPrice = double.tryParse(alarmPriceText);
        if (alarmPrice == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('유효한 Alarm Price를 입력해주세요.')),
          );
          return;
        }

        final currentPrice = double.tryParse(selectedTicker.price);
        if (currentPrice == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('ticker의 price 정보가 없어 알람을 등록할 수 없습니다.')),
          );
          return;
        }

        // priceStatusEnum 설정
        PriceStatusEnum priceStatusEnum;
        if (alarmPrice > currentPrice) {
          priceStatusEnum = PriceStatusEnum.up;
        } else if (alarmPrice < currentPrice) {
          priceStatusEnum = PriceStatusEnum.down;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Alarm Price가 현재 가격과 같습니다.')),
          );
          return; // 동일하면 추가하지 않음
        }

        // TickerDisplayEntity 생성 및 추가
        ref.read(tickerAlarmProvider.notifier).insertBox(TickerAlarmEntity(
              categoryExchangeEnum: selectedTicker.info.categoryExchangeEnum,
              symbol: selectedTicker.info.symbol,
              alarmPrice: alarmPriceText, // alarmPrice를 저장
              priceStatusEnum: priceStatusEnum,
              searchKeywords: selectedTicker.info.searchKeywords,
            ));

        Navigator.of(context).pop(); // 화면을 닫고 이전 화면으로 돌아감
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Ticker Display'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () => showInfoBottomSheet(context, contentList),
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
                    // Alarm Price 입력 필드 추가
                    TextField(
                      controller: _alarmPriceController,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: const InputDecoration(
                        hintText: 'Enter Alarm Price',
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
                          // 유효한 ticker symbol & categoryExchangeEnum인지 확인
                          ref.read(tickerProvider).any((ticker) =>
                              ticker.info.symbol == selectedSymbol &&
                              ticker.info.categoryExchangeEnum ==
                                  selectedCategoryExchangeEnum)
                      ? _addTickerDisplay
                      : null,
                  child: const Text('Add'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
