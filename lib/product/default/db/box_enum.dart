// box_enum.dart

enum BoxEnum {
  setting,
  counter,
  person,
  ticker,
  tickerDisplay,
}

extension BoxEnumExtension on BoxEnum {
  String get name {
    switch (this) {
      case BoxEnum.setting:
        return 'setting';
      case BoxEnum.counter:
        return 'counter';
      case BoxEnum.person:
        return 'person';
      case BoxEnum.ticker:
        return 'ticker';
      case BoxEnum.tickerDisplay:
        return 'tickerDisplay';
    }
  }
}
