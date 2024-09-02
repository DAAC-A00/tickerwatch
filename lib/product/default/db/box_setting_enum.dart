// box_setting_enum.dart

enum BoxSettingEnum {
  // Ticker Setting
  upColor,
  downColor,
  isBorderEnabled,
  isPriceBackgroundAlarmEnabled,
  isQuoteUnitSignEnabled,
  isPercentSignEnabled,
  // Common Setting
  isLightMode,
  isAdminMode,
  isSuperMode,
}

extension BoxSettingEnumExtension on BoxSettingEnum {
  String get name {
    switch (this) {
      // Ticker Setting
      case BoxSettingEnum.upColor:
        return 'upColor';
      case BoxSettingEnum.downColor:
        return 'downColor';
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
      case BoxSettingEnum.isAdminMode:
        return 'isAdminMode';
      case BoxSettingEnum.isSuperMode:
        return 'isSuperMode';
    }
  }
}
