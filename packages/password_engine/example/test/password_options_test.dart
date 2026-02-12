import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/strategies/memorable_password_strategy.dart';
import 'package:password_engine_example/widgets/password_options.dart';

void main() {
  group('PasswordOptions', () {
    testWidgets('renders dropdown and controls', (WidgetTester tester) async {
      final strategies = [
        RandomPasswordStrategy(),
        MemorablePasswordStrategy(),
      ];
      IPasswordGenerationStrategy selectedStrategy = strategies[0];

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatefulBuilder(
              builder: (context, setState) {
                return PasswordOptions(
                  strategies: strategies,
                  selectedStrategy: selectedStrategy,
                  onStrategyChanged: (value) {
                    setState(() {
                      selectedStrategy = value!;
                    });
                  },
                  strategyControls: const Text('Controls Placeholder'),
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Password Options'), findsOneWidget);
      expect(find.text('Random'), findsOneWidget);
      expect(find.text('Controls Placeholder'), findsOneWidget);

      await tester.tap(find.text('Random'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Memorable').last);
      await tester.pumpAndSettle();

      expect(selectedStrategy, isA<MemorablePasswordStrategy>());
      expect(find.text('Memorable'), findsOneWidget);
    });
  });
}
