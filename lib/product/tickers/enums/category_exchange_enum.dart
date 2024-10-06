// category_exchange_enum.dart

// 내부 데이터 저장용

import 'package:flutter/material.dart';

enum CategoryExchangeEnum {
  none,
  // Bybit
  spotBybit,
  umBybit,
  cmBybit,
  // Bitget
  spotBitget,
  umBitget,
  cmBitget,
  // OKX
  spotOkx,
  umOkx,
  cmOkx,
  cmOptionOkx,
  // Binance
  spotBinance,
  umBinance,
  cmBinance,
  umOptionBinance,
  cmOptionBinance,
  // Upbit
  spotUpbit,
  // Bithumb
  spotBithumb,
}

extension CategoryExchangeEnumExtension on CategoryExchangeEnum {
  static CategoryExchangeEnum fromString(String enumString) {
    switch (enumString) {
      case 'none':
        return CategoryExchangeEnum.none;
      case 'spotBybit':
        return CategoryExchangeEnum.spotBybit;
      case 'umBybit':
        return CategoryExchangeEnum.umBybit;
      case 'cmBybit':
        return CategoryExchangeEnum.cmBybit;
      case 'spotBitget':
        return CategoryExchangeEnum.spotBitget;
      case 'umBitget':
        return CategoryExchangeEnum.umBitget;
      case 'cmBitget':
        return CategoryExchangeEnum.cmBitget;
      case 'spotOkx':
        return CategoryExchangeEnum.spotOkx;
      case 'umOkx':
        return CategoryExchangeEnum.umOkx;
      case 'cmOkx':
        return CategoryExchangeEnum.cmOkx;
      case 'cmOptionOkx':
        return CategoryExchangeEnum.cmOptionOkx;
      case 'spotBinance':
        return CategoryExchangeEnum.spotBinance;
      case 'umBinance':
        return CategoryExchangeEnum.umBinance;
      case 'cmBinance':
        return CategoryExchangeEnum.cmBinance;
      case 'umOptionBinance':
        return CategoryExchangeEnum.umOptionBinance;
      case 'cmOptionBinance':
        return CategoryExchangeEnum.cmOptionBinance;
      case 'spotUpbit':
        return CategoryExchangeEnum.spotUpbit;
      case 'spotBithumb':
        return CategoryExchangeEnum.spotBithumb;
      default:
        throw Exception('Unknown enum value: $enumString');
    }
  }

  String get getDescription {
    switch (this) {
      case CategoryExchangeEnum.none:
        return 'None';
      // bybit
      case CategoryExchangeEnum.spotBybit:
        return '🆂 Spot (Bybit)';
      case CategoryExchangeEnum.umBybit:
        return 'ⓤ USDⓈ Futures (Bybit)';
      case CategoryExchangeEnum.cmBybit:
        return 'ⓒ COIN Futures (Bybit)';
      case CategoryExchangeEnum.spotBitget:
        return '🆂 Spot (Bitget)';
      case CategoryExchangeEnum.umBitget:
        return 'ⓤ USDⓈ Futures (Bitget)';
      case CategoryExchangeEnum.cmBitget:
        return 'ⓒ COIN Futures (Bitget)';
      case CategoryExchangeEnum.spotOkx:
        return '🆂 Spot (OKX)';
      case CategoryExchangeEnum.umOkx:
        return 'ⓤ USDⓈ Futures (OKX)';
      case CategoryExchangeEnum.cmOkx:
        return 'ⓒ COIN Futures (OKX)';
      case CategoryExchangeEnum.cmOptionOkx:
        return '🅞 COIN OPTION (OKX)';
      case CategoryExchangeEnum.spotBinance:
        return '🆂 Spot (Binance)';
      case CategoryExchangeEnum.umBinance:
        return 'ⓤ USDⓈ Futures (Binance)';
      case CategoryExchangeEnum.cmBinance:
        return 'ⓒ COIN Futures (Binance)';
      case CategoryExchangeEnum.umOptionBinance:
        return '🅞 USDⓈ OPTION (Binance)';
      case CategoryExchangeEnum.cmOptionBinance:
        return '🅞 COIN OPTION (Binance)';
      case CategoryExchangeEnum.spotUpbit:
        return '🆂 Spot (Upbit)';
      case CategoryExchangeEnum.spotBithumb:
        return '🆂 Spot (Bithumb)';
    }
  }

