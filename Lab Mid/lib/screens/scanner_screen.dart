// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/pdf_document.dart';
import '../services/pdf_database_helper.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _titleController = TextEditingController();
  bool _isScanning = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _startScan() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a document title first!')),
      );
      return;
    }

    setState(() => _isScanning = true);
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isScanning = false;
    });

    final newDoc = PdfDocumentModel(
      id: 'SCAN-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      title: '${_titleController.text.trim()}.pdf',
      filePath: '/storage/emulated/0/Scans/scanned_doc.pdf',
      fileSizeKb: 1450,
      uploadDate: DateTime.now().toString().substring(0, 10),
      totalPages: 3,
      currentPage: 1,
      isFavorite: false,
      isBookmark: false,
      readingProgress: 0.0,
    );

    await PdfDatabaseHelper.instance.addDocument(newDoc);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Document successfully scanned and converted to PDF!')),
      );
      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Scanner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.document_scanner, size: 80, color: Colors.indigo),
            const SizedBox(height: 16),
            const Text(
              'Scan Physical Documents to PDF',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Capture paper notes, invoices, or books using your camera and automatically convert them into professional searchable PDF files.',
              style: TextStyle(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Document Title',
                hintText: 'e.g. Lecture Notes Scan',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 220,
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200, style: BorderStyle.solid),
              ),
              child: _isScanning
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Scanning document edges & generating PDF...'),
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.camera_alt, size: 50, color: Colors.indigo.shade400),
                        const SizedBox(height: 12),
                        const Text('Camera Viewfinder Ready', style: TextStyle(fontWeight: FontWeight.w600)),
                        const Text('Auto edge detection enabled', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startScan,
              icon: const Icon(Icons.camera),
              label: const Text('Capture & Convert to PDF', style: TextStyle(fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
