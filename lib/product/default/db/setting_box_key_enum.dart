// setting_box_key_enum.dart

enum SettingBoxKeyEnum {
  candleColor,
  isBorderEnabled,
  isPriceBackgroundAlarmEnabled,
  isQuoteUnitSignEnabled,
  isPercentSignEnabled
}

extension SettingBoxKeyEnumExtension on SettingBoxKeyEnum {
  String get name {
    switch (this) {
      case SettingBoxKeyEnum.candleColor:
        return 'candleColor';
      case SettingBoxKeyEnum.isBorderEnabled:
        return 'isBorderEnabled';
      case SettingBoxKeyEnum.isPriceBackgroundAlarmEnabled:
        return 'isPriceBackgroundAlarmEnabled';
      case SettingBoxKeyEnum.isQuoteUnitSignEnabled:
        return 'isQuoteUnitSignEnabled';
      case SettingBoxKeyEnum.isPercentSignEnabled:
        return 'isPercentSignEnabled';
      default:
        return '';
    }
  }
}
