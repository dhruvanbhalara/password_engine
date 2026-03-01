import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

class MockStrategy implements IPasswordGenerationStrategy {
  PasswordGeneratorConfig? lastConfig;

  @override
  String generate(PasswordGeneratorConfig config) {
    lastConfig = config;
    return 'password';
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    lastConfig = config;
  }
}

void main() {
  group('$PolicyAwarePasswordStrategy', () {
    test('generate returns unchanged config when no policy is set', () {
      final mock = MockStrategy();
      final strategy = PolicyAwarePasswordStrategy(baseStrategy: mock);

      final config = PasswordGeneratorConfig(length: 10);
      strategy.generate(config);

      expect(mock.lastConfig?.length, equals(10));
      expect(mock.lastConfig?.policy, isNull);
    });

    test('validate returns unchanged config when no policy is set', () {
      final mock = MockStrategy();
      final strategy = PolicyAwarePasswordStrategy(baseStrategy: mock);

      final config = PasswordGeneratorConfig(length: 10);
      strategy.validate(config);

      expect(mock.lastConfig?.length, equals(10));
      expect(mock.lastConfig?.policy, isNull);
    });

    test('throws when policy minLength > maxLength', () {
      expect(
        () => PasswordPolicy(minLength: 20, maxLength: 10),
        throwsA(isA<AssertionError>()),
      );
    });

    test('clamps length to minLength', () {
      final mock = MockStrategy();
      final strategy = PolicyAwarePasswordStrategy(baseStrategy: mock);

      final config = PasswordGeneratorConfig(
        length: 5,
        policy: PasswordPolicy(minLength: 16),
      );

      strategy.generate(config);
      expect(mock.lastConfig?.length, equals(16));
    });

    test('clamps length to maxLength', () {
      final mock = MockStrategy();
      final strategy = PolicyAwarePasswordStrategy(baseStrategy: mock);

      final config = PasswordGeneratorConfig(
        length: 50,
        policy: PasswordPolicy(maxLength: 30),
      );

      strategy.generate(config);
      expect(mock.lastConfig?.length, equals(30));
    });

    test('enforces required character boolean flags', () {
      final mock = MockStrategy();
      final strategy = PolicyAwarePasswordStrategy(baseStrategy: mock);

      final config = PasswordGeneratorConfig(
        useUpperCase: false,
        useLowerCase: false,
        useNumbers: false,
        useSpecialChars: false,
        policy: PasswordPolicy(
          requireUppercase: true,
          requireLowercase: true,
          requireNumber: true,
          requireSpecial: true,
        ),
      );

      strategy.generate(config);
      expect(mock.lastConfig?.useUpperCase, isTrue);
      expect(mock.lastConfig?.useLowerCase, isTrue);
      expect(mock.lastConfig?.useNumbers, isTrue);
      expect(mock.lastConfig?.useSpecialChars, isTrue);
    });
  });
}
