import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../models/patient_document.dart';
import '../services/database_helper.dart';

class DocumentManagementScreen extends StatefulWidget {
  final Patient patient;

  const DocumentManagementScreen({super.key, required this.patient});

  @override
  State<DocumentManagementScreen> createState() => _DocumentManagementScreenState();
}

class _DocumentManagementScreenState extends State<DocumentManagementScreen> {
  late Patient _patient;

  final _titleController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedFileType = 'Lab Report';

  @override
  void initState() {
    super.initState();
    _patient = widget.patient;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _refreshPatient() async {
    final patients = await DatabaseHelper.instance.getPatients();
    final updated = patients.firstWhere((p) => p.id == _patient.id, orElse: () => _patient);
    setState(() {
      _patient = updated;
    });
  }

  void _showAddDocumentDialog() {
    _titleController.clear();
    _noteController.clear();
    _selectedFileType = 'Lab Report';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Patient Document / Report'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Document Title (e.g. Blood Test)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _selectedFileType,
                decoration: const InputDecoration(
                  labelText: 'Document Type',
                  border: OutlineInputBorder(),
                ),
                items: ['Lab Report', 'X-Ray Scan', 'Prescription', 'ECG', 'General']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) {
                  if (val != null) _selectedFileType = val;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                decoration: const InputDecoration(
                  labelText: 'Note / Summary',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              if (_titleController.text.trim().isNotEmpty) {
                final newDoc = PatientDocument(
                  id: 'DOC-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                  patientId: _patient.id,
                  title: _titleController.text.trim(),
                  fileType: _selectedFileType,
                  uploadDate: DateTime.now().toString().substring(0, 10),
                  note: _noteController.text.trim(),
                );
                await DatabaseHelper.instance.addDocument(_patient.id, newDoc);
                if (ctx.mounted) Navigator.pop(ctx);
                _refreshPatient();
              }
            },
            child: const Text('Add Document'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteDocument(String docId) async {
    await DatabaseHelper.instance.deleteDocument(_patient.id, docId);
    _refreshPatient();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Documents: ${_patient.name}'),
        centerTitle: true,
      ),
      body: _patient.documents.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.note_add_outlined, size: 64, color: Colors.grey),
                  const SizedBox(height: 12),
                  const Text('No documents attached yet.', style: TextStyle(fontSize: 16)),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: _showAddDocumentDialog,
                    icon: const Icon(Icons.add),
                    label: const Text('Upload First Document'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _patient.documents.length,
              itemBuilder: (ctx, index) {
                final doc = _patient.documents[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.teal,
                      child: Icon(Icons.description, color: Colors.white),
                    ),
                    title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Type: ${doc.fileType}\nUploaded: ${doc.uploadDate}\nNote: ${doc.note}'),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteDocument(doc.id),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDocumentDialog,
        tooltip: 'Add Document',
        child: const Icon(Icons.add),
      ),
    );
  }
}
