import 'package:flutter_test/flutter_test.dart';
import 'package:password_engine/password_engine.dart';

void main() {
  group('CharacterSetProfile', () {
    test('defaultWithSpaces includes a space character', () {
      expect(
        CharacterSetProfile.defaultWithSpaces.specialCharacters,
        contains(' '),
      );
    });
  });
}
