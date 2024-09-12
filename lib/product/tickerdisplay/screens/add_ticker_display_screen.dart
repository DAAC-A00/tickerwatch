// add_ticker_display_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tickerwatch/product/default/widgets/info_bottom_sheet.dart';
import 'package:tickerwatch/product/tickerdisplay/entities/ticker_display_entity.dart';
import 'package:tickerwatch/product/tickers/enums/category_exchange_enum.dart';
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
  final List<String> contentList = [
    '개요',
    'ticker display를 등록해 실시간 정보를 확인할 수 있습니다. 설정한 가격을 돌파한 상태가 유지되는 동안 해당 ticker card에 알림을 노출해줍니다.',
    '추가 가능 ticker 조건',
    '선택한 category와 symbol이 모두 유효한 경우에만 추가가 가능합니다.',
  ];

  final TextEditingController _searchController = TextEditingController();

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

      if (selectedCategoryExchangeEnum == null) {
        // Add 버튼 활성화가 안되도록 해둔 조건이지만, 혹시 놓칠까봐 해당 조건문을 Add 처리 시도시 중복으로 작성
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('category가 선택되지 않았습니다. category를 선택해주세요.')),
        );
      } else if (selectedSymbol != _searchController.text) {
        // Add 버튼 활성화가 안되도록 해둔 조건이지만, 혹시 놓칠까봐 해당 조건문을 Add 처리 시도시 중복으로 작성
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  '선택된 "${selectedCategoryExchangeEnum?.getDescription}"는 "${_searchController.text}" symbol 값이 존재하지 않습니다.')),
        );
      } else if (matchingTickers.length == 1) {
        // 정상 처리
        final selectedTicker = matchingTickers.first;

        // TickerDisplayEntity 생성 및 추가
        ref.read(tickerDisplayProvider.notifier).insertBox(TickerDisplayEntity(
              categoryExchangeEnum: selectedTicker.info.categoryExchangeEnum,
              symbol: selectedTicker.info.symbol,
              price: selectedTicker.price,
              priceStatusEnum: selectedTicker.priceStatusEnum,
              searchKeywords: selectedTicker.info.searchKeywords,
            ));

        Navigator.of(context).pop(); // 화면을 닫고 이전 화면으로 돌아감
      } else if (matchingTickers.isEmpty) {
        // 0개 존재하는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('선택한 Category와 Symbol에 해당하는 ticker가 없습니다.')),
        );
      } else {
        // 2개 이상 존재하는 경우
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  '선택한 Category와 Symbol에 해당하는 ticker가 2개 이상입니다. 관리자에게 문의해주세요.')),
        );
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
