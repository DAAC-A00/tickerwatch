// box_enum.enum

enum BoxEnum {
  settingBox,
  counterBox,
  personBox,
}

extension BoxEnumExtension on BoxEnum {
  String get name {
    switch (this) {
      case BoxEnum.settingBox:
        return 'settingBox';
      case BoxEnum.counterBox:
        return 'counterBox';
      case BoxEnum.personBox:
        return 'personBox';
      default:
        return '';
    }
  }
}
