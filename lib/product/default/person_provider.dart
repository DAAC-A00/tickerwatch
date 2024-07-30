// person_provider.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

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
    WidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    _personBox = await Hive.openBox<Person>('personBox');
    state = _personBox.values.toList();
  }

  void addPerson(Person person) {
    _personBox.add(person);
    state = _personBox.values.toList();
  }

  void updatePerson(int index, Person person) {
    _personBox.putAt(index, person);
    state = _personBox.values.toList();
  }

  void deletePerson(int index) {
    _personBox.deleteAt(index);
    state = _personBox.values.toList();
  }
}
