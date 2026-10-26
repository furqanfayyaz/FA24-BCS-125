// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/pdf_document.dart';
import '../services/pdf_database_helper.dart';
import 'pdf_reader_screen.dart';
import 'scanner_screen.dart';
import 'converter_screen.dart';
import 'bookmarks_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<PdfDocumentModel> _documents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadDocs() async {
    setState(() => _isLoading = true);
    final query = _searchController.text.trim();
    final list = await PdfDatabaseHelper.instance.searchDocuments(query);
    setState(() {
      _documents = list;
      _isLoading = false;
    });
  }

  Future<void> _deleteDoc(String id) async {
    await PdfDatabaseHelper.instance.deleteDocument(id);
    _loadDocs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('PDF Reader & Utility Suite', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Lab Mid • FA24-BCS-125', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark),
            onPressed: () async {
              await Navigator.push(context, MaterialPageRoute(builder: (c) => const BookmarksScreen()));
              _loadDocs();
            },
            tooltip: 'Bookmarks',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const SettingsScreen())),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Quick Utility Buttons Row
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.indigo.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildQuickAction(
                  icon: Icons.document_scanner,
                  label: 'Scan PDF',
                  color: Colors.indigo,
                  onTap: () async {
                    final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const ScannerScreen()));
                    if (res == true) _loadDocs();
                  },
                ),
                _buildQuickAction(
                  icon: Icons.transform,
                  label: 'PDF Tools',
                  color: Colors.teal,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const ConverterScreen())),
                ),
                _buildQuickAction(
                  icon: Icons.bookmark,
                  label: 'Bookmarks',
                  color: Colors.orange,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const BookmarksScreen())),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _loadDocs(),
              decoration: InputDecoration(
                hintText: 'Search PDF documents...',
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadDocs();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
            ),
          ),

          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Recent Documents', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('${_documents.length} files', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 8),

          // Document List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _documents.isEmpty
                    ? const Center(child: Text('No PDF documents found.'))
                    : ListView.builder(
                        itemCount: _documents.length,
                        itemBuilder: (ctx, idx) {
                          final doc = _documents[idx];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            child: ListTile(
                              contentPadding: const EdgeInsets.all(12),
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.picture_as_pdf, color: Colors.indigo, size: 32),
                              ),
                              title: Text(doc.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text('${(doc.fileSizeKb / 1024).toStringAsFixed(1)} MB • ${doc.uploadDate}', style: const TextStyle(fontSize: 12)),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: doc.readingProgress,
                                    backgroundColor: Colors.grey.shade200,
                                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.indigo),
                                  ),
                                ],
                              ),
                              trailing: PopupMenuButton<String>(
                                onSelected: (val) async {
                                  if (val == 'delete') {
                                    await _deleteDoc(doc.id);
                                  }
                                },
                                itemBuilder: (ctx) => [
                                  const PopupMenuItem(value: 'delete', child: Text('Delete Document')),
                                ],
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (c) => PdfReaderScreen(document: doc)),
                                );
                                _loadDocs();
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final res = await Navigator.push(context, MaterialPageRoute(builder: (c) => const ScannerScreen()));
          if (res == true) _loadDocs();
        },
        icon: const Icon(Icons.document_scanner),
        label: const Text('Scan PDF'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildQuickAction({required IconData icon, required String label, required Color color, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: color.withOpacity(0.15),
              child: Icon(icon, color: color),
            ),
            const SizedBox(height: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
