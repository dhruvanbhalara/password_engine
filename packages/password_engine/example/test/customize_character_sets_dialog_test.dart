import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/widgets/customize_character_sets_dialog.dart';

void main() {
  group('CustomizeCharacterSetsDialog', () {
    // Reset constants before each test to ensure consistent state
    setUp(() {
      PasswordConstants.resetToDefaults();
    });

    testWidgets('renders all inputs with default values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(onSave: () {}),
          ),
        ),
      );

      // Verify text fields
      expect(
          find.widgetWithText(TextField, 'Uppercase Letters'), findsOneWidget);
      expect(
          find.widgetWithText(TextField, 'Lowercase Letters'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Numbers'), findsOneWidget);
      expect(
          find.widgetWithText(TextField, 'Special Characters'), findsOneWidget);

      // Verify buttons
      expect(find.text('Reset to Defaults'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('updates PasswordConstants on save',
        (WidgetTester tester) async {
      bool onSaveCalled = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(
              onSave: () => onSaveCalled = true,
            ),
          ),
        ),
      );

      // Enter custom values
      await tester.enterText(
        find.widgetWithText(TextField, 'Uppercase Letters'),
        'ABC',
      );
      await tester.enterText(
        find.widgetWithText(TextField, 'Numbers'),
        '123',
      );

      // Tap Save
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      // Verify callback called
      expect(onSaveCalled, isTrue);

      // Verify constants updated
      expect(PasswordConstants.upperCaseLetters, equals('ABC'));
      expect(PasswordConstants.numbers, equals('123'));
    });

    testWidgets('resets to defaults', (WidgetTester tester) async {
      // Set some custom values first
      PasswordConstants.customize(upperCase: 'XYZ');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(onSave: () {}),
          ),
        ),
      );

      // Verify initial custom value in text field
      expect(find.text('XYZ'), findsOneWidget);

      // Tap Reset
      await tester.tap(find.text('Reset to Defaults'));
      await tester.pump();

      // Verify text field updated to default (A-Z)
      // Note: Default is 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', which is long.
      // We check if it changed from 'XYZ'.
      expect(find.text('XYZ'), findsNothing);
      expect(find.text(PasswordConstants.upperCaseLetters), findsOneWidget);
    });
  });
}
