import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/database_helper.dart';

class AddEditPatientScreen extends StatefulWidget {
  final Patient? patient;

  const AddEditPatientScreen({super.key, this.patient});

  @override
  State<AddEditPatientScreen> createState() => _AddEditPatientScreenState();
}

class _AddEditPatientScreenState extends State<AddEditPatientScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _idController;
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _contactController;
  late TextEditingController _conditionController;
  late TextEditingController _dateController;
  late TextEditingController _notesController;

  String _selectedGender = 'Male';
  String _selectedStatus = 'Active';

  bool get _isEditing => widget.patient != null;

  @override
  void initState() {
    super.initState();
    final p = widget.patient;
    _idController = TextEditingController(text: p?.id ?? 'P${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    _nameController = TextEditingController(text: p?.name ?? '');
    _ageController = TextEditingController(text: p != null ? p.age.toString() : '');
    _contactController = TextEditingController(text: p?.contact ?? '');
    _conditionController = TextEditingController(text: p?.condition ?? '');
    _dateController = TextEditingController(
      text: p?.appointmentDate ?? DateTime.now().toString().substring(0, 10),
    );
    _notesController = TextEditingController(text: p?.doctorNotes ?? '');

    if (p != null) {
      _selectedGender = p.gender;
      _selectedStatus = p.status;
    }
  }

  @override
  void dispose() {
    _idController.dispose();
    _nameController.dispose();
    _ageController.dispose();
    _contactController.dispose();
    _conditionController.dispose();
    _dateController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _savePatient() async {
    if (_formKey.currentState!.validate()) {
      final newPatient = Patient(
        id: _idController.text.trim(),
        name: _nameController.text.trim(),
        age: int.tryParse(_ageController.text.trim()) ?? 0,
        gender: _selectedGender,
        contact: _contactController.text.trim(),
        condition: _conditionController.text.trim(),
        appointmentDate: _dateController.text.trim(),
        doctorNotes: _notesController.text.trim(),
        status: _selectedStatus,
        documents: widget.patient?.documents ?? [],
      );

      if (_isEditing) {
        await DatabaseHelper.instance.updatePatient(newPatient);
      } else {
        await DatabaseHelper.instance.addPatient(newPatient);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_isEditing ? 'Patient details updated!' : 'Patient added successfully!')),
        );
        Navigator.pop(context, true);
      }
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().substring(0, 10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Edit Patient' : 'Add New Patient'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _idController,
                enabled: !_isEditing,
                decoration: const InputDecoration(
                  labelText: 'Patient ID',
                  prefixIcon: Icon(Icons.badge),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter Patient ID' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter Patient Name' : null,
              ),
              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _ageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                        prefixIcon: Icon(Icons.cake),
                        border: OutlineInputBorder(),
                      ),
                      validator: (val) => val == null || val.isEmpty ? 'Enter Age' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedGender,
                      decoration: const InputDecoration(
                        labelText: 'Gender',
                        prefixIcon: Icon(Icons.people),
                        border: OutlineInputBorder(),
                      ),
                      items: ['Male', 'Female', 'Other']
                          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedGender = val);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Phone',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter Phone Number' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _conditionController,
                decoration: const InputDecoration(
                  labelText: 'Diagnosis / Condition',
                  prefixIcon: Icon(Icons.medical_services),
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty ? 'Enter Condition' : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _dateController,
                readOnly: true,
                onTap: _selectDate,
                decoration: const InputDecoration(
                  labelText: 'Appointment Date',
                  prefixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: _selectedStatus,
                decoration: const InputDecoration(
                  labelText: 'Status',
                  prefixIcon: Icon(Icons.assignment_turned_in),
                  border: OutlineInputBorder(),
                ),
                items: ['Active', 'Completed', 'Pending']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _selectedStatus = val);
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Doctor Notes & Prescription',
                  prefixIcon: Icon(Icons.note_alt),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: _savePatient,
                  icon: const Icon(Icons.save),
                  label: Text(_isEditing ? 'Update Patient Details' : 'Save Patient Record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
