// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '../models/patient.dart';

class PatientCard extends StatelessWidget {
  final Patient patient;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onManageDocuments;

  const PatientCard({
    super.key,
    required this.patient,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onManageDocuments,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(patient.status);

    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row: Patient Name & Status Chip
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      patient.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: statusColor, width: 1),
                    ),
                    child: Text(
                      patient.status,
                      style: TextStyle(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // ID, Age & Gender Row
              Row(
                children: [
                  Text(
                    'ID: ${patient.id}',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    patient.gender.toLowerCase() == 'female' ? Icons.female : Icons.male,
                    size: 16,
                    color: Colors.teal,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${patient.gender}, ${patient.age} yrs',
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Condition Row
              Row(
                children: [
                  const Icon(Icons.medical_services_outlined, size: 16, color: Colors.teal),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Condition: ${patient.condition}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),

              // Appointment Row
              Row(
                children: [
                  const Icon(Icons.calendar_today_outlined, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    'Appointment: ${patient.appointmentDate}',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1),
              const SizedBox(height: 8),

              // Action Buttons Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: onManageDocuments,
                    icon: const Icon(Icons.folder_open, size: 18),
                    label: Text('Docs (${patient.documents.length})'),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.teal,
                      visualDensity: VisualDensity.compact,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue, size: 20),
                    onPressed: onEdit,
                    tooltip: 'Edit Patient',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: onDelete,
                    tooltip: 'Delete Patient',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
