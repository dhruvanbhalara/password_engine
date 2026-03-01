import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordGeneratorConfig', () {
    test('fromMap restores all fields serialized by toMap', () {
      final config =
          PasswordGeneratorConfig.builder()
              .length(20)
              .useUpperCase(false)
              .useNumbers(true)
              .excludeAmbiguousChars(true)
              .policy(PasswordPolicy(minLength: 15))
              .extra('custom', 'value')
              .build();

      final map = config.toMap();
      final fromMap = PasswordGeneratorConfig.fromMap(map);

      expect(fromMap.length, equals(config.length));
      expect(fromMap.useUpperCase, equals(config.useUpperCase));
      expect(fromMap.useNumbers, equals(config.useNumbers));
      expect(
        fromMap.excludeAmbiguousChars,
        equals(config.excludeAmbiguousChars),
      );
      expect(fromMap.policy?.minLength, equals(config.policy?.minLength));
      expect(fromMap.extra, equals(config.extra));
    });

    test('fromMap returns defaults when map is empty', () {
      final fromMap = PasswordGeneratorConfig.fromMap({});
      expect(fromMap.length, equals(16));
      expect(fromMap.useUpperCase, isTrue);
      expect(
        fromMap.characterSetProfile,
        equals(CharacterSetProfile.defaultProfile),
      );
    });

    test('toMap includes policy and extra data', () {
      final config = PasswordGeneratorConfig(
        length: 20,
        policy: PasswordPolicy(minLength: 18),
        extra: const {'source': 'unit'},
      );

      final map = config.toMap();
      expect(map['policy'], isA<Map<String, dynamic>>());
      expect((map['policy'] as Map<String, dynamic>)['minLength'], equals(18));
      expect(map['extra'], equals({'source': 'unit'}));
    });

    test('fromMap restores policy when provided', () {
      final map = {
        'length': 24,
        'policy': {'minLength': 22},
      };

      final config = PasswordGeneratorConfig.fromMap(map);
      expect(config.length, equals(24));
      expect(config.policy?.minLength, equals(22));
    });

    test('toMap preserves characterSetProfile serialization', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'X',
        lowerCaseLetters: 'y',
        numbers: '7',
        specialCharacters: '!',
        upperCaseLettersNonAmbiguous: 'X',
        lowerCaseLettersNonAmbiguous: 'y',
        numbersNonAmbiguous: '7',
        specialCharactersNonAmbiguous: '!',
      );
      final config = PasswordGeneratorConfig(
        characterSetProfile: customProfile,
      );

      final map = config.toMap();
      expect(map['characterSetProfile'], isA<Map<String, dynamic>>());
      expect(
        (map['characterSetProfile']
            as Map<String, dynamic>)['upperCaseLetters'],
        equals('X'),
      );
    });
  });
}
