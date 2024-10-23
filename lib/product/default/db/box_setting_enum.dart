// box_setting_enum.dart

enum BoxSettingEnum {
  // Ticker Setting
  upColor,
  downColor,
  isBorderEnabled,
  borderBlinkMilliseconds,
  isPriceBackgroundAlarmEnabled,
  isQuoteUnitSignEnabled,
  isPercentSignEnabled,
  // Exchange Setting
  bybitApiKey,
  bybitSecretKey,
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
      case BoxSettingEnum.borderBlinkMilliseconds:
        return 'borderBlinkMilliseconds';
      case BoxSettingEnum.isPriceBackgroundAlarmEnabled:
        return 'isPriceBackgroundAlarmEnabled';
      case BoxSettingEnum.isQuoteUnitSignEnabled:
        return 'isQuoteUnitSignEnabled';
      case BoxSettingEnum.isPercentSignEnabled:
        return 'isPercentSignEnabled';
      // Exchange Setting
      case BoxSettingEnum.bybitApiKey:
        return 'bybitApiKey';
      case BoxSettingEnum.bybitSecretKey:
        return 'bybitSecretKey';
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
