// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

void main() {
  runApp(const StudentCardApp());
}

class StudentCardApp extends StatelessWidget {
  const StudentCardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student Card App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1565C0),
          primary: const Color(0xFF1565C0),
        ),
        useMaterial3: true,
      ),
      home: const StudentCardScreen(),
    );
  }
}

class StudentCardScreen extends StatefulWidget {
  const StudentCardScreen({super.key});

  @override
  State<StudentCardScreen> createState() => _StudentCardScreenState();
}

class _StudentCardScreenState extends State<StudentCardScreen> {
  bool _showBackSide = false;

  void _toggleCardSide() {
    setState(() {
      _showBackSide = !_showBackSide;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'COMSATS University Islamabad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              'Digital Student ID Card',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF1565C0),
        foregroundColor: Colors.white,
        centerTitle: false,
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Main Student ID Card Container
              Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 380),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Column(
                    children: [
                      // Card Header
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF0D47A1), Color(0xFF1976D2)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.school,
                              color: Colors.amber,
                              size: 26,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'CUI ISLAMABAD',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.0,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'STUDENT IDENTITY CARD',
                                    style: TextStyle(
                                      color: Colors.amber,
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.6,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.shade600,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Card Body (Front / Back Side)
                      _showBackSide ? _buildBackSide() : _buildFrontSide(),

                      // Card Footer Switch Button
                      Container(
                        color: Colors.grey.shade100,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                _showBackSide
                                    ? 'Card Side: BACK'
                                    : 'Card Side: FRONT',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade700,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _toggleCardSide,
                              icon: const Icon(Icons.flip, size: 16),
                              label: Text(_showBackSide
                                  ? 'View Front'
                                  : 'View Back'),
                              style: TextButton.styleFrom(
                                foregroundColor: const Color(0xFF1565C0),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Quick Action Buttons
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 8,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Student Pass Verified!'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.verified, size: 18),
                    label: const Text('Verify Card'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1565C0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: _toggleCardSide,
                    icon: const Icon(Icons.swap_horiz, size: 18),
                    label: const Text('Flip Card'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFrontSide() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Profile Image Avatar
          Container(
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF1565C0), width: 3),
            ),
            child: CircleAvatar(
              radius: 44,
              backgroundColor: Colors.blue.shade100,
              backgroundImage: const AssetImage('assets/student_profile.png'),
            ),
          ),
          const SizedBox(height: 12),

          // Student Name
          const Text(
            'FURQAN FAYYAZ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
              color: Color(0xFF0D47A1),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),

          // Registration Number
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Reg #: FA24-BCS-125',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(height: 16),

          const Divider(height: 1),
          const SizedBox(height: 14),

          // Key Academic Information Grid
          _buildInfoRow(
            icon: Icons.account_balance,
            label: 'Department',
            value: 'Computer Science',
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            icon: Icons.school_outlined,
            label: 'Program',
            value: 'BS Computer Science (BSCS)',
          ),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.timeline,
                  label: 'Semester',
                  value: '4th Semester',
                ),
              ),
              Expanded(
                child: _buildInfoRow(
                  icon: Icons.class_outlined,
                  label: 'Section',
                  value: 'BCS-4A',
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            icon: Icons.location_on_outlined,
            label: 'Campus',
            value: 'Islamabad Campus',
          ),
          const SizedBox(height: 16),

          // Visual Barcode Simulation
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.qr_code_2, size: 32, color: Colors.black87),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '||||| |||| |||||| ||||',
                        style: TextStyle(
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          letterSpacing: 1.2,
                          color: Colors.grey.shade800,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Text(
                        'Valid: 2024 - 2028',
                        style: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Emergency & Contact Details',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(height: 14),

          _buildInfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: 'furqan.fayyaz@student.cu.edu.pk',
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            icon: Icons.phone_android,
            label: 'Emergency Phone',
            value: '+92 300 1234567',
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            icon: Icons.credit_card_outlined,
            label: 'Card Issue Date',
            value: 'September 2024',
          ),
          const SizedBox(height: 10),

          _buildInfoRow(
            icon: Icons.event_available_outlined,
            label: 'Card Expiry Date',
            value: 'August 2028',
          ),
          const SizedBox(height: 16),

          const Divider(),
          const SizedBox(height: 10),

          // Instructions & Terms
          const Text(
            'Terms & Conditions:',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            '• This identity card is property of COMSATS University Islamabad.\n'
            '• If found, please return to CUI Security / Registrar Office.\n'
            '• Student must carry this ID card at all times inside campus.',
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade700,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 16, color: const Color(0xFF1565C0)),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
