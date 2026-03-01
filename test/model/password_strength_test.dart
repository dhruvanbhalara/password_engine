import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordStrength', () {
    test('has exactly five cases in correct order', () {
      expect(PasswordStrength.values, hasLength(5));
      expect(PasswordStrength.values, [
        PasswordStrength.veryWeak,
        PasswordStrength.weak,
        PasswordStrength.medium,
        PasswordStrength.strong,
        PasswordStrength.veryStrong,
      ]);
    });

    group('fromEntropy', () {
      test('entropy below 40 maps to veryWeak', () {
        expect(PasswordStrength.fromEntropy(0), PasswordStrength.veryWeak);
        expect(PasswordStrength.fromEntropy(39.9), PasswordStrength.veryWeak);
      });

      test('entropy 40–59.9 maps to weak', () {
        expect(PasswordStrength.fromEntropy(40), PasswordStrength.weak);
        expect(PasswordStrength.fromEntropy(59.9), PasswordStrength.weak);
      });

      test('entropy 60–74.9 maps to medium', () {
        expect(PasswordStrength.fromEntropy(60), PasswordStrength.medium);
        expect(PasswordStrength.fromEntropy(74.9), PasswordStrength.medium);
      });

      test('entropy 75–127.9 maps to strong', () {
        expect(PasswordStrength.fromEntropy(75), PasswordStrength.strong);
        expect(PasswordStrength.fromEntropy(127.9), PasswordStrength.strong);
      });

      test('entropy 128 and above maps to veryStrong', () {
        expect(PasswordStrength.fromEntropy(128), PasswordStrength.veryStrong);
        expect(PasswordStrength.fromEntropy(256), PasswordStrength.veryStrong);
      });
    });

    group('isAtLeast', () {
      test('returns true when strength equals other', () {
        expect(
          PasswordStrength.strong.isAtLeast(PasswordStrength.strong),
          isTrue,
        );
      });

      test('returns true when strength is higher than other', () {
        expect(
          PasswordStrength.veryStrong.isAtLeast(PasswordStrength.weak),
          isTrue,
        );
      });

      test('returns false when strength is lower than other', () {
        expect(
          PasswordStrength.weak.isAtLeast(PasswordStrength.strong),
          isFalse,
        );
      });

      test('veryWeak is only at least itself', () {
        expect(
          PasswordStrength.veryWeak.isAtLeast(PasswordStrength.veryWeak),
          isTrue,
        );
        expect(
          PasswordStrength.veryWeak.isAtLeast(PasswordStrength.weak),
          isFalse,
        );
      });
    });

    group('EntropyThresholds', () {
      test('threshold constants match documented entropy values', () {
        expect(EntropyThresholds.weak, equals(40.0));
        expect(EntropyThresholds.medium, equals(60.0));
        expect(EntropyThresholds.strong, equals(75.0));
        expect(EntropyThresholds.veryStrong, equals(128.0));
      });
    });
  });
}
