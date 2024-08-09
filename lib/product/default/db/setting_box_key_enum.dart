// setting_box_key_enum.dart

enum SettingBoxKeyEnum {
  // Ticker Setting
  longColor,
  shortColor,
  isBorderEnabled,
  isPriceBackgroundAlarmEnabled,
  isQuoteUnitSignEnabled,
  isPercentSignEnabled,
  // Common Setting
  isDarkMode
}

extension SettingBoxKeyEnumExtension on SettingBoxKeyEnum {
  String get name {
    switch (this) {
      // Ticker Setting
      case SettingBoxKeyEnum.longColor:
        return 'longColor';
      case SettingBoxKeyEnum.shortColor:
        return 'shortColor';
      case SettingBoxKeyEnum.isBorderEnabled:
        return 'isBorderEnabled';
      case SettingBoxKeyEnum.isPriceBackgroundAlarmEnabled:
        return 'isPriceBackgroundAlarmEnabled';
      case SettingBoxKeyEnum.isQuoteUnitSignEnabled:
        return 'isQuoteUnitSignEnabled';
      case SettingBoxKeyEnum.isPercentSignEnabled:
        return 'isPercentSignEnabled';
      // Common Setting
      case SettingBoxKeyEnum.isDarkMode:
        return 'isDarkMode';
      default:
        return '';
    }
  }
}
