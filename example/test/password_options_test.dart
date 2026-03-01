import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine_example/state/generator_state.dart';
import 'package:password_engine_example/strategies/memorable_password_strategy.dart';
import 'package:password_engine_example/widgets/password_options.dart';

void main() {
  group('PasswordOptions', () {
    testWidgets('renders dropdown and controls', (WidgetTester tester) async {
      final state = GeneratorState();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListenableBuilder(
              listenable: state,
              builder: (context, _) {
                return PasswordOptions(
                  state: state,
                );
              },
            ),
          ),
        ),
      );

      expect(find.text('Password Options'), findsOneWidget);
      expect(find.text('Random'), findsOneWidget);

      await tester.tap(find.text('Random'));
      await tester.pumpAndSettle();

      expect(find.text('Passphrase'), findsWidgets);

      await tester.tap(find.text('Memorable').last);
      await tester.pumpAndSettle();

      expect(state.selectedStrategy, isA<MemorablePasswordStrategy>());
      expect(find.text('Memorable'), findsOneWidget);
    });
  });
}
