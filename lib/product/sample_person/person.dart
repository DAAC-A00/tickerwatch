// person.dart

import 'package:hive/hive.dart'; // Hive 패키지를 가져옵니다. Hive는 Flutter에서 사용 가능한 경량 키-값 데이터베이스입니다.

class Person {
  String name; // Person 클래스의 이름을 저장하는 필드입니다.
  int age; // Person 클래스의 나이를 저장하는 필드입니다.
  String birthDate; // Person 클래스의 생년월일을 저장하는 필드입니다.
  String gender; // Person 클래스의 성별을 저장하는 필드입니다.

  Person(
      {required this.name,
      required this.age,
      required this.birthDate,
      required this.gender}); // 생성자 메서드로, 이름, 나이, 생년월일, 성별을 필수적으로 받아 초기화합니다.
}

class PersonAdapter extends TypeAdapter<Person> {
  @override
  final int typeId = 0; // 타입 식별자입니다. 각 어댑터는 고유한 타입 ID를 가져야 합니다.

  @override
  Person read(BinaryReader reader) {
    // 바이너리 데이터를 읽어 Person 객체를 생성합니다.
    final name = reader.readString(); // reader를 사용하여 문자열(name)을 읽어옵니다.
    final age = reader.readInt(); // reader를 사용하여 정수(age)를 읽어옵니다.
    final birthDate =
        reader.readString(); // reader를 사용하여 문자열(birthDate)을 읽어옵니다.
    final gender = reader.readString(); // reader를 사용하여 문자열(gender)을 읽어옵니다.
    return Person(
        name: name,
        age: age,
        birthDate: birthDate,
        gender: gender); // 읽어온 데이터를 사용하여 Person 객체를 반환합니다.
  }

  @override
  void write(BinaryWriter writer, Person obj) {
    // Person 객체를 바이너리 데이터로 씁니다.
    writer.writeString(obj.name); // writer를 사용하여 Person 객체의 이름을 씁니다.
    writer.writeInt(obj.age); // writer를 사용하여 Person 객체의 나이를 씁니다.
    writer.writeString(obj.birthDate); // writer를 사용하여 Person 객체의 생년월일을 씁니다.
    writer.writeString(obj.gender); // writer를 사용하여 Person 객체의 성별을 씁니다.
  }
}
