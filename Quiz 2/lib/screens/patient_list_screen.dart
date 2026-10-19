// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/patient.dart';
import '../services/database_helper.dart';
import '../widgets/patient_card.dart';
import 'add_edit_patient_screen.dart';
import 'patient_detail_screen.dart';
import 'document_management_screen.dart';

class PatientListScreen extends StatefulWidget {
  const PatientListScreen({super.key});

  @override
  State<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends State<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Patient> _patients = [];
  bool _isLoading = true;
  String _selectedFilter = 'All';

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadPatients() async {
    setState(() => _isLoading = true);
    final query = _searchController.text.trim();
    final list = await DatabaseHelper.instance.searchPatients(query);

    setState(() {
      if (_selectedFilter == 'All') {
        _patients = list;
      } else {
        _patients = list.where((p) => p.status == _selectedFilter).toList();
      }
      _isLoading = false;
    });
  }

  Future<void> _deletePatient(Patient patient) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Patient?'),
        content: Text('Delete record for ${patient.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await DatabaseHelper.instance.deletePatient(patient.id);
      _loadPatients();
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeCount = _patients.where((p) => p.status == 'Active').length;

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Doctor Patient Portal', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text('Dr. Smith\'s Clinic', style: TextStyle(fontSize: 12, color: Colors.white70)),
          ],
        ),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadPatients,
            tooltip: 'Refresh Patients',
          ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            color: Colors.teal.shade50,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatTile('Total Records', '${_patients.length}', Colors.teal),
                _buildStatTile('Active Patients', '$activeCount', Colors.green),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => _loadPatients(),
              decoration: InputDecoration(
                hintText: 'Search patient by name, ID, condition...',
                prefixIcon: const Icon(Icons.search, color: Colors.teal),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _loadPatients();
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

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['All', 'Active', 'Completed', 'Pending'].map((filter) {
                final isSelected = _selectedFilter == filter;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(filter),
                    selected: isSelected,
                    selectedColor: Colors.teal.shade100,
                    onSelected: (val) {
                      setState(() {
                        _selectedFilter = filter;
                      });
                      _loadPatients();
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 6),

          // Patient List View
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _patients.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                            const SizedBox(height: 12),
                            const Text('No patients found.', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 8),
                            ElevatedButton.icon(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => const AddEditPatientScreen(),
                                  ),
                                );
                                if (result == true) _loadPatients();
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add Patient'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _loadPatients,
                        child: ListView.builder(
                          itemCount: _patients.length,
                          itemBuilder: (ctx, index) {
                            final patient = _patients[index];
                            return PatientCard(
                              patient: patient,
                              onTap: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => PatientDetailScreen(patient: patient),
                                  ),
                                );
                                if (result == true) _loadPatients();
                              },
                              onEdit: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => AddEditPatientScreen(patient: patient),
                                  ),
                                );
                                if (result == true) _loadPatients();
                              },
                              onDelete: () => _deletePatient(patient),
                              onManageDocuments: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (ctx) => DocumentManagementScreen(patient: patient),
                                  ),
                                );
                                _loadPatients();
                              },
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (ctx) => const AddEditPatientScreen(),
            ),
          );
          if (result == true) _loadPatients();
        },
        icon: const Icon(Icons.person_add),
        label: const Text('Add Patient'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildStatTile(String label, String value, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: color.withOpacity(0.2),
          child: Text(value, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
        ),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
      ],
    );
  }
}
