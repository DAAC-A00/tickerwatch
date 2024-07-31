// person_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'default/person.dart';
import 'default/person_provider.dart';

class PersonScreen extends ConsumerWidget {
  const PersonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final persons = ref.watch(personProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Person List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const _PersonDialog(),
              );
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
            subtitle: Text('Age: ${person.age}'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _PersonDialog(
                        person: person,
                        index: index,
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    ref.read(personProvider.notifier).deletePerson(index);
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

class _PersonDialog extends ConsumerStatefulWidget {
  final Person? person;
  final int? index;

  const _PersonDialog({this.person, this.index});

  @override
  __PersonDialogState createState() => __PersonDialogState();
}

class __PersonDialogState extends ConsumerState<_PersonDialog> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  String? _nameErrorText;
  String? _ageErrorText;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _nameController.text = widget.person!.name;
      _ageController.text = widget.person!.age.toString();
    }

    _nameController.addListener(_validateInputs);
    _ageController.addListener(_validateInputs);

    // 초기 유효성 검사 호출
    _validateInputs();
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateInputs);
    _ageController.removeListener(_validateInputs);
    _nameController.dispose();
    _ageController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _nameErrorText =
          _nameController.text.isEmpty ? 'Name cannot be empty' : null;
      _ageErrorText = int.tryParse(_ageController.text) == null
          ? 'Please enter a valid number for age'
          : null;
    });
  }

  bool get _isFormValid => _nameErrorText == null && _ageErrorText == null;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      scrollable: true,
      title: Text(widget.person == null ? 'Add Person' : 'Edit Person'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: _nameErrorText,
            ),
          ),
          TextField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              errorText: _ageErrorText,
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        ElevatedButton(
          onPressed: _isFormValid
              ? () {
                  if (_nameErrorText == null && _ageErrorText == null) {
                    final name = _nameController.text;
                    final age = int.tryParse(_ageController.text) ?? 0;
                    final person = Person(name: name, age: age);

                    if (widget.index == null) {
                      ref.read(personProvider.notifier).addPerson(person);
                    } else {
                      ref
                          .read(personProvider.notifier)
                          .updatePerson(widget.index!, person);
                    }

                    Navigator.of(context).pop();
                  } else {
                    _validateInputs();
                  }
                }
              : null,
          child: const Text('Save'),
        ),
      ],
    );
  }
}
