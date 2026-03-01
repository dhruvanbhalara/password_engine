import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$CharacterSetProfile', () {
    test('copyWith copies provided values and keeps existing ones', () {
      final base = const CharacterSetProfile(
        upperCaseLetters: 'A',
        lowerCaseLetters: 'b',
        numbers: '1',
        specialCharacters: '!',
        upperCaseLettersNonAmbiguous: 'C',
        lowerCaseLettersNonAmbiguous: 'd',
        numbersNonAmbiguous: '2',
        specialCharactersNonAmbiguous: '@',
      );

      final copy1 = base.copyWith(
        upperCaseLetters: 'Z',
        numbersNonAmbiguous: '9',
      );

      expect(copy1.upperCaseLetters, equals('Z'));
      expect(copy1.lowerCaseLetters, equals('b'));
      expect(copy1.numbers, equals('1'));
      expect(copy1.specialCharacters, equals('!'));
      expect(copy1.upperCaseLettersNonAmbiguous, equals('C'));
      expect(copy1.lowerCaseLettersNonAmbiguous, equals('d'));
      expect(copy1.numbersNonAmbiguous, equals('9'));
      expect(copy1.specialCharactersNonAmbiguous, equals('@'));
    });

    test('copyWith without arguments creates identical copy', () {
      final base = CharacterSetProfile.defaultProfile;
      final copy = base.copyWith();

      expect(copy.upperCaseLetters, equals(base.upperCaseLetters));
      expect(copy.lowerCaseLetters, equals(base.lowerCaseLetters));
      expect(copy.numbers, equals(base.numbers));
      expect(copy.specialCharacters, equals(base.specialCharacters));
      expect(
        copy.upperCaseLettersNonAmbiguous,
        equals(base.upperCaseLettersNonAmbiguous),
      );
      expect(
        copy.lowerCaseLettersNonAmbiguous,
        equals(base.lowerCaseLettersNonAmbiguous),
      );
      expect(copy.numbersNonAmbiguous, equals(base.numbersNonAmbiguous));
      expect(
        copy.specialCharactersNonAmbiguous,
        equals(base.specialCharactersNonAmbiguous),
      );
    });

    test('fromMap restores all fields serialized by toMap', () {
      final profile = CharacterSetProfile.defaultProfile;
      final map = profile.toMap();
      final fromMap = CharacterSetProfile.fromMap(map);

      expect(fromMap.upperCaseLetters, equals(profile.upperCaseLetters));
      expect(fromMap.lowerCaseLetters, equals(profile.lowerCaseLetters));
      expect(fromMap.numbers, equals(profile.numbers));
      expect(fromMap.specialCharacters, equals(profile.specialCharacters));
      expect(
        fromMap.upperCaseLettersNonAmbiguous,
        equals(profile.upperCaseLettersNonAmbiguous),
      );
      expect(
        fromMap.lowerCaseLettersNonAmbiguous,
        equals(profile.lowerCaseLettersNonAmbiguous),
      );
      expect(fromMap.numbersNonAmbiguous, equals(profile.numbersNonAmbiguous));
      expect(
        fromMap.specialCharactersNonAmbiguous,
        equals(profile.specialCharactersNonAmbiguous),
      );
    });

    test('toMap includes expected keys', () {
      final profile = CharacterSetProfile.defaultProfile;
      final map = profile.toMap();

      expect(map.containsKey('upperCaseLetters'), isTrue);
      expect(map.containsKey('lowerCaseLetters'), isTrue);
      expect(map.containsKey('numbers'), isTrue);
      expect(map.containsKey('specialCharacters'), isTrue);
      expect(map.containsKey('upperCaseLettersNonAmbiguous'), isTrue);
      expect(map.containsKey('lowerCaseLettersNonAmbiguous'), isTrue);
      expect(map.containsKey('numbersNonAmbiguous'), isTrue);
      expect(map.containsKey('specialCharactersNonAmbiguous'), isTrue);
    });

    test('defaultProfile provides non-empty character pools', () {
      final profile = CharacterSetProfile.defaultProfile;
      expect(profile.upperCaseLetters, isNotEmpty);
      expect(profile.lowerCaseLetters, isNotEmpty);
      expect(profile.numbers, isNotEmpty);
      expect(profile.specialCharacters, isNotEmpty);
    });
  });
}
