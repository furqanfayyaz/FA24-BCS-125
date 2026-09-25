import 'package:flutter_test/flutter_test.dart';
import 'package:student_card_assignment/main.dart';

void main() {
  testWidgets('Salary Calculator smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SalaryCalculatorApp());

    // Verify that title and key UI elements appear.
    expect(find.text('Salary Calculator'), findsOneWidget);
    expect(find.text('Calculate'), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);
  });
}
