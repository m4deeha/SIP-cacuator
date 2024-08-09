import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stock/main.dart'; 

void main() {
  testWidgets('InvestmentScreen has a title, input fields, and investment results', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(
      home: InvestmentScreen(),
    ));

    expect(find.text('Investment Calculator'), findsOneWidget);

    expect(find.byType(TextField), findsNWidgets(3));

    expect(find.text('Investment Amount: \$1000.00'), findsOneWidget);
    expect(find.text('Estimated Returns: \$232339.08'), findsOneWidget);

    expect(find.text('Invest Now'), findsOneWidget);

    await tester.enterText(find.byType(TextField).at(0), '2000');
    await tester.enterText(find.byType(TextField).at(1), '15');
    await tester.enterText(find.byType(TextField).at(2), '5');
    await tester.pump(); 
    expect(find.text('Investment Amount: \$2000.00'), findsOneWidget);
    expect(find.textContaining('Estimated Returns:'), findsOneWidget);
  });
}
