import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$DefaultPasswordNormalizer', () {
    late DefaultPasswordNormalizer normalizer;

    setUp(() {
      normalizer = DefaultPasswordNormalizer();
    });

    test('normalize returns input unchanged', () {
      expect(normalizer.normalize('Secret123!'), equals('Secret123!'));
    });

    test('normalize preserves empty string', () {
      expect(normalizer.normalize(''), equals(''));
    });

    test('normalize preserves leading and trailing whitespace', () {
      expect(normalizer.normalize('  pass  '), equals('  pass  '));
    });

    test('normalize preserves mixed-case and special chars', () {
      const input = 'AaBbCc123!@#';
      expect(normalizer.normalize(input), equals(input));
    });

    test('normalize preserves unicode characters', () {
      const input = 'pässwörD!1';
      expect(normalizer.normalize(input), equals(input));
    });
  });
}
