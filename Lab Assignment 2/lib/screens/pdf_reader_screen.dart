// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/pdf_document.dart';
import '../services/pdf_database_helper.dart';

class PdfReaderScreen extends StatefulWidget {
  final PdfDocumentModel document;

  const PdfReaderScreen({super.key, required this.document});

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {
  late PdfDocumentModel _doc;
  bool _isDarkMode = false;
  double _zoomLevel = 1.0;

  @override
  void initState() {
    super.initState();
    _doc = widget.document;
  }

  Future<void> _updateProgress(int page) async {
    setState(() {
      _doc.currentPage = page;
      _doc.readingProgress = page / _doc.totalPages;
    });
    await PdfDatabaseHelper.instance.updateDocument(_doc);
  }

  Future<void> _toggleBookmark() async {
    setState(() {
      _doc.isBookmark = !_doc.isBookmark;
    });
    await PdfDatabaseHelper.instance.updateDocument(_doc);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(_doc.isBookmark ? 'Added to Bookmarks' : 'Removed from Bookmarks')),
      );
    }
  }

  Future<void> _toggleFavorite() async {
    setState(() {
      _doc.isFavorite = !_doc.isFavorite;
    });
    await PdfDatabaseHelper.instance.updateDocument(_doc);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = _isDarkMode ? const Color(0xFF121212) : const Color(0xFFFAFAFA);
    final textColor = _isDarkMode ? Colors.white70 : Colors.black87;
    final paperColor = _isDarkMode ? const Color(0xFF1E1E1E) : Colors.white;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(_doc.title, style: const TextStyle(fontSize: 16)),
        actions: [
          IconButton(
            icon: Icon(_doc.isBookmark ? Icons.bookmark : Icons.bookmark_border),
            onPressed: _toggleBookmark,
            tooltip: 'Bookmark Page',
          ),
          IconButton(
            icon: Icon(_doc.isFavorite ? Icons.star : Icons.star_border, color: Colors.amber),
            onPressed: _toggleFavorite,
            tooltip: 'Favorite',
          ),
          IconButton(
            icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => setState(() => _isDarkMode = !_isDarkMode),
            tooltip: 'Toggle Reading Theme',
          ),
        ],
      ),
      body: Column(
        children: [
          // Reading Progress Bar
          LinearProgressIndicator(
            value: _doc.readingProgress,
            backgroundColor: Colors.grey.shade300,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
          ),
          // Page Info & Zoom Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: _isDarkMode ? const Color(0xFF222222) : Colors.grey.shade200,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Page ${_doc.currentPage} of ${_doc.totalPages} (${(_doc.readingProgress * 100).toInt()}% read)',
                  style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.zoom_out, size: 20),
                      onPressed: () => setState(() => _zoomLevel = (_zoomLevel - 0.2).clamp(0.8, 2.0)),
                    ),
                    Text('${(_zoomLevel * 100).toInt()}%', style: TextStyle(color: textColor)),
                    IconButton(
                      icon: const Icon(Icons.zoom_in, size: 20),
                      onPressed: () => setState(() => _zoomLevel = (_zoomLevel + 0.2).clamp(0.8, 2.0)),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // PDF Simulated Page Viewer Canvas
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                child: InteractiveViewer(
                  scaleEnabled: true,
                  child: Container(
                    width: 340 * _zoomLevel,
                    height: 480 * _zoomLevel,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: paperColor,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              _doc.title,
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Page ${_doc.currentPage}',
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Divider(height: 24),
                        const SizedBox(height: 10),
                        Text(
                          'Chapter ${_doc.currentPage}: Document Content & Notes',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'This is page ${_doc.currentPage} of the selected PDF document.\n\n'
                          'The comprehensive PDF Reader & Utility app supports full navigation, document rendering simulation, bookmarking, and search history.\n\n'
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.',
                          style: TextStyle(fontSize: 14, color: textColor, height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Bottom Navigation Toolbar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: _isDarkMode ? const Color(0xFF222222) : Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _doc.currentPage > 1 ? () => _updateProgress(_doc.currentPage - 1) : null,
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Previous'),
                ),
                Text(
                  '${_doc.currentPage} / ${_doc.totalPages}',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
                ),
                ElevatedButton.icon(
                  onPressed: _doc.currentPage < _doc.totalPages ? () => _updateProgress(_doc.currentPage + 1) : null,
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Next'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigo,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
