// person_form_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'person.dart';
import 'person_provider.dart';

class PersonFormScreen extends ConsumerStatefulWidget {
  final Person? person;
  final int? index;

  const PersonFormScreen({super.key, this.person, this.index});

  @override
  PersonFormScreenState createState() => PersonFormScreenState();
}

class PersonFormScreenState extends ConsumerState<PersonFormScreen> {
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _selectedGenderController = TextEditingController();
  String? _nameErrorText;
  String? _ageErrorText;
  String? _birthDateErrorText;
  String? _genderErrorText;

  @override
  void initState() {
    super.initState();
    if (widget.person != null) {
      _nameController.text = widget.person!.name;
      _ageController.text = widget.person!.age.toString();
      _birthDateController.text = widget.person!.birthDate;
      _selectedGenderController.text = widget.person!.gender;
    }

    _nameController.addListener(_validateInputs);
    _ageController.addListener(_validateInputs);
    _birthDateController.addListener(_validateInputs);
    _selectedGenderController.addListener(_validateInputs);

    // 초기 유효성 검사 호출
    _validateInputs();
  }

  @override
  void dispose() {
    _nameController.removeListener(_validateInputs);
    _ageController.removeListener(_validateInputs);
    _birthDateController.removeListener(_validateInputs);
    _selectedGenderController.removeListener(_validateInputs);
    _nameController.dispose();
    _ageController.dispose();
    _birthDateController.dispose();
    _selectedGenderController.dispose();
    super.dispose();
  }

  void _validateInputs() {
    setState(() {
      _nameErrorText =
          _nameController.text.isEmpty ? 'Name cannot be empty' : null;
      _ageErrorText = int.tryParse(_ageController.text) == null
          ? 'Please enter a valid number for age'
          : null;
      _birthDateErrorText = _birthDateController.text.isEmpty
          ? 'Birth Date cannot be empty'
          : null;
      _genderErrorText = _selectedGenderController.text.isEmpty
          ? 'Gender cannot be empty'
          : null;
    });
  }

  bool get _isFormValid =>
      _nameErrorText == null &&
      _ageErrorText == null &&
      _birthDateErrorText == null &&
      _genderErrorText == null;

  void _showGenderBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: ['Male', 'Female', 'Other'].map((String value) {
            return ListTile(
              title: Text(value),
              onTap: () {
                setState(() {
                  _selectedGenderController.text = value;
                  _validateInputs();
                });
                Navigator.pop(context);
              },
            );
          }).toList(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.person == null ? 'Add Person' : 'Edit Person'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
            TextField(
              controller: _birthDateController,
              decoration: InputDecoration(
                labelText: 'Birth Date',
                errorText: _birthDateErrorText,
              ),
              keyboardType: TextInputType.number,
            ),
            GestureDetector(
              onTap: () => _showGenderBottomSheet(context),
              child: AbsorbPointer(
                child: TextField(
                  controller: _selectedGenderController,
                  decoration: InputDecoration(
                    labelText: 'Gender',
                    errorText: _genderErrorText,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  ElevatedButton(
                    onPressed: _isFormValid
                        ? () {
                            if (_nameErrorText == null &&
                                _ageErrorText == null) {
                              final String name = _nameController.text;
                              final int age =
                                  int.tryParse(_ageController.text) ?? 0;
                              final String birthDate =
                                  _birthDateController.text;
                              final String gender =
                                  _selectedGenderController.text;
                              final Person person = Person(
                                  name: name,
                                  age: age,
                                  birthDate: birthDate,
                                  gender: gender);

                              if (widget.index == null) {
                                ref
                                    .read(personProvider.notifier)
                                    .insertBox(person);
                              } else {
                                ref
                                    .read(personProvider.notifier)
                                    .updateBox(widget.index!, person);
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
