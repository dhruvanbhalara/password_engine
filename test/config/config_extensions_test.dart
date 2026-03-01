import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('PasswordGeneratorConfigX', () {
    test('resolveCharacterSets includes only enabled types', () {
      final config =
          PasswordGeneratorConfig.builder()
              .useUpperCase(true)
              .useLowerCase(false)
              .useNumbers(true)
              .useSpecialChars(false)
              .build();

      final sets = config.resolveCharacterSets();
      expect(sets.containsKey(CharacterSetType.upper), isTrue);
      expect(sets.containsKey(CharacterSetType.number), isTrue);
      expect(sets.containsKey(CharacterSetType.lower), isFalse);
      expect(sets.containsKey(CharacterSetType.special), isFalse);
    });

    test('resolveCharacterSets caller flags override config values', () {
      final config =
          PasswordGeneratorConfig.builder()
              .useUpperCase(true)
              .useLowerCase(true)
              .useNumbers(true)
              .useSpecialChars(true)
              .build();

      final sets = config.resolveCharacterSets(useUpperCase: false);
      expect(sets.containsKey(CharacterSetType.upper), isFalse);
      expect(sets.containsKey(CharacterSetType.lower), isTrue);
    });

    test('combinedPool returns joined characters for enabled types', () {
      final config =
          PasswordGeneratorConfig.builder()
              .useUpperCase(true)
              .useLowerCase(false)
              .useNumbers(false)
              .useSpecialChars(false)
              .build();

      expect(
        config.combinedPool,
        equals(CharacterSetProfile.defaultProfile.upperCaseLetters),
      );
    });

    test('combinedPool is empty string when no types are enabled', () {
      final config =
          PasswordGeneratorConfig.builder()
              .useUpperCase(false)
              .useLowerCase(false)
              .useNumbers(false)
              .useSpecialChars(false)
              .build();

      expect(config.combinedPool, isEmpty);
    });

    test('combinedPool covers all character types when all are enabled', () {
      final config = PasswordGeneratorConfig.builder().build();
      final pool = config.combinedPool;
      expect(pool, contains('A'));
      expect(pool, contains('a'));
      expect(pool, contains('0'));
    });
  });
}
