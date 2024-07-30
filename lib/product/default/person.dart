// person.dart

import 'package:hive/hive.dart';

class Person {
  String name;
  int age;

  Person({required this.name, required this.age});
}

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final typeId = 0;

  @override
  Person read(BinaryReader reader) {
    final name = reader.readString();
    final age = reader.readInt();
    return Person(name: name, age: age);
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    writer.writeString(obj.name);
    writer.writeInt(obj.age);
  }
}
