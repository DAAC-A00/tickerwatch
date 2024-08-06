// box_enum.enum

enum BoxEnum {
  setting,
  counter,
  person,
}

extension BoxEnumExtension on BoxEnum {
  String get boxName {
    switch (this) {
      case BoxEnum.setting:
        return 'setting';
      case BoxEnum.counter:
        return 'counter';
      case BoxEnum.person:
        return 'person';
      default:
        return '';
    }
  }
}
