import 'dart:math';

import 'package:password_engine/src/utils/random_extensions.dart';
import 'package:test/test.dart';

void main() {
  group('RandomPasswordX', () {
    final random = Random(42);

    group('choice', () {
      test('selects character from pool', () {
        const pool = 'abc';
        final char = random.choice(pool);
        expect(pool.contains(char), isTrue);
      });

      test('choice from single char pool', () {
        expect(random.choice('a'), equals('a'));
      });

      test('choice from large pool', () {
        final pool = String.fromCharCodes(List.generate(255, (i) => i));
        final char = random.choice(pool);
        expect(pool.contains(char), isTrue);
      });

      test('choice throws on empty pool', () {
        expect(() => random.choice(''), throwsArgumentError);
      });

      test('choice result always within pool', () {
        const pool = '!@#';
        for (var i = 0; i < 100; i++) {
          expect(pool.contains(random.choice(pool)), isTrue);
        }
      });
    });

    group('nextString', () {
      test('generates string of correct length', () {
        const pool = '01';
        final result = random.nextString(pool, 10);
        expect(result.length, equals(10));
        for (var i = 0; i < result.length; i++) {
          expect(pool.contains(result[i]), isTrue);
        }
      });

      test('returns empty string for length 0', () {
        expect(random.nextString('abc', 0), equals(''));
      });

      test('generates very long string', () {
        const len = 10000;
        final result = random.nextString('a', len);
        expect(result.length, equals(len));
      });

      test('throws on negative length', () {
        expect(() => random.nextString('abc', -1), throwsArgumentError);
      });

      test('throws on empty pool for positive length', () {
        expect(() => random.nextString('', 5), throwsArgumentError);
      });

      test('nextString contains only chars from pool', () {
        const pool = 'XYZ';
        final result = random.nextString(pool, 100);
        expect(RegExp('^[XYZ]+\$').hasMatch(result), isTrue);
      });
    });
  });
}
