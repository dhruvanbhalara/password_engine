import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine_example/widgets/action_buttons.dart';

void main() {
  group('ActionButtons', () {
    testWidgets('triggers callbacks', (WidgetTester tester) async {
      bool copyCalled = false;
      bool generateCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ActionButtons(
              onCopy: () => copyCalled = true,
              onGenerate: () => generateCalled = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Copy Password'));
      expect(copyCalled, isTrue);

      await tester.tap(find.text('Generate New Password'));
      expect(generateCalled, isTrue);
    });
  });
}
