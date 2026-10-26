class PdfDocumentModel {
  final String id;
  final String title;
  final String filePath;
  final int fileSizeKb;
  final String uploadDate;
  final int totalPages;
  int currentPage;
  bool isFavorite;
  bool isBookmark;
  double readingProgress; // 0.0 to 1.0

  PdfDocumentModel({
    required this.id,
    required this.title,
    required this.filePath,
    required this.fileSizeKb,
    required this.uploadDate,
    required this.totalPages,
    this.currentPage = 1,
    this.isFavorite = false,
    this.isBookmark = false,
    this.readingProgress = 0.0,
  });

  PdfDocumentModel copyWith({
    String? id,
    String? title,
    String? filePath,
    int? fileSizeKb,
    String? uploadDate,
    int? totalPages,
    int? currentPage,
    bool? isFavorite,
    bool? isBookmark,
    double? readingProgress,
  }) {
    return PdfDocumentModel(
      id: id ?? this.id,
      title: title ?? this.title,
      filePath: filePath ?? this.filePath,
      fileSizeKb: fileSizeKb ?? this.fileSizeKb,
      uploadDate: uploadDate ?? this.uploadDate,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      isFavorite: isFavorite ?? this.isFavorite,
      isBookmark: isBookmark ?? this.isBookmark,
      readingProgress: readingProgress ?? this.readingProgress,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'filePath': filePath,
      'fileSizeKb': fileSizeKb,
      'uploadDate': uploadDate,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'isFavorite': isFavorite ? 1 : 0,
      'isBookmark': isBookmark ? 1 : 0,
      'readingProgress': readingProgress,
    };
  }

  factory PdfDocumentModel.fromMap(Map<String, dynamic> map) {
    return PdfDocumentModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      filePath: map['filePath'] ?? '',
      fileSizeKb: map['fileSizeKb'] ?? 0,
      uploadDate: map['uploadDate'] ?? '',
      totalPages: map['totalPages'] ?? 1,
      currentPage: map['currentPage'] ?? 1,
      isFavorite: (map['isFavorite'] == 1 || map['isFavorite'] == true),
      isBookmark: (map['isBookmark'] == 1 || map['isBookmark'] == true),
      readingProgress: (map['readingProgress'] ?? 0.0).toDouble(),
    );
  }
}
