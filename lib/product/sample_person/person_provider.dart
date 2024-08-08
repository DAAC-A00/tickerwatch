// person_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:tickerwatch/product/default/db/box_enum.enum.dart';

import 'person.dart';

final personProvider =
    StateNotifierProvider<PersonNotifier, List<Person>>((ref) {
  return PersonNotifier();
});

class PersonNotifier extends StateNotifier<List<Person>> {
  late Box<Person> _personBox;

  PersonNotifier() : super([]) {
    _init();
  }

  Future<void> _init() async {
    _personBox = await Hive.openBox<Person>(BoxEnum.person.name);
    state = _personBox.values.toList();
  }

  void insertBox(Person person) {
    _personBox.add(person);
    state = _personBox.values.toList();
  }

  void updateBox(int index, Person person) {
    _personBox.putAt(index, person);
    state = _personBox.values.toList();
  }

  void deleteBox(int index) {
    _personBox.deleteAt(index);
    state = _personBox.values.toList();
  }
}
