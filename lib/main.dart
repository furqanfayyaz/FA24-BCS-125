import 'package:flutter/material.dart';

void main() {
  runApp(const SalaryCalculatorApp());
}

/// ============================================================================
/// 1. MATERIAL 3 UI LAYOUT & THEMING
/// ============================================================================
/// [SalaryCalculatorApp] serves as the root widget of the application.
/// It configures the overall theme using Flutter's Material 3 design system.
class SalaryCalculatorApp extends StatelessWidget {
  const SalaryCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salary Calculator',
      debugShowCheckedModeBanner: false,
      // Material 3 UI setup: Enabling Material 3 and generating a cohesive
      // color scheme from a single seed color (Teal).
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        // Defining custom card theme data for elevated card containers
        cardTheme: const CardThemeData(
          elevation: 2,
          margin: EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
      home: const SalaryCalculatorScreen(),
    );
  }
}

/// ============================================================================
/// 2. STATE MANAGEMENT
/// ============================================================================
/// [SalaryCalculatorScreen] is a [StatefulWidget] because the UI needs to dynamically
/// change in response to user input (e.g., updating calculated gross salary, tax, and net income).
class SalaryCalculatorScreen extends StatefulWidget {
  const SalaryCalculatorScreen({super.key});

  @override
  State<SalaryCalculatorScreen> createState() => _SalaryCalculatorScreenState();
}

class _SalaryCalculatorScreenState extends State<SalaryCalculatorScreen> {
  /// ==========================================================================
  /// 3. FORM VALIDATION KEYS & CONTROLLERS
  /// ==========================================================================
  /// A [GlobalKey] uniquely identifies the [Form] widget and allows validation
  /// of all child form fields from a single call (`_formKey.currentState!.validate()`).
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// [TextEditingController] instances manage the text being edited in each field.
  /// They provide methods to read the input values and clear the text programmatically.
  final TextEditingController _basicSalaryController = TextEditingController();
  final TextEditingController _allowancesController = TextEditingController();
  final TextEditingController _taxRateController = TextEditingController();
  final TextEditingController _deductionsController = TextEditingController();

  /// State Variables holding calculation outputs:
  /// These variables are mutated inside [setState] to trigger UI rebuilds.
  double _grossSalary = 0.0;
  double _taxAmount = 0.0;
  double _totalDeductions = 0.0;
  double _netSalary = 0.0;
  bool _hasCalculated = false;

  /// Clean up controllers when the state object is removed from the tree.
  /// This prevents memory leaks in Flutter applications.
  @override
  void dispose() {
    _basicSalaryController.dispose();
    _allowancesController.dispose();
    _taxRateController.dispose();
    _deductionsController.dispose();
    super.dispose();
  }

  /// ==========================================================================
  /// 4. TAX LOGIC & CALCULATION ENGINE
  /// ==========================================================================
  /// Computes Gross Salary, Tax Amount, Total Deductions, and Net Monthly Income.
  void _calculateSalary() {
    // First, validate all form fields. If any field fails validation, stop execution.
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Parse string inputs into double precision numbers safely (defaulting to 0.0 if empty).
    final double basicSalary = double.tryParse(_basicSalaryController.text.trim()) ?? 0.0;
    final double allowances = double.tryParse(_allowancesController.text.trim()) ?? 0.0;
    final double taxRate = double.tryParse(_taxRateController.text.trim()) ?? 0.0;
    final double otherDeductions = double.tryParse(_deductionsController.text.trim()) ?? 0.0;

    // --- FORMULAE ---
    // 1. Gross Salary = Basic Salary + Allowances
    final double computedGross = basicSalary + allowances;

    // 2. Tax Amount = Gross Salary * (Tax Rate / 100)
    final double computedTax = computedGross * (taxRate / 100.0);

    // 3. Total Deductions = Tax Amount + Other Deductions
    final double computedTotalDeductions = computedTax + otherDeductions;

    // 4. Net Monthly Income = Gross Salary - Total Deductions
    final double computedNet = computedGross - computedTotalDeductions;

    // State Management: Mutate state inside setState() so Flutter updates the UI elements.
    setState(() {
      _grossSalary = computedGross;
      _taxAmount = computedTax;
      _totalDeductions = computedTotalDeductions;
      _netSalary = computedNet;
      _hasCalculated = true;
    });
  }

  /// Resets all input controllers and calculation states.
  void _resetForm() {
    _formKey.currentState?.reset();
    _basicSalaryController.clear();
    _allowancesController.clear();
    _taxRateController.clear();
    _deductionsController.clear();

    setState(() {
      _grossSalary = 0.0;
      _taxAmount = 0.0;
      _totalDeductions = 0.0;
      _netSalary = 0.0;
      _hasCalculated = false;
    });
  }

