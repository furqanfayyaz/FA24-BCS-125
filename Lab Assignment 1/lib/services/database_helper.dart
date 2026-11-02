import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/patient.dart';
import '../models/patient_document.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static const String _fileName = 'doctor_app_patients.json';

  List<Patient> _memoryCache = [];
  bool _initialized = false;

  DatabaseHelper._init();

  Future<File> _getDatabaseFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  Future<void> initDatabase() async {
    if (_initialized) return;
    try {
      final file = await _getDatabaseFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> jsonList = jsonDecode(content);
          _memoryCache = jsonList
              .map((item) => Patient.fromMap(Map<String, dynamic>.from(item)))
              .toList();
        } else {
          await _seedInitialData(file);
        }
      } else {
        await _seedInitialData(file);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Database init error: $e');
      }
      _seedInMemoryFallback();
    }
    _initialized = true;
  }

  Future<void> _seedInitialData(File file) async {
    _memoryCache = [
      Patient(
        id: 'P101',
        name: 'Sarah Jenkins',
        age: 34,
        gender: 'Female',
        contact: '+1 555-0192',
        condition: 'Hypertension',
        appointmentDate: '2026-10-20',
        doctorNotes: 'Prescribed Lisinopril 10mg daily. Recheck BP in 2 weeks.',
        status: 'Active',
        documents: [
          PatientDocument(
            id: 'DOC-01',
            patientId: 'P101',
            title: 'Blood Pressure Chart',
            fileType: 'Lab Report',
            uploadDate: '2026-10-15',
            note: 'BP readings 138/88 mmHg',
          ),
        ],
      ),
      Patient(
        id: 'P102',
        name: 'Michael Chen',
        age: 45,
        gender: 'Male',
        contact: '+1 555-0143',
        condition: 'Type 2 Diabetes',
        appointmentDate: '2026-10-21',
        doctorNotes: 'A1C level 6.8%. Continue Metformin and daily walking.',
        status: 'Active',
        documents: [
          PatientDocument(
            id: 'DOC-02',
            patientId: 'P102',
            title: 'HbA1c Test Results',
            fileType: 'Lab Report',
            uploadDate: '2026-10-10',
            note: 'Glucose 110 mg/dL',
          ),
        ],
      ),
      Patient(
        id: 'P103',
        name: 'Emma Watson',
        age: 28,
        gender: 'Female',
        contact: '+1 555-0188',
        condition: 'Routine Checkup',
        appointmentDate: '2026-10-18',
        doctorNotes: 'General wellness screening normal.',
        status: 'Completed',
        documents: [],
      ),
    ];
    await _saveToDisk(file);
  }

  void _seedInMemoryFallback() {
    _memoryCache = [
      Patient(
        id: 'P101',
        name: 'Sarah Jenkins',
        age: 34,
        gender: 'Female',
        contact: '+1 555-0192',
        condition: 'Hypertension',
        appointmentDate: '2026-10-20',
        doctorNotes: 'Prescribed Lisinopril 10mg daily.',
        status: 'Active',
      ),
    ];
  }

  Future<void> _saveToDisk([File? fileTarget]) async {
    try {
      final file = fileTarget ?? await _getDatabaseFile();
      final jsonList = _memoryCache.map((p) => p.toMap()).toList();
      await file.writeAsString(jsonEncode(jsonList));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving to disk: $e');
      }
    }
  }

  // CREATE
  Future<void> addPatient(Patient patient) async {
    await initDatabase();
    _memoryCache.insert(0, patient);
    await _saveToDisk();
  }

  // READ (ALL)
  Future<List<Patient>> getPatients() async {
    await initDatabase();
    return List.from(_memoryCache);
  }

  // READ (SEARCH)
  Future<List<Patient>> searchPatients(String query) async {
    await initDatabase();
    if (query.trim().isEmpty) return List.from(_memoryCache);
    final q = query.toLowerCase();
    return _memoryCache.where((p) {
      return p.name.toLowerCase().contains(q) ||
          p.id.toLowerCase().contains(q) ||
          p.condition.toLowerCase().contains(q) ||
          p.gender.toLowerCase().contains(q);
    }).toList();
  }

  // UPDATE
  Future<void> updatePatient(Patient patient) async {
    await initDatabase();
    final index = _memoryCache.indexWhere((p) => p.id == patient.id);
    if (index != -1) {
      _memoryCache[index] = patient;
      await _saveToDisk();
    }
  }

  // DELETE
  Future<void> deletePatient(String patientId) async {
    await initDatabase();
    _memoryCache.removeWhere((p) => p.id == patientId);
    await _saveToDisk();
  }

  // DOCUMENT MANAGEMENT
  Future<void> addDocument(String patientId, PatientDocument doc) async {
    await initDatabase();
    final index = _memoryCache.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      final updatedDocs = List<PatientDocument>.from(_memoryCache[index].documents)..add(doc);
      _memoryCache[index] = _memoryCache[index].copyWith(documents: updatedDocs);
      await _saveToDisk();
    }
  }

  Future<void> deleteDocument(String patientId, String docId) async {
    await initDatabase();
    final index = _memoryCache.indexWhere((p) => p.id == patientId);
    if (index != -1) {
      final updatedDocs = _memoryCache[index].documents.where((d) => d.id != docId).toList();
      _memoryCache[index] = _memoryCache[index].copyWith(documents: updatedDocs);
      await _saveToDisk();
    }
  }
}
