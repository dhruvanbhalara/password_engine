import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

import '../test_helpers.dart';

void main() {
  group('PasswordStrengthEstimator', () {
    test('empty password is very weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(estimator.estimatePasswordStrength(''), PasswordStrength.veryWeak);
    });

    final cases = <({String label, String value, PasswordStrength strength})>[
      (
        label: 'lowercase length 8 is very weak',
        value: 'aaaaaaaa',
        strength: PasswordStrength.veryWeak,
      ),
      (
        label: 'lowercase length 10 is weak',
        value: 'aaaaaaaaaa',
        strength: PasswordStrength.weak,
      ),
      (
        label: 'lowercase length 13 is medium',
        value: 'aaaaaaaaaaaaa',
        strength: PasswordStrength.medium,
      ),
      (
        label: 'lowercase length 16 is strong',
        value: 'aaaaaaaaaaaaaaaa',
        strength: PasswordStrength.strong,
      ),
      (
        label: 'lowercase length 28 is very strong',
        value: repeatChar('a', 28),
        strength: PasswordStrength.veryStrong,
      ),
    ];

    for (final entry in cases) {
      test(entry.label, () {
        final estimator = PasswordStrengthEstimator();
        expect(estimator.estimatePasswordStrength(entry.value), entry.strength);
      });
    }

    test('custom profile with mixed sets yields strong', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'AB',
        lowerCaseLetters: 'cd',
        numbers: '12',
        specialCharacters: '@#',
        upperCaseLettersNonAmbiguous: 'AB',
        lowerCaseLettersNonAmbiguous: 'cd',
        numbersNonAmbiguous: '12',
        specialCharactersNonAmbiguous: '@#',
      );

      final estimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );
      final password = 'Ac1@${repeatChar('A', 26)}';

      expect(
        estimator.estimatePasswordStrength(password),
        PasswordStrength.strong,
      );
    });

    test('custom special-only profile yields very strong at length 128', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: '',
        lowerCaseLetters: '',
        numbers: '',
        specialCharacters: '`~',
        upperCaseLettersNonAmbiguous: '',
        lowerCaseLettersNonAmbiguous: '',
        numbersNonAmbiguous: '',
        specialCharactersNonAmbiguous: '`~',
      );

      final estimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );
      final password = repeatChar('`', 128);

      expect(
        estimator.estimatePasswordStrength(password),
        PasswordStrength.veryStrong,
      );
    });

    test('numbers length 12 is very weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength(repeatChar('1', 12)),
        PasswordStrength.veryWeak,
      );
    });

    test('numbers length 13 is weak', () {
      final estimator = PasswordStrengthEstimator();
      expect(
        estimator.estimatePasswordStrength(repeatChar('1', 13)),
        PasswordStrength.weak,
      );
    });
  });
}
