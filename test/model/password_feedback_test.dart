import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('PasswordFeedback', () {
    test('stores values', () {
      const feedback = PasswordFeedback(
        strength: PasswordStrength.weak,
        warning: 'Too common',
        suggestions: ['Add another word'],
        estimatedEntropy: 12.5,
        score: 1,
      );

      expect(feedback.strength, PasswordStrength.weak);
      expect(feedback.warning, 'Too common');
      expect(feedback.suggestions, ['Add another word']);
      expect(feedback.estimatedEntropy, 12.5);
      expect(feedback.score, 1);
    });
  });
}
