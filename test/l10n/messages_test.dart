import 'package:password_engine/l10n/messages.i18n.dart';
import 'package:test/test.dart';

void main() {
  group('Messages', () {
    const messages = Messages();

    test('error maxAttemptsExceeded interpolates attempts', () {
      expect(
        messages.error.maxAttemptsExceeded(7),
        equals('Unable to generate a strong password within 7 attempts.'),
      );
    });

    test('error invalidFormat returns literal', () {
      expect(messages.error.invalidFormat, equals('invalid format'));
    });

    test('error invalidLength returns literal', () {
      expect(messages.error.invalidLength, equals('invalid length'));
    });

    test('feedback warning weak returns expected string', () {
      expect(messages.feedback.warning.weak, equals('Weak password'));
    });

    test('feedback suggestion increaseLengthMin interpolates value', () {
      expect(
        messages.feedback.suggestion.increaseLengthMin(18),
        equals('Increase length to at least 18'),
      );
    });

    test('all error getters return non-empty strings', () {
      expect(messages.error.maxGenerationAttemptsPositive, isNotEmpty);
      expect(messages.error.policyMinExceedsMax, isNotEmpty);
      expect(messages.error.atLeastOneCharType, isNotEmpty);
      expect(messages.error.selectedCharSetsNotEmpty, isNotEmpty);
      expect(messages.error.wordlistEmpty, isNotEmpty);
      expect(messages.error.wordlistHasEmptyWords, isNotEmpty);
      expect(messages.error.wordCountPositive, isNotEmpty);
      expect(messages.error.wordCountExceedsWordlist, isNotEmpty);
      expect(messages.error.characterPoolEmpty, isNotEmpty);
      expect(messages.error.lengthNonNegative, isNotEmpty);
    });

    test('all feedback warning getters return non-empty strings', () {
      expect(messages.feedback.warning.tooWeak, isNotEmpty);
      expect(messages.feedback.warning.medium, isNotEmpty);
      expect(messages.feedback.warning.policyNotMet, isNotEmpty);
      expect(messages.feedback.warning.policyPartiallyMet, isNotEmpty);
      expect(messages.feedback.warning.almostThere, isNotEmpty);
    });

    test('all feedback suggestion getters return non-empty strings', () {
      expect(messages.feedback.suggestion.useLonger, isNotEmpty);
      expect(messages.feedback.suggestion.addWordPhrase, isNotEmpty);
      expect(messages.feedback.suggestion.mixCharacterTypes, isNotEmpty);
      expect(messages.feedback.suggestion.addLengthOrWord, isNotEmpty);
      expect(messages.feedback.suggestion.avoidCommonPatterns, isNotEmpty);
      expect(messages.feedback.suggestion.increaseLengthSlightly, isNotEmpty);
      expect(messages.feedback.suggestion.addWordOrSymbol, isNotEmpty);
      expect(messages.feedback.suggestion.addUppercase, isNotEmpty);
      expect(messages.feedback.suggestion.addLowercase, isNotEmpty);
      expect(messages.feedback.suggestion.addNumber, isNotEmpty);
      expect(messages.feedback.suggestion.addSpecial, isNotEmpty);
      expect(messages.feedback.suggestion.useMoreVariety, isNotEmpty);
    });
  });
}