  String get getString {
    switch (this) {
      case CategoryExchangeEnum.none:
        return 'none';
      // bybit
      case CategoryExchangeEnum.spotBybit:
        return 'spotBybit';
      case CategoryExchangeEnum.umBybit:
        return 'umBybit';
      case CategoryExchangeEnum.cmBybit:
        return 'cmBybit';
      case CategoryExchangeEnum.spotBitget:
        return 'spotBitget';
      case CategoryExchangeEnum.umBitget:
        return 'umBitget';
      case CategoryExchangeEnum.cmBitget:
        return 'cmBitget';
      case CategoryExchangeEnum.spotOkx:
        return 'spotOkx';
      case CategoryExchangeEnum.umOkx:
        return 'umOkx';
      case CategoryExchangeEnum.cmOkx:
        return 'cmOkx';
      case CategoryExchangeEnum.cmOptionOkx:
        return 'cmOptionOkx';
      case CategoryExchangeEnum.spotBinance:
        return 'spotBinance';
      case CategoryExchangeEnum.umBinance:
        return 'umBinance';
      case CategoryExchangeEnum.cmBinance:
        return 'cmBinance';
      case CategoryExchangeEnum.umOptionBinance:
        return 'umOptionBinance';
      case CategoryExchangeEnum.cmOptionBinance:
        return 'cmOptionBinance';
      case CategoryExchangeEnum.spotUpbit:
        return 'spotUpbit';
      case CategoryExchangeEnum.spotBithumb:
        return 'spotBithumb';
    }
  }

  String get getExchangeName {
    switch (this) {
      case CategoryExchangeEnum.none:
        return 'none';
      // Bybit
      case CategoryExchangeEnum.spotBybit:
      case CategoryExchangeEnum.umBybit:
      case CategoryExchangeEnum.cmBybit:
        return 'Bybit';
      case CategoryExchangeEnum.spotBitget:
      case CategoryExchangeEnum.umBitget:
      case CategoryExchangeEnum.cmBitget:
        return 'Bitget';
      case CategoryExchangeEnum.spotOkx:
      case CategoryExchangeEnum.umOkx:
      case CategoryExchangeEnum.cmOkx:
      case CategoryExchangeEnum.cmOptionOkx:
        return 'OKX';
      case CategoryExchangeEnum.spotBinance:
      case CategoryExchangeEnum.umBinance:
      case CategoryExchangeEnum.cmBinance:
      case CategoryExchangeEnum.umOptionBinance:
      case CategoryExchangeEnum.cmOptionBinance:
        return 'Binance';
      case CategoryExchangeEnum.spotUpbit:
        return 'Upbit';
      case CategoryExchangeEnum.spotBithumb:
        return 'Bithumb';
    }
  }

  String get logoPathString {
    switch (this) {
      case CategoryExchangeEnum.none:
        return '';
      // Bybit
      case CategoryExchangeEnum.spotBybit:
      case CategoryExchangeEnum.umBybit:
      case CategoryExchangeEnum.cmBybit:
        return 'lib/product/resources/images/exchangeBybit.jpeg';
      case CategoryExchangeEnum.spotBitget:
      case CategoryExchangeEnum.umBitget:
      case CategoryExchangeEnum.cmBitget:
        return 'lib/product/resources/images/exchangeBitget.png';
      case CategoryExchangeEnum.spotOkx:
      case CategoryExchangeEnum.umOkx:
      case CategoryExchangeEnum.cmOkx:
      case CategoryExchangeEnum.cmOptionOkx:
        return 'lib/product/resources/images/exchangeOkx.jpeg';
      case CategoryExchangeEnum.spotBinance:
      case CategoryExchangeEnum.umBinance:
      case CategoryExchangeEnum.cmBinance:
      case CategoryExchangeEnum.umOptionBinance:
      case CategoryExchangeEnum.cmOptionBinance:
        return 'lib/product/resources/images/exchangeBinance.png';
      case CategoryExchangeEnum.spotUpbit:
        return 'lib/product/resources/images/exchangeUpbit.png';
      case CategoryExchangeEnum.spotBithumb:
        return 'lib/product/resources/images/exchangeBithumb.png';
    }
  }

  Widget get logoImage {
    return Image.asset(
      logoPathString,
      errorBuilder:
          (BuildContext context, Object error, StackTrace? stackTrace) {
        // 이미지 로딩 오류 발생 시 대체 이미지나 메시지 표시
        // return Text('');
        return Icon(Icons.cloud_off);
      },
    );
  }
}
