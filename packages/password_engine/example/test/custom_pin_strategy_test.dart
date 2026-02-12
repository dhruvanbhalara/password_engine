import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import 'package:password_engine_example/strategies/custom_pin_strategy.dart';

void main() {
  group('CustomPinStrategy', () {
    late CustomPinStrategy strategy;

    setUp(() {
      strategy = CustomPinStrategy();
    });

    test('generates password with default prefix', () {
      const config = PasswordGeneratorConfig(length: 6, extra: {});
      final password = strategy.generate(config);

      expect(password, startsWith('USER-'));
      // Prefix 'USER-' (5 chars) + 6 digits = 11 chars
      expect(password.length, equals(11));
    });

    test('generates password with custom prefix', () {
      const config = PasswordGeneratorConfig(
        length: 4,
        extra: {'prefix': 'TEST'},
      );
      final password = strategy.generate(config);

      expect(password, startsWith('TEST-'));
      // Prefix 'TEST-' (5 chars) + 4 digits = 9 chars
      expect(password.length, equals(9));
    });

    test('throws error if length is less than 4', () {
      const config = PasswordGeneratorConfig(length: 3);
      expect(() => strategy.validate(config), throwsArgumentError);
    });

    test('generate throws if length is invalid', () {
      const config = PasswordGeneratorConfig(length: 3);
      expect(() => strategy.generate(config), throwsArgumentError);
    });
  });

  group('CustomPinStrategy Integration', () {
    test('PasswordGenerator propagates extra config', () {
      final generator = PasswordGenerator(
        generationStrategy: CustomPinStrategy(),
      );

      // Initial config with custom prefix
      generator.updateConfig(
        const PasswordGeneratorConfig(
          length: 6,
          extra: {'prefix': 'INT'},
        ),
      );

      final password = generator.generatePassword();
      expect(password, startsWith('INT-'));
    });
  });
}
