import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/widgets/customize_character_sets_dialog.dart';

void main() {
  group('CustomizeCharacterSetsDialog', () {
    testWidgets('renders all inputs with default values', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(
              initialProfile: CharacterSetProfile.defaultProfile,
              onSave: (_) {},
            ),
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
      expect(find.widgetWithText(TextField, 'Uppercase (Non-Ambiguous)'),
          findsOneWidget);
      expect(find.widgetWithText(TextField, 'Lowercase (Non-Ambiguous)'),
          findsOneWidget);
      expect(find.widgetWithText(TextField, 'Numbers (Non-Ambiguous)'),
          findsOneWidget);
      expect(find.widgetWithText(TextField, 'Special (Non-Ambiguous)'),
          findsOneWidget);

      // Verify buttons
      expect(find.text('Reset to Defaults'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Save'), findsOneWidget);
    });

    testWidgets('updates profile on save', (WidgetTester tester) async {
      CharacterSetProfile? savedProfile;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(
              initialProfile: CharacterSetProfile.defaultProfile,
              onSave: (profile) => savedProfile = profile,
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
      expect(savedProfile, isNotNull);

      // Verify profile updated
      expect(savedProfile!.upperCaseLetters, equals('ABC'));
      expect(savedProfile!.numbers, equals('123'));
    });

    testWidgets('resets to defaults', (WidgetTester tester) async {
      final customProfile = CharacterSetProfile(
        upperCaseLetters: 'XYZ',
        lowerCaseLetters: 'abc',
        numbers: '123',
        specialCharacters: '!@#',
        upperCaseLettersNonAmbiguous: 'XY',
        lowerCaseLettersNonAmbiguous: 'ab',
        numbersNonAmbiguous: '12',
        specialCharactersNonAmbiguous: '!@',
      );
      CharacterSetProfile? savedProfile;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomizeCharacterSetsDialog(
              initialProfile: customProfile,
              onSave: (profile) => savedProfile = profile,
            ),
          ),
        ),
      );

      // Verify initial custom value in text field
      expect(find.text('XYZ'), findsOneWidget);

      // Tap Reset
      await tester.tap(find.text('Reset to Defaults'));
      await tester.pump();

      // Verify profile reset to default
      expect(savedProfile, isNotNull);
      expect(savedProfile!.upperCaseLetters,
          equals(CharacterSetProfile.defaultProfile.upperCaseLetters));
      expect(savedProfile!.numbers,
          equals(CharacterSetProfile.defaultProfile.numbers));

      // Verify text field updated to default (A-Z)
      expect(find.text('XYZ'), findsNothing);
      expect(find.text(CharacterSetProfile.defaultProfile.upperCaseLetters),
          findsOneWidget);
    });
  });
}
