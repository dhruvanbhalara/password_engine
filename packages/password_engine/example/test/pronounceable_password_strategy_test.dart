import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/strategies/pronounceable_password_strategy.dart';

void main() {
  group('PronounceablePasswordStrategy', () {
    late PronounceablePasswordStrategy strategy;

    setUp(() {
      strategy = PronounceablePasswordStrategy();
    });

    test('generates password of correct length', () {
      final config = PasswordGeneratorConfig(length: 10);
      final password = strategy.generate(config);
      expect(password.length, equals(10));
    });

    test('generates password with alternating consonant and vowel', () {
      final config = PasswordGeneratorConfig(length: 6);
      final password = strategy.generate(config);
      // Simple check: shouldn't have 3 consecutive consonants or vowels
      expect(password, isNot(matches(RegExp(r'[aeiou]{3,}'))));
      expect(password, isNot(matches(RegExp(r'[^aeiou]{3,}'))));
    });
  });
}
