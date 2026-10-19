import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/database_helper.dart';
import 'add_edit_patient_screen.dart';
import 'document_management_screen.dart';

class PatientDetailScreen extends StatefulWidget {
  final Patient patient;

  const PatientDetailScreen({super.key, required this.patient});

  @override
  State<PatientDetailScreen> createState() => _PatientDetailScreenState();
}

class _PatientDetailScreenState extends State<PatientDetailScreen> {
  late Patient _patient;

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  Future<void> _refreshPatient() async {
    final patients = await DatabaseHelper.instance.getPatients();
    final updated = patients.firstWhere((p) => p.id == _patient.id, orElse: () => _patient);
    setState(() {
      _patient = updated;
    });
  }

  Future<void> _deletePatient() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Patient Record?'),
        content: Text('Are you sure you want to delete ${_patient.name}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deletePatient(_patient.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_patient.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => AddEditPatientScreen(patient: _patient),
                ),
              );
              if (result == true) {
                _refreshPatient();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: _deletePatient,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Card
            Card(
              color: Colors.teal.shade50,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.teal,
                      child: Text(
                        _patient.name.substring(0, 1).toUpperCase(),
                        style: const TextStyle(fontSize: 24, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _patient.name,
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          Text('ID: ${_patient.id} • ${_patient.gender}, ${_patient.age} yrs'),
                          const SizedBox(height: 4),
                          Text('Phone: ${_patient.contact}', style: const TextStyle(color: Colors.teal)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Medical Info
            const Text('Medical Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.medical_services, color: Colors.teal),
              title: const Text('Condition / Diagnosis'),
              subtitle: Text(_patient.condition, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month, color: Colors.teal),
              title: const Text('Appointment Date'),
              subtitle: Text(_patient.appointmentDate),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Colors.teal),
              title: const Text('Status'),
              subtitle: Text(_patient.status),
            ),
            const Divider(),

            // Doctor Notes
            const Text('Doctor Notes & Prescription', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Text(
                _patient.doctorNotes.isNotEmpty ? _patient.doctorNotes : 'No doctor notes added yet.',
                style: const TextStyle(fontSize: 15),
              ),
            ),
            const SizedBox(height: 20),

            // Attached Documents
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Medical Documents', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton.icon(
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (ctx) => DocumentManagementScreen(patient: _patient),
                      ),
                    );
                    _refreshPatient();
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Manage Docs'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _patient.documents.isEmpty
                ? const Text('No attached documents/reports.')
                : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _patient.documents.length,
                    itemBuilder: (ctx, index) {
                      final doc = _patient.documents[index];
                      return Card(
                        child: ListTile(
                          leading: const Icon(Icons.picture_as_pdf, color: Colors.red),
                          title: Text(doc.title),
                          subtitle: Text('${doc.fileType} • ${doc.uploadDate}\nNote: ${doc.note}'),
                          isThreeLine: true,
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
