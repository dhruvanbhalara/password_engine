// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:password_engine_example/main.dart' show ExampleApp;

void main() {
  group('PasswordGeneratorApp', () {
    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    testWidgets('renders initial UI elements', (WidgetTester tester) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle(); // Wait for animations

      // Verify basic UI elements are present
      expect(find.text('Password Generator Example'), findsOneWidget);
      expect(find.text('Generated Password:'), findsOneWidget);
      expect(find.byKey(const Key('password_display_text')), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
      expect(find.byIcon(Icons.copy), findsOneWidget);
      expect(find.byKey(const Key('generate_password_button')), findsOneWidget);
      expect(find.byKey(const Key('copy_password_button')), findsOneWidget);
      expect(find.text('Password Options'), findsOneWidget);
    });

    testWidgets('generates new password on button press', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Get initial password
      final initialPasswordWidget = find
          .byKey(const Key('password_display_text'))
          .evaluate()
          .first
          .widget as SelectableText;
      final initialPassword = initialPasswordWidget.data!;

      // Tap generate button and wait for animation
      await tester.tap(find.byKey(const Key('generate_password_button')));
      await tester.pump(); // Start animation
      await tester.pumpAndSettle(); // Wait for animation to complete

      // Get new password
      final newPasswordWidget = find
          .byKey(const Key('password_display_text'))
          .evaluate()
          .first
          .widget as SelectableText;
      final newPassword = newPasswordWidget.data!;

      // Verify password changed
      expect(initialPassword, isNot(equals(newPassword)));
    });

    testWidgets('copies password to clipboard', (WidgetTester tester) async {
      // Mock clipboard data
      final mockClipboard = <String, dynamic>{};
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (MethodCall methodCall) async {
          if (methodCall.method == 'Clipboard.setData') {
            mockClipboard['text'] = methodCall.arguments['text'];
            return null;
          }
          if (methodCall.method == 'Clipboard.getData') {
            return mockClipboard;
          }
          return null;
        },
      );

      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Get the generated password
      final passwordWidget = find
          .byKey(const Key('password_display_text'))
          .evaluate()
          .first
          .widget as SelectableText;
      final password = passwordWidget.data!;

      // Test copy button
      await tester.tap(find.byKey(const Key('copy_password_button')));
      await tester.pumpAndSettle();

      // Verify clipboard content using mock
      expect(mockClipboard['text'], equals(password));

      // Verify snackbar appears
      expect(find.text('Password copied to clipboard'), findsOneWidget);
    });

    testWidgets('updates password options', (WidgetTester tester) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Test length slider
      final Slider slider = tester.widget(
        find.byKey(const Key('random_length_slider')),
      );
      expect(slider.value, equals(12.0)); // Default length

      // Test character type checkboxes
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key('checkbox_uppercase')),
            )
            .value,
        isTrue,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key('checkbox_lowercase')),
            )
            .value,
        isTrue,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key('checkbox_numbers')),
            )
            .value,
        isTrue,
      );
      expect(
        tester
            .widget<CheckboxListTile>(
              find.byKey(const Key('checkbox_special_chars')),
            )
            .value,
        isTrue,
      );
    });

    testWidgets('switches strategy without crashing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Verify initial strategy is Random
      expect(find.text('Random'), findsOneWidget);

      // Open dropdown
      await tester.tap(find.byKey(const Key('strategy_dropdown')));
      await tester.pumpAndSettle();

      // Select Memorable strategy
      await tester.tap(find.text('Memorable').last);
      await tester.pumpAndSettle();

      // Verify strategy changed
      expect(find.text('Memorable'), findsOneWidget);

      // Verify slider value was clamped to valid range (max 8 for Memorable)
      final Slider slider = tester.widget(find.byType(Slider));
      expect(slider.value, lessThanOrEqualTo(8.0));
      expect(slider.value, greaterThanOrEqualTo(4.0));

      // Switch back to Random
      await tester.tap(find.text('Memorable'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Random').last);
      await tester.pumpAndSettle();

      // Verify slider value was clamped to valid range (min 12 for Random)
      final Slider sliderRandom = tester.widget(
        find.byKey(const Key('random_length_slider')),
      );
      expect(sliderRandom.value, greaterThanOrEqualTo(12.0));
    });

    testWidgets('prevents deselecting all character types', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const ExampleApp());
      await tester.pumpAndSettle();

      // Ensure we are in Random strategy
      expect(find.text('Random'), findsOneWidget);

      // Deselect Uppercase
      final upperCaseFinder = find.byKey(const Key('checkbox_uppercase'));
      await tester.ensureVisible(upperCaseFinder);
      await tester.tap(upperCaseFinder);
      await tester.pumpAndSettle();

      // Deselect Lowercase
      final lowerCaseFinder = find.byKey(const Key('checkbox_lowercase'));
      await tester.ensureVisible(lowerCaseFinder);
      await tester.tap(lowerCaseFinder);
      await tester.pumpAndSettle();

      // Deselect Numbers
      final numbersFinder = find.byKey(const Key('checkbox_numbers'));
      await tester.ensureVisible(numbersFinder);
      await tester.tap(numbersFinder);
      await tester.pumpAndSettle();

      // Try to deselect Special Characters (last one)
      final specialCharsFinder =
          find.byKey(const Key('checkbox_special_chars'));
      await tester.ensureVisible(specialCharsFinder);
      await tester.tap(specialCharsFinder);
      await tester.pumpAndSettle();

      // Verify Special Characters is still selected
      expect(
        tester.widget<CheckboxListTile>(specialCharsFinder).value,
        isTrue,
      );

      // Verify SnackBar appears
      expect(find.text('At least one character type must be selected'),
          findsOneWidget);
    });
  });
}
