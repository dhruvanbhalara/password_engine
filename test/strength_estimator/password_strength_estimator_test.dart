import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordStrengthEstimator', () {
    late PasswordStrengthEstimator estimator;

    setUp(() {
      estimator = PasswordStrengthEstimator();
    });

    test('empty password is very weak', () {
      expect(
        estimator.estimatePasswordStrength(''),
        equals(PasswordStrength.veryWeak),
      );
    });

    test(
      'password with characters not in any pool uses fallback pool size',
      () {
        expect(
          estimator.estimatePasswordStrength('\u{1F60A}'),
          equals(PasswordStrength.veryWeak),
        );
        expect(
          estimator.estimatePasswordStrength(
            '\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}\u{1F60A}',
          ),
          equals(PasswordStrength.veryStrong),
        );
      },
    );

    test('estimates very weak strength (entropy < 40)', () {
      expect(
        estimator.estimatePasswordStrength('aaaaa'),
        equals(PasswordStrength.veryWeak),
      );
    });

    test('estimates weak strength (40 <= entropy < 60)', () {
      expect(
        estimator.estimatePasswordStrength('aaaaaaaaa'),
        equals(PasswordStrength.weak),
      );
    });

    test('estimates medium strength (60 <= entropy < 75)', () {
      expect(
        estimator.estimatePasswordStrength('a1a1a1a1a1a1'),
        equals(PasswordStrength.medium),
      );
    });

    test('estimates strong strength (75 <= entropy < 128)', () {
      expect(
        estimator.estimatePasswordStrength('Aa1Aa1Aa1Aa1Aa'),
        equals(PasswordStrength.strong),
      );
    });

    test('estimates very strong strength (entropy >= 128)', () {
      expect(
        estimator.estimatePasswordStrength('A!b2C#d4E%f6G&h8I*j0'),
        equals(PasswordStrength.veryStrong),
      );
    });

    test('uses custom CharacterSetProfile', () {
      const customProfile = CharacterSetProfile(
        upperCaseLetters: 'A',
        lowerCaseLetters: 'b',
        numbers: '1',
        specialCharacters: '*',
        upperCaseLettersNonAmbiguous: 'A',
        lowerCaseLettersNonAmbiguous: 'b',
        numbersNonAmbiguous: '1',
        specialCharactersNonAmbiguous: '*',
      );
      final customEstimator = PasswordStrengthEstimator(
        characterSetProfile: customProfile,
      );

      expect(
        customEstimator.estimatePasswordStrength('Ab1*'),
        equals(PasswordStrength.veryWeak),
      );

      final weakResult = customEstimator.estimatePasswordStrength('Ab1*' * 5);
      expect(weakResult, equals(PasswordStrength.weak));
    });

    group('estimateEntropy', () {
      test('calculates entropy correctly for simple password', () {
        final entropy = estimator.estimateEntropy('abc1');
        expect(entropy, closeTo(4 * 5.17, 0.01));
      });

      test('includes spaces when allowSpaces is true', () {
        final withSpaces = 'abc ';

        final entropyWithout = estimator.estimateEntropy(
          withSpaces,
          allowSpaces: false,
        );

        final entropyWith = estimator.estimateEntropy(
          withSpaces,
          allowSpaces: true,
        );

        expect(entropyWith, greaterThan(entropyWithout));
      });

      test('result is consistent with PasswordStrength.fromEntropy', () {
        final entropy = 70.0;
        final strength = PasswordStrength.fromEntropy(entropy);
        expect(strength, equals(PasswordStrength.medium));
      });

      test('single character password has non-zero entropy', () {
        final entropy = estimator.estimateEntropy('a');
        expect(entropy, greaterThan(0));
        expect(entropy, lessThan(10));
        expect(
          estimator.estimatePasswordStrength('a'),
          equals(PasswordStrength.veryWeak),
        );
      });
    });
  });
}
