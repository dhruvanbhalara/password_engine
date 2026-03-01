import 'package:password_engine/l10n/messages.i18n.dart';
import 'package:password_engine/password_engine.dart';
import 'package:test/test.dart';

void main() {
  group('$PasswordGenerationException', () {
    test('maxAttemptsExceeded factory sets properties properly', () {
      final exception = PasswordGenerationException.maxAttemptsExceeded(
        maxAttempts: 5,
      );

      expect(
        exception.code,
        equals(PasswordGenerationErrorCode.maxAttemptsExceeded),
      );
      expect(exception, isA<MaxAttemptsExceededException>());
      final maxException = exception as MaxAttemptsExceededException;
      expect(maxException.maxAttempts, equals(5));
      expect(exception.message, contains('5 attempts'));
    });

    test('toString returns message', () {
      final exception = PasswordGenerationException.maxAttemptsExceeded(
        maxAttempts: 3,
      );
      expect(exception.toString(), equals(exception.message));
    });

    test('factory uses localized message', () {
      final exception = PasswordGenerationException.maxAttemptsExceeded(
        maxAttempts: 10,
      );

      expect(
        exception.message,
        equals(const Messages().error.maxAttemptsExceeded(10)),
      );
    });

    test('exception preserves maxAttempts value', () {
      final exception =
          PasswordGenerationException.maxAttemptsExceeded(maxAttempts: 42)
              as MaxAttemptsExceededException;

      expect(exception.maxAttempts, equals(42));
    });

    test('code remains maxAttemptsExceeded', () {
      final exception = PasswordGenerationException.maxAttemptsExceeded(
        maxAttempts: 1,
      );

      expect(
        exception.code,
        equals(PasswordGenerationErrorCode.maxAttemptsExceeded),
      );
    });
  });
}