  /// ==========================================================================
  /// 5. FORM VALIDATORS
  /// ==========================================================================
  /// Helper function for numeric field validation.
  /// Checks for: non-empty input, valid numeric parsing, and non-negative numbers.
  String? _validateNumericInput(String? value, String fieldName, {bool isRequired = true}) {
    if (value == null || value.trim().isEmpty) {
      if (isRequired) {
        return 'Please enter $fieldName';
      }
      return null;
    }

    final double? parsedValue = double.tryParse(value.trim());
    if (parsedValue == null) {
      return 'Please enter a valid number';
    }

    if (parsedValue < 0) {
      return '$fieldName cannot be negative';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Salary Calculator'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primaryContainer,
        foregroundColor: theme.colorScheme.onPrimaryContainer,
      ),
      // SingleChildScrollView ensures that the UI scrolls smoothly when keyboard appears.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Description Card (Material 3 Card)
            Card(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.calculate_outlined,
                      size: 36,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        'Calculate your Gross Pay, Income Tax, Deductions, and Net Monthly Take-Home Income.',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // INPUT FORM SECTION
            Form(
              key: _formKey,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Earnings & Deductions Input',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Basic Salary Field
                      TextFormField(
                        controller: _basicSalaryController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Basic Monthly Salary (\$)',
                          hintText: 'e.g. 5000',
                          prefixIcon: Icon(Icons.payments_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => _validateNumericInput(val, 'Basic Salary'),
                      ),
                      const SizedBox(height: 16),

                      // Allowances Field
                      TextFormField(
                        controller: _allowancesController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Allowances & Bonuses (\$)',
                          hintText: 'e.g. 500 (Optional)',
                          prefixIcon: Icon(Icons.add_card_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => _validateNumericInput(val, 'Allowances', isRequired: false),
                      ),
                      const SizedBox(height: 16),

                      // Tax Rate Percentage Field
                      TextFormField(
                        controller: _taxRateController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Tax Rate (%)',
                          hintText: 'e.g. 15',
                          prefixIcon: Icon(Icons.percent_outlined),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) {
                          final result = _validateNumericInput(val, 'Tax Rate');
                          if (result != null) return result;
                          if (val != null && val.isNotEmpty) {
                            final rate = double.tryParse(val) ?? 0;
                            if (rate > 100) {
                              return 'Tax rate cannot exceed 100%';
                            }
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Other Deductions Field
                      TextFormField(
                        controller: _deductionsController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        decoration: const InputDecoration(
                          labelText: 'Other Deductions (Pension, Insurance) (\$)',
                          hintText: 'e.g. 200 (Optional)',
                          prefixIcon: Icon(Icons.remove_circle_outline),
                          border: OutlineInputBorder(),
                        ),
                        validator: (val) => _validateNumericInput(val, 'Deductions', isRequired: false),
                      ),
                      const SizedBox(height: 24),

                      // ACTION BUTTONS (Calculate & Reset)
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton.icon(
                              onPressed: _calculateSalary,
                              icon: const Icon(Icons.analytics_outlined),
                              label: const Text('Calculate'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          OutlinedButton.icon(
                            onPressed: _resetForm,
                            icon: const Icon(Icons.refresh_outlined),
                            label: const Text('Reset'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // RESULTS DISPLAY SECTION (Material 3 Cards with Conditional State rendering)
            if (_hasCalculated) ...[
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(
                        'NET MONTHLY INCOME',
                        style: theme.textTheme.labelLarge?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${_netSalary.toStringAsFixed(2)}',
                        style: theme.textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Take-Home Salary after Tax & Deductions',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // BREAKDOWN DETAILS CARD
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salary Breakdown',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        label: 'Gross Monthly Salary',
                        value: '\$${_grossSalary.toStringAsFixed(2)}',
                        isBold: true,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        context,
                        label: 'Estimated Income Tax',
                        value: '-\$${_taxAmount.toStringAsFixed(2)}',
                        color: theme.colorScheme.error,
                      ),
                      const SizedBox(height: 12),
                      _buildSummaryRow(
                        context,
                        label: 'Total Deductions',
                        value: '-\$${_totalDeductions.toStringAsFixed(2)}',
                        color: theme.colorScheme.error,
                      ),
                      const Divider(height: 24),
                      _buildSummaryRow(
                        context,
                        label: 'Annual Net Income (Estimated)',
                        value: '\$${(_netSalary * 12).toStringAsFixed(2)}',
                        isBold: true,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Helper widget to build consistent breakdown summary rows.
  Widget _buildSummaryRow(
    BuildContext context, {
    required String label,
    required String value,
    bool isBold = false,
    Color? color,
  }) {
    final style = TextStyle(
      fontSize: 15,
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
      color: color,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}
