import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordPolicy', () {
    test('copyWith copies provided values and keeps existing ones', () {
      final base = PasswordPolicy(
        minLength: 16,
        maxLength: 20,
        requireUppercase: true,
        requireLowercase: false,
        requireNumber: true,
        requireSpecial: false,
        allowSpaces: true,
        allowUnicode: false,
        strengthThreshold: PasswordStrength.weak,
        scoreThreshold: 2,
      );

      final copy1 = base.copyWith(
        minLength: 15,
        requireLowercase: true,
        allowUnicode: true,
      );

      expect(copy1.minLength, equals(15));
      expect(copy1.maxLength, equals(20));
      expect(copy1.requireUppercase, isTrue);
      expect(copy1.requireLowercase, isTrue);
      expect(copy1.requireNumber, isTrue);
      expect(copy1.requireSpecial, isFalse);
      expect(copy1.allowSpaces, isTrue);
      expect(copy1.allowUnicode, isTrue);
      expect(copy1.strengthThreshold, equals(PasswordStrength.weak));
      expect(copy1.scoreThreshold, equals(2));
    });

    test('copyWith without arguments creates identical copy', () {
      final base = PasswordPolicy();
      final copy = base.copyWith();

      expect(copy.minLength, equals(base.minLength));
      expect(copy.maxLength, equals(base.maxLength));
      expect(copy.requireUppercase, equals(base.requireUppercase));
      expect(copy.requireLowercase, equals(base.requireLowercase));
      expect(copy.requireNumber, equals(base.requireNumber));
      expect(copy.requireSpecial, equals(base.requireSpecial));
      expect(copy.allowSpaces, equals(base.allowSpaces));
      expect(copy.allowUnicode, equals(base.allowUnicode));
      expect(copy.strengthThreshold, equals(base.strengthThreshold));
      expect(copy.scoreThreshold, equals(base.scoreThreshold));
    });

    test('toBuilder and build creates identical copy', () {
      final base = PasswordPolicy(maxLength: 20, minLength: 16);
      final copy = base.toBuilder().build();
      expect(copy.minLength, equals(16));
      expect(copy.maxLength, equals(20));
    });

    test('builder creates policy with provided values', () {
      final builder = PasswordPolicy.builder()
          .minLength(18)
          .maxLength(32)
          .requireUppercase(true)
          .requireLowercase(true)
          .requireNumber(true)
          .requireSpecial(true)
          .allowSpaces(true)
          .allowUnicode(true)
          .strengthThreshold(PasswordStrength.strong)
          .scoreThreshold(4);

      final policy = builder.build();

      expect(policy.minLength, equals(18));
      expect(policy.maxLength, equals(32));
      expect(policy.requireUppercase, isTrue);
      expect(policy.requireLowercase, isTrue);
      expect(policy.requireNumber, isTrue);
      expect(policy.requireSpecial, isTrue);
      expect(policy.allowSpaces, isTrue);
      expect(policy.allowUnicode, isTrue);
      expect(policy.strengthThreshold, equals(PasswordStrength.strong));
      expect(policy.scoreThreshold, equals(4));
    });

    test('Builder handles nulling out values (maxLength)', () {
      final base = PasswordPolicy(maxLength: 20);
      final builder = base.toBuilder();
      builder.maxLength(null);
      final result = builder.build();
      expect(result.maxLength, isNull);
    });

    test('serialization: toMap and fromMap preserve values', () {
      const policy = PasswordPolicy(
        minLength: 16,
        maxLength: 32,
        requireUppercase: true,
        requireLowercase: true,
        requireNumber: true,
        requireSpecial: true,
        allowSpaces: true,
        allowUnicode: true,
        strengthThreshold: PasswordStrength.strong,
        scoreThreshold: 4,
      );

      final map = policy.toMap();
      final fromMap = PasswordPolicy.fromMap(map);

      expect(fromMap.minLength, equals(policy.minLength));
      expect(fromMap.maxLength, equals(policy.maxLength));
      expect(fromMap.requireUppercase, equals(policy.requireUppercase));
      expect(fromMap.requireLowercase, equals(policy.requireLowercase));
      expect(fromMap.requireNumber, equals(policy.requireNumber));
      expect(fromMap.requireSpecial, equals(policy.requireSpecial));
      expect(fromMap.allowSpaces, equals(policy.allowSpaces));
      expect(fromMap.allowUnicode, equals(policy.allowUnicode));
      expect(fromMap.strengthThreshold, equals(policy.strengthThreshold));
      expect(fromMap.scoreThreshold, equals(policy.scoreThreshold));
    });

    test('serialization: fromMap handles null values', () {
      final fromMap = PasswordPolicy.fromMap({});
      expect(fromMap.minLength, equals(16));
      expect(fromMap.maxLength, isNull);
      expect(fromMap.requireUppercase, isFalse);
      expect(fromMap.strengthThreshold, isNull);
    });

    test(
      'serialization: fromMap handles invalid strength index gracefully',
      () {
        final fromMap = PasswordPolicy.fromMap({'strengthThreshold': 99});
        expect(fromMap.strengthThreshold, isNull);
      },
    );

    test('serialization: fromMap handles types correctly', () {
      final fromMap = PasswordPolicy.fromMap({
        'minLength': 8,
        'requireNumber': true,
      });
      expect(fromMap.minLength, equals(8));
      expect(fromMap.requireNumber, isTrue);
    });

    group('PasswordPolicyX', () {
      test('clampLength clamps value within bounds', () {
        const policy = PasswordPolicy(minLength: 16, maxLength: 20);
        expect(policy.clampLength(5), equals(16));
        expect(policy.clampLength(17), equals(17));
        expect(policy.clampLength(25), equals(20));
      });

      test('clampLength handles null maxLength', () {
        const policy = PasswordPolicy(minLength: 16, maxLength: null);
        expect(policy.clampLength(5), equals(16));
        expect(policy.clampLength(100), equals(100));
      });

      test('clampLength handles negative input', () {
        const policy = PasswordPolicy(minLength: 16);
        expect(policy.clampLength(-5), equals(16));
      });

      test('clampLength handles large input', () {
        const policy = PasswordPolicy(minLength: 16, maxLength: 1000);
        expect(policy.clampLength(10000), equals(1000));
      });
    });
  });
}
