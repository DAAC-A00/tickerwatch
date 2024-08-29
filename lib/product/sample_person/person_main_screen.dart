// person_main_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'person_provider.dart';

class PersonMainScreen extends ConsumerWidget {
  const PersonMainScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons = ref.watch(personProvider);
    final searchQuery = ref.watch(searchQueryProvider);

    // 검색된 결과 필터링
    final filteredPersons = persons.where((person) {
      return person.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/person/add');
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: PersonSearchDelegate(ref),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredPersons.length,
        itemBuilder: (context, index) {
          final person = filteredPersons[index];
          return ListTile(
            title: Text(person.name),
            subtitle: Text(
              'Age: ${person.age}, Birth Date: ${person.birthDate}, Gender: ${person.gender}',
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    context
                        .push('/person/edit/$index', extra: {'person': person});
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(personProvider.notifier).deleteBox(index);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// 검색 쿼리를 관리하는 Provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// 검색 위젯
class PersonSearchDelegate extends SearchDelegate<String> {
  final WidgetRef ref;

  PersonSearchDelegate(this.ref); // ref를 생성자에서 받음

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = ''; // 검색어 초기화
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final query = this.query;

    final persons = ref.watch(personProvider); // ref를 사용하여 데이터 가져오기
    final filteredPersons = persons.where((person) {
      return person.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredPersons.length,
      itemBuilder: (context, index) {
        final person = filteredPersons[index];
        return ListTile(
          title: Text(person.name),
          onTap: () {
            close(context, person.name);
          },
        );
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container(); // 결과 화면은 필요에 따라 구현
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }
}
