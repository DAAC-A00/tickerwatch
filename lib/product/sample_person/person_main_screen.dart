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

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              context.push('/person/add');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final person = persons[index];
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