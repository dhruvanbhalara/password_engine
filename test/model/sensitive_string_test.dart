import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('SensitivePassword', () {
    test('value holds the original string (Happy Path)', () {
      const p = SensitivePassword('Secret123!');
      expect(p.value, equals('Secret123!'));
    });

    test('masked always returns asterisks regardless of value (Invariant)', () {
      expect(const SensitivePassword('abc').masked, equals('********'));
      expect(const SensitivePassword('').masked, equals('********'));
      expect(
        const SensitivePassword('aVeryLongPassword!123').masked,
        equals('********'),
      );
    });

    test('length matches underlying string length (Happy Path)', () {
      expect(const SensitivePassword('hello').length, equals(5));
      expect(const SensitivePassword('').length, equals(0));
    });

    test('isBlank returns true for empty string (Boundary Min)', () {
      expect(const SensitivePassword('').isBlank, isTrue);
    });

    test('isBlank returns true for whitespace-only string (Edge)', () {
      expect(const SensitivePassword('   ').isBlank, isTrue);
    });

    test('isBlank returns false for non-empty string (Happy Path)', () {
      expect(const SensitivePassword('a').isBlank, isFalse);
      expect(const SensitivePassword('Secret123!').isBlank, isFalse);
    });

    test('toString returns plaintext (Dart extension type limitation)', () {
      // Extension types cannot override Object.toString(), so toString()
      // returns the raw value. Consumers must use .masked for safe display.
      const p = SensitivePassword('Secret123!');
      expect(p.toString(), equals('Secret123!'));
      expect(p.masked, equals('********'));
    });
  });
}
