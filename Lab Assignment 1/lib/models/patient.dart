import 'patient_document.dart';

class Patient {
  final String id;
  final String name;
  final int age;
  final String gender;
  final String contact;
  final String condition;
  final String appointmentDate;
  final String doctorNotes;
  final String status; // 'Active', 'Completed', 'Pending'
  final List<PatientDocument> documents;

  Patient({
    required this.id,
    required this.name,
    required this.age,
    required this.gender,
    required this.contact,
    required this.condition,
    required this.appointmentDate,
    required this.doctorNotes,
    this.status = 'Active',
    List<PatientDocument>? documents,
  }) : documents = documents ?? [];

  Patient copyWith({
    String? id,
    String? name,
    int? age,
    String? gender,
    String? contact,
    String? condition,
    String? appointmentDate,
    String? doctorNotes,
    String? status,
    List<PatientDocument>? documents,
  }) {
    return Patient(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      contact: contact ?? this.contact,
      condition: condition ?? this.condition,
      appointmentDate: appointmentDate ?? this.appointmentDate,
      doctorNotes: doctorNotes ?? this.doctorNotes,
      status: status ?? this.status,
      documents: documents ?? this.documents,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'age': age,
      'gender': gender,
      'contact': contact,
      'condition': condition,
      'appointmentDate': appointmentDate,
      'doctorNotes': doctorNotes,
      'status': status,
      'documents': documents.map((doc) => doc.toMap()).toList(),
    };
  }

  factory Patient.fromMap(Map<String, dynamic> map) {
    return Patient(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? 'Male',
      contact: map['contact'] ?? '',
      condition: map['condition'] ?? '',
      appointmentDate: map['appointmentDate'] ?? '',
      doctorNotes: map['doctorNotes'] ?? '',
      status: map['status'] ?? 'Active',
      documents: map['documents'] != null
          ? (map['documents'] as List)
              .map((doc) => PatientDocument.fromMap(Map<String, dynamic>.from(doc)))
              .toList()
          : [],
    );
  }
}
