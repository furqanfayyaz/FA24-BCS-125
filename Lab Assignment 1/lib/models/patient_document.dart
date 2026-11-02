class PatientDocument {
  final String id;
  final String patientId;
  final String title;
  final String fileType;
  final String uploadDate;
  final String note;

  PatientDocument({
    required this.id,
    required this.patientId,
    required this.title,
    required this.fileType,
    required this.uploadDate,
    required this.note,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientId': patientId,
      'title': title,
      'fileType': fileType,
      'uploadDate': uploadDate,
      'note': note,
    };
  }

  factory PatientDocument.fromMap(Map<String, dynamic> map) {
    return PatientDocument(
      id: map['id'] ?? '',
      patientId: map['patientId'] ?? '',
      title: map['title'] ?? '',
      fileType: map['fileType'] ?? 'General',
      uploadDate: map['uploadDate'] ?? '',
      note: map['note'] ?? '',
    );
  }
}
