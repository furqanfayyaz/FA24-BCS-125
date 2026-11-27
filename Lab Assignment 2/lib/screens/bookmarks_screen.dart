import 'package:flutter/material.dart';
import '../models/pdf_document.dart';
import '../services/pdf_database_helper.dart';
import 'pdf_reader_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  List<PdfDocumentModel> _bookmarkedDocs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    setState(() => _isLoading = true);
    final all = await PdfDatabaseHelper.instance.getDocuments();
    setState(() {
      _bookmarkedDocs = all.where((d) => d.isBookmark || d.isFavorite).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks & Favorites'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _bookmarkedDocs.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.bookmark_border, size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text('No bookmarked documents found.', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookmarkedDocs.length,
                  itemBuilder: (ctx, idx) {
                    final doc = _bookmarkedDocs[idx];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf, color: Colors.indigo, size: 36),
                        title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Page ${doc.currentPage} of ${doc.totalPages} • ${(doc.readingProgress * 100).toInt()}% read'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (doc.isFavorite) const Icon(Icons.star, color: Colors.amber, size: 20),
                            if (doc.isBookmark) const Icon(Icons.bookmark, color: Colors.indigo, size: 20),
                          ],
                        ),
                        onTap: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (c) => PdfReaderScreen(document: doc),
                            ),
                          );
                          _loadBookmarks();
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
