// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz 1 - Student Registration Form',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const StudentRegistrationScreen(),
    );
  }
}

class StudentRegistrationScreen extends StatefulWidget {
  const StudentRegistrationScreen({super.key});

  @override
  State<StudentRegistrationScreen> createState() =>
      _StudentRegistrationScreenState();
}

class _StudentRegistrationScreenState
    extends State<StudentRegistrationScreen> {
  // Text Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNumController = TextEditingController();

  // Radio Button - Gender
  String _selectedGender = 'Male';

  // Checkbox - Hobbies
  bool _isReadingSelected = false;
  bool _isSportsSelected = false;

  // Option List - Display 2-3 options
  String _selectedOption = 'Option 1';
  final List<String> _optionList = ['Option 1', 'Option 2', 'Option 3'];

  // Selection List - Display 2-3 selectable items
  final Map<String, bool> _selectionListItems = {
    'Item A': false,
    'Item B': false,
    'Item C': false,
  };

  // Dropdown List - Department (CS/IT/SE/AI)
  String _selectedDepartment = 'CS';
  final List<String> _departments = ['CS', 'IT', 'SE', 'AI'];

  @override
  void dispose() {
    _nameController.dispose();
    _regNumController.dispose();
    super.dispose();
  }

  void _clearForm() {
    setState(() {
      _nameController.clear();
      _regNumController.clear();
      _selectedGender = 'Male';
      _isReadingSelected = false;
      _isSportsSelected = false;
      _selectedOption = 'Option 1';
      _selectionListItems.updateAll((key, value) => false);
      _selectedDepartment = 'CS';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form cleared!')),
    );
  }

  void _submitForm() {
    final name = _nameController.text.trim();
    final regNum = _regNumController.text.trim();

    final selectedHobbies = <String>[];
    if (_isReadingSelected) selectedHobbies.add('Reading');
    if (_isSportsSelected) selectedHobbies.add('Sports');

    final selectedListItems = _selectionListItems.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Submitted Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: ${name.isEmpty ? 'N/A' : name}'),
              Text('Registration #: ${regNum.isEmpty ? 'N/A' : regNum}'),
              Text('Gender: $_selectedGender'),
              Text('Hobbies: ${selectedHobbies.isEmpty ? 'None' : selectedHobbies.join(', ')}'),
              Text('Option Selected: $_selectedOption'),
              Text('Selected List Items: ${selectedListItems.isEmpty ? 'None' : selectedListItems.join(', ')}'),
              Text('Department: $_selectedDepartment'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz 1 - Basic Flutter UI Widgets'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 1. Text – Display a heading such as "Student Registration Form"
              const Text(
                'Student Registration Form',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // 2. TextField – Enter Student Name
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Student Name',
                    hintText: 'Enter Student Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 3. TextField – Enter Registration Number
              SizedBox(
                width: 300,
                child: TextField(
                  controller: _regNumController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'Enter Registration Number',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 4. Radio Button – Select Gender (Male/Female)
              const Text(
                'Select Gender:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const Text('Male'),
                  const SizedBox(width: 20),
                  Radio<String>(
                    value: 'Female',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
              const SizedBox(height: 15),

              // 5. Checkbox – Select Hobbies (Reading/Sports)
              const Text(
                'Select Hobbies:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    value: _isReadingSelected,
                    onChanged: (value) {
                      setState(() {
                        _isReadingSelected = value ?? false;
                      });
                    },
                  ),
                  const Text('Reading'),
                  const SizedBox(width: 20),
                  Checkbox(
                    value: _isSportsSelected,
                    onChanged: (value) {
                      setState(() {
                        _isSportsSelected = value ?? false;
                      });
                    },
                  ),
                  const Text('Sports'),
                ],
              ),
              const SizedBox(height: 15),

              // 6. Option List – Display 2 - 3 options
              const Text(
                'Option List:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 280,
                child: Column(
                  children: _optionList.map((option) {
                    return RadioListTile<String>(
                      title: Text(option, textAlign: TextAlign.center),
                      value: option,
                      groupValue: _selectedOption,
                      onChanged: (value) {
                        setState(() {
                          _selectedOption = value!;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 15),

              // 7. Selection List – Display 2 - 3 selectable items
              const Text(
                'Selection List:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              SizedBox(
                width: 280,
                child: Column(
                  children: _selectionListItems.keys.map((item) {
                    return CheckboxListTile(
                      title: Text(item, textAlign: TextAlign.center),
                      value: _selectionListItems[item],
                      onChanged: (bool? value) {
                        setState(() {
                          _selectionListItems[item] = value ?? false;
                        });
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 15),

              // 8. Dropdown List – Select Department (CS/IT/SE/AI)
              const Text(
                'Select Department:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              DropdownButton<String>(
                value: _selectedDepartment,
                items: _departments.map((String dept) {
                  return DropdownMenuItem<String>(
                    value: dept,
                    child: Text(dept),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              // 9. Button – Add a simple button
              ElevatedButton(
                onPressed: _clearForm,
                child: const Text('Simple Button'),
              ),
              const SizedBox(height: 10),

              // 10. Submit Button – Add a Submit button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
                onPressed: _submitForm,
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
