import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('PasswordPolicy', () {
    test('copyWith updates fields', () {
      const policy = PasswordPolicy(minLength: 10, requireNumber: true);
      final updated = policy.copyWith(minLength: 16, allowSpaces: true);

      expect(updated.minLength, equals(16));
      expect(updated.requireNumber, isTrue);
      expect(updated.allowSpaces, isTrue);
    });
  });
}
