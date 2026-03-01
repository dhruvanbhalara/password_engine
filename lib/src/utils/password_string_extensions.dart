/// Extensions on [String] for password character analysis.
extension PasswordStringX on String {
  /// Whether this string contains any uppercase letters.
  bool get hasUpperCase => contains(RegExp(r'[A-Z]'));

  /// Whether this string contains any lowercase letters.
  bool get hasLowerCase => contains(RegExp(r'[a-z]'));

  /// Whether this string contains any numeric digits.
  bool get hasNumber => contains(RegExp(r'[0-9]'));

  /// Whether this string contains any special characters.
  bool get hasSpecialChar =>
      contains(RegExp(r'[!@#\$%^\&*()_+\-=\[\]{}|;:,.<>?]'));

  /// Whether this string contains any whitespace.
  bool get hasSpace => contains(' ');

  /// Whether this string contains any non-ASCII characters.
  bool get hasUnicode {
    for (final rune in runes) {
      if (rune > 127) return true;
    }
    return false;
  }

  /// Whether this string contains any character from [charSet].
  ///
  /// Uses a [Set] for O(1) lookup per character instead of O(m) string search.
  bool containsAnyOf(String charSet) {
    if (charSet.isEmpty) return false;
    final pool = charSet.split('').toSet();
    for (var i = 0; i < length; i++) {
      if (pool.contains(this[i])) return true;
    }
    return false;
  }
}
