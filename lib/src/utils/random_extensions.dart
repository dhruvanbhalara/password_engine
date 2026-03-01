import 'dart:math';

import '../../l10n/messages.i18n.dart';

/// Extensions on [Random] for password generation tasks.
extension RandomPasswordX on Random {
  /// Returns a single character chosen randomly from the given [pool].
  String choice(String pool) {
    final messages = const Messages();
    if (pool.isEmpty) {
      throw ArgumentError(messages.error.characterPoolEmpty);
    }
    return pool[nextInt(pool.length)];
  }

  /// Returns a string of [length] characters chosen randomly from [pool].
  String nextString(String pool, int length) {
    final messages = const Messages();
    if (length < 0) {
      throw ArgumentError(messages.error.lengthNonNegative);
    }
    if (length == 0) return '';
    if (pool.isEmpty) {
      throw ArgumentError(messages.error.characterPoolEmpty);
    }

    final buffer = StringBuffer();
    for (var i = 0; i < length; i++) {
      buffer.write(choice(pool));
    }
    return buffer.toString();
  }
}
