import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/state/generator_state.dart';
import 'package:password_engine_example/widgets/password_display.dart';

class MockGeneratorState extends ChangeNotifier implements GeneratorState {
  PasswordStrength _strength = PasswordStrength.medium;
  PasswordFeedback _feedback =
      const PasswordFeedback(strength: PasswordStrength.medium);
  String _passwordStr = 'password';
  bool _isVisible = true;

  void setMockState({
    required PasswordStrength strength,
    required PasswordFeedback feedback,
    required String password,
    required bool isVisible,
  }) {
    _strength = strength;
    _feedback = feedback;
    _passwordStr = password;
    _isVisible = isVisible;
    notifyListeners();
  }

  @override
  PasswordStrength get strength => _strength;

  @override
  PasswordFeedback get feedback => _feedback;

  @override
  bool get isPasswordVisible => _isVisible;

  @override
  SensitivePassword get password => SensitivePassword(_passwordStr);

  @override
  bool get useZxcvbn => false;

  @override
  void togglePasswordVisibility() {
    _isVisible = !_isVisible;
    notifyListeners();
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('PasswordDisplay', () {
    testWidgets('renders password and strength', (WidgetTester tester) async {
      final animationController = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );
      final animation =
          Tween<double>(begin: 0, end: 1).animate(animationController);
      animationController.forward();

      final state = MockGeneratorState()
        ..setMockState(
          password: 'test-password',
          strength: PasswordStrength.strong,
          feedback: const PasswordFeedback(strength: PasswordStrength.strong),
          isVisible: true,
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDisplay(
              state: state,
              fadeAnimation: animation,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Generated Password:'), findsOneWidget);
      expect(find.text('test-password'), findsOneWidget);
      expect(find.text('Strong'), findsOneWidget);
      expect(find.text('Estimator: Entropy (default)'), findsOneWidget);
    });

    testWidgets('renders feedback details when provided',
        (WidgetTester tester) async {
      final animationController = AnimationController(
        vsync: const TestVSync(),
        duration: const Duration(milliseconds: 100),
      );
      final animation =
          Tween<double>(begin: 0, end: 1).animate(animationController);
      animationController.forward();

      final state = MockGeneratorState()
        ..setMockState(
          password: 'weak-pass',
          strength: PasswordStrength.weak,
          feedback: const PasswordFeedback(
            strength: PasswordStrength.weak,
            warning: 'Weak password',
            suggestions: ['Add length', 'Add a number'],
          ),
          isVisible: true,
        );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: PasswordDisplay(
              state: state,
              fadeAnimation: animation,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Feedback'), findsOneWidget);
      expect(find.text('Weak password'), findsOneWidget);
      expect(find.text('Add length'), findsOneWidget);
      expect(find.text('Add a number'), findsOneWidget);
    });
  });
}
