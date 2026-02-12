import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_example/strategies/memorable_password_strategy.dart';

void main() {
  group('MemorablePasswordStrategy', () {
    late MemorablePasswordStrategy strategy;

    setUp(() {
      strategy = MemorablePasswordStrategy();
    });

    test('generates password with correct word count', () {
      final config =
          PasswordGeneratorConfig(length: 4); // Interpreted as 4 words
      final password = strategy.generate(config);
      final words = password.split('-');
      expect(words.length, equals(4));
    });

    test('generates password with default separator', () {
      final config = PasswordGeneratorConfig(length: 4);
      final password = strategy.generate(config);
      expect(password, contains('-'));
    });

    test('generates password with custom separator', () {
      strategy = MemorablePasswordStrategy(separator: '_');
      final config = PasswordGeneratorConfig(length: 4);
      final password = strategy.generate(config);
      expect(password, contains('_'));
      expect(password, isNot(contains('-')));
    });

    test('capitalizes words when requested', () {
      strategy = MemorablePasswordStrategy(capitalize: true);
      final config = PasswordGeneratorConfig(length: 4);
      final password = strategy.generate(config);
      final words = password.split('-');
      for (final word in words) {
        expect(word[0], matches(RegExp(r'[A-Z]')));
      }
    });
  });
}
