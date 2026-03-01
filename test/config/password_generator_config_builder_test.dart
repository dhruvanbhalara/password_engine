import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordGeneratorConfigBuilder', () {
    test('build uses length 16 and all types enabled by default', () {
      final config = PasswordGeneratorConfig.builder().build();
      expect(config.length, equals(16));
      expect(config.useUpperCase, isTrue);
      expect(config.useNumbers, isTrue);
    });

    test('build reflects all explicitly set values', () {
      final config =
          PasswordGeneratorConfig.builder()
              .length(24)
              .useUpperCase(false)
              .useNumbers(false)
              .excludeAmbiguousChars(true)
              .extra('test', 'value')
              .build();

      expect(config.length, equals(24));
      expect(config.useUpperCase, isFalse);
      expect(config.useNumbers, isFalse);
      expect(config.excludeAmbiguousChars, isTrue);
      expect(config.extra['test'], equals('value'));
    });

    test('extraAll merges multiple keys into extra map', () {
      final config =
          PasswordGeneratorConfig.builder().extra('k1', 'v1').extraAll({
            'k2': 'v2',
            'k3': 'v3',
          }).build();

      expect(config.extra['k1'], equals('v1'));
      expect(config.extra['k2'], equals('v2'));
      expect(config.extra['k3'], equals('v3'));
    });

    test('policy and characterSetProfile are forwarded to config', () {
      const profile = CharacterSetProfile(
        upperCaseLetters: 'A',
        lowerCaseLetters: 'a',
        numbers: '1',
        specialCharacters: '!',
        upperCaseLettersNonAmbiguous: 'A',
        lowerCaseLettersNonAmbiguous: 'a',
        numbersNonAmbiguous: '1',
        specialCharactersNonAmbiguous: '!',
      );
      const policy = PasswordPolicy(minLength: 8);

      final config =
          PasswordGeneratorConfig.builder()
              .characterSetProfile(profile)
              .policy(policy)
              .build();

      expect(config.characterSetProfile, equals(profile));
      expect(config.policy, equals(policy));
    });

    group('maxGenerationAttempts', () {
      test('sets valid maxGenerationAttempts', () {
        final config =
            PasswordGeneratorConfig.builder()
                .maxGenerationAttempts(500)
                .build();
        expect(config.maxGenerationAttempts, equals(500));
      });

      test('accepts 1 as minimum valid value', () {
        final config =
            PasswordGeneratorConfig.builder().maxGenerationAttempts(1).build();
        expect(config.maxGenerationAttempts, equals(1));
      });

      test('accepts large values without overflow', () {
        final config =
            PasswordGeneratorConfig.builder()
                .maxGenerationAttempts(1000000)
                .build();
        expect(config.maxGenerationAttempts, equals(1000000));
      });

      test('accepts zero as maxGenerationAttempts', () {
        final config =
            PasswordGeneratorConfig.builder().maxGenerationAttempts(0).build();
        expect(config.maxGenerationAttempts, equals(0));
      });

      test('uses defaultMaxGenerationAttempts when not explicitly set', () {
        final config = PasswordGeneratorConfig.builder().build();
        expect(
          config.maxGenerationAttempts,
          equals(PasswordGeneratorConfig.defaultMaxGenerationAttempts),
        );
      });
    });
  });
}
