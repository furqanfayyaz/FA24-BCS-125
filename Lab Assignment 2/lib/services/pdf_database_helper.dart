import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import '../models/pdf_document.dart';

class PdfDatabaseHelper {
  static final PdfDatabaseHelper instance = PdfDatabaseHelper._init();
  static const String _fileName = 'pdf_reader_utility_data.json';

  List<PdfDocumentModel> _cache = [];
  bool _initialized = false;

  PdfDatabaseHelper._init();

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<void> initDb() async {
    if (_initialized) return;
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final List<dynamic> list = jsonDecode(content);
          _cache = list.map((x) => PdfDocumentModel.fromMap(Map<String, dynamic>.from(x))).toList();
        } else {
          await _seedDefaultData(file);
        }
      } else {
        await _seedDefaultData(file);
      }
    } catch (e) {
      if (kDebugMode) print('DB Init Error: $e');
      _seedFallback();
    }
    _initialized = true;
  }

  Future<void> _seedDefaultData(File file) async {
    _cache = [
      PdfDocumentModel(
        id: 'DOC-01',
        title: 'Mobile App Development Lecture 1.pdf',
        filePath: '/storage/emulated/0/Download/mad_lec1.pdf',
        fileSizeKb: 2450,
        uploadDate: '2026-10-15',
        totalPages: 24,
        currentPage: 8,
        isFavorite: true,
        isBookmark: true,
        readingProgress: 0.35,
      ),
      PdfDocumentModel(
        id: 'DOC-02',
        title: 'Web Technologies Lab Manual v2.pdf',
        filePath: '/storage/emulated/0/Download/web_lab2.pdf',
        fileSizeKb: 4120,
        uploadDate: '2026-10-18',
        totalPages: 45,
        currentPage: 45,
        isFavorite: false,
        isBookmark: false,
        readingProgress: 1.0,
      ),
      PdfDocumentModel(
        id: 'DOC-03',
        title: 'Software Engineering Research Paper.pdf',
        filePath: '/storage/emulated/0/Download/se_paper.pdf',
        fileSizeKb: 1890,
        uploadDate: '2026-10-19',
        totalPages: 12,
        currentPage: 3,
        isFavorite: true,
        isBookmark: true,
        readingProgress: 0.25,
      ),
    ];
    await _saveToDisk(file);
  }

  void _seedFallback() {
    _cache = [
      PdfDocumentModel(
        id: 'DOC-01',
        title: 'Mobile App Development Lecture 1.pdf',
        filePath: '/sample/path.pdf',
        fileSizeKb: 1024,
        uploadDate: '2026-10-15',
        totalPages: 10,
        currentPage: 2,
        readingProgress: 0.2,
      ),
    ];
  }

  Future<void> _saveToDisk([File? target]) async {
    try {
      final file = target ?? await _getFile();
      final list = _cache.map((d) => d.toMap()).toList();
      await file.writeAsString(jsonEncode(list));
    } catch (e) {
      if (kDebugMode) print('Save error: $e');
    }
  }

  Future<List<PdfDocumentModel>> getDocuments() async {
    await initDb();
    return List.from(_cache);
  }

  Future<void> addDocument(PdfDocumentModel doc) async {
    await initDb();
    _cache.insert(0, doc);
    await _saveToDisk();
  }

  Future<void> updateDocument(PdfDocumentModel doc) async {
    await initDb();
    final idx = _cache.indexWhere((d) => d.id == doc.id);
    if (idx != -1) {
      _cache[idx] = doc;
      await _saveToDisk();
    }
  }

  Future<void> deleteDocument(String id) async {
    await initDb();
    _cache.removeWhere((d) => d.id == id);
    await _saveToDisk();
  }

  Future<List<PdfDocumentModel>> searchDocuments(String query) async {
    await initDb();
    if (query.trim().isEmpty) return List.from(_cache);
    final q = query.toLowerCase();
    return _cache.where((d) => d.title.toLowerCase().contains(q)).toList();
  }
}
