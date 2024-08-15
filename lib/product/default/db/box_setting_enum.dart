// box_setting_enum.dart

enum BoxSettingEnum {
  // Ticker Setting
  longColor,
  shortColor,
  isBorderEnabled,
  isPriceBackgroundAlarmEnabled,
  isQuoteUnitSignEnabled,
  isPercentSignEnabled,
  // Common Setting
  isLightMode
}

extension BoxSettingEnumExtension on BoxSettingEnum {
  String get name {
    switch (this) {
      // Ticker Setting
      case BoxSettingEnum.longColor:
        return 'longColor';
      case BoxSettingEnum.shortColor:
        return 'shortColor';
      case BoxSettingEnum.isBorderEnabled:
        return 'isBorderEnabled';
      case BoxSettingEnum.isPriceBackgroundAlarmEnabled:
        return 'isPriceBackgroundAlarmEnabled';
      case BoxSettingEnum.isQuoteUnitSignEnabled:
        return 'isQuoteUnitSignEnabled';
      case BoxSettingEnum.isPercentSignEnabled:
        return 'isPercentSignEnabled';
      // Common Setting
      case BoxSettingEnum.isLightMode:
        return 'isLightMode';
      default:
        return '';
    }
  }
}
