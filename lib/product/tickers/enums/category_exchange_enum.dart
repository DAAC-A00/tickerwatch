// category_exchange_enum.dart

// 내부 데이터 저장용

enum CategoryExchangeEnum {
  // Bybit
  spotBybit,
}

extension CategoryExchangeEnumExtension on CategoryExchangeEnum {
  static CategoryExchangeEnum fromString(String enumString) {
    switch (enumString) {
      case 'spotBybit':
        return CategoryExchangeEnum.spotBybit;
      default:
        throw Exception('Unknown enum value: $enumString');
    }
  }

  String get getDescription {
    switch (this) {
      // bybit
      case CategoryExchangeEnum.spotBybit:
        return '🆂 Spot (Bybit)';
      default:
        return '';
    }
  }

  String get getString {
    switch (this) {
      // bybit
      case CategoryExchangeEnum.spotBybit:
        return 'spotBybit';
      default:
        return '';
    }
  }

  String get getExchangeName {
    switch (this) {
      // Bybit
      case CategoryExchangeEnum.spotBybit:
        return "Bybit";
    }
  }

  String get logoPath {
    switch (this) {
      // Bybit
      case CategoryExchangeEnum.spotBybit:
        return "lib/product/resources/images/exchangeBybit.jpeg";
    }
  }
}
