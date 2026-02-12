import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('PolicyAwarePasswordStrategy', () {
    test('applies policy-required character types', () {
      final strategy = PolicyAwarePasswordStrategy(
        baseStrategy: RandomPasswordStrategy(),
      );
      const config = PasswordGeneratorConfig(
        length: 16,
        useUpperCase: false,
        useLowerCase: true,
        useNumbers: false,
        useSpecialChars: false,
        policy: PasswordPolicy(requireNumber: true, requireSpecial: true),
      );

      final password = strategy.generate(config);
      expect(password, contains(RegExp(r'[0-9]')));
      expect(password, contains(RegExp(r'[^A-Za-z0-9]')));
    });

    test('bumps length to policy minLength', () {
      final strategy = PolicyAwarePasswordStrategy(
        baseStrategy: RandomPasswordStrategy(),
      );
      const config = PasswordGeneratorConfig(
        length: 12,
        policy: PasswordPolicy(minLength: 16),
      );

      final password = strategy.generate(config);
      expect(password.length, equals(16));
    });

    test('clamps length to policy maxLength', () {
      final strategy = PolicyAwarePasswordStrategy(
        baseStrategy: RandomPasswordStrategy(),
      );
      const config = PasswordGeneratorConfig(
        length: 20,
        policy: PasswordPolicy(maxLength: 16),
      );

      final password = strategy.generate(config);
      expect(password.length, equals(16));
    });

    test('throws when policy minLength exceeds maxLength', () {
      final strategy = PolicyAwarePasswordStrategy(
        baseStrategy: RandomPasswordStrategy(),
      );
      const config = PasswordGeneratorConfig(
        length: 12,
        policy: PasswordPolicy(minLength: 20, maxLength: 10),
      );

      expect(() => strategy.generate(config), throwsArgumentError);
    });
  });
}
