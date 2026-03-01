import 'package:password_engine/l10n/messages.i18n.dart';
import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordFeedback', () {
    const messages = Messages();

    test('stores values', () {
      final feedback = PasswordFeedback(
        strength: PasswordStrength.weak,
        warning: messages.feedback.warning.weak,
        suggestions: [messages.feedback.suggestion.addWordPhrase],
        estimatedEntropy: 12.5,
        score: 1,
      );

      expect(feedback.strength, PasswordStrength.weak);
      expect(feedback.warning, messages.feedback.warning.weak);
      expect(feedback.suggestions, [
        messages.feedback.suggestion.addWordPhrase,
      ]);
      expect(feedback.estimatedEntropy, 12.5);
      expect(feedback.score, 1);
    });

    test('serialization: toMap and fromMap preserve values', () {
      final feedback = PasswordFeedback(
        strength: PasswordStrength.strong,
        warning: messages.feedback.warning.medium,
        suggestions: [messages.feedback.suggestion.addWordOrSymbol],
        estimatedEntropy: 80.0,
        score: 4,
      );

      final map = feedback.toMap();
      final fromMap = PasswordFeedback.fromMap(map);

      expect(fromMap.strength, equals(feedback.strength));
      expect(fromMap.warning, equals(feedback.warning));
      expect(fromMap.suggestions, equals(feedback.suggestions));
      expect(fromMap.estimatedEntropy, equals(feedback.estimatedEntropy));
      expect(fromMap.score, equals(feedback.score));
    });

    test('fromMap handles missing optional fields', () {
      final fromMap = PasswordFeedback.fromMap({
        'strength': PasswordStrength.weak.index,
      });

      expect(fromMap.warning, isNull);
      expect(fromMap.suggestions, isEmpty);
      expect(fromMap.estimatedEntropy, isNull);
      expect(fromMap.score, isNull);
    });

    test('toMap includes null values for optional fields', () {
      const feedback = PasswordFeedback(strength: PasswordStrength.medium);

      final map = feedback.toMap();
      expect(map['warning'], isNull);
      expect(map['suggestions'], isA<List<String>>());
      expect(map['estimatedEntropy'], isNull);
      expect(map['score'], isNull);
    });

    test('suggestions list preserves order', () {
      final feedback = PasswordFeedback(
        strength: PasswordStrength.weak,
        suggestions: [
          messages.feedback.suggestion.addUppercase,
          messages.feedback.suggestion.addNumber,
        ],
      );

      expect(
        feedback.suggestions,
        equals([
          messages.feedback.suggestion.addUppercase,
          messages.feedback.suggestion.addNumber,
        ]),
      );
    });
  });
}
