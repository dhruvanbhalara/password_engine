/// A wrapper for sensitive string data like passwords.
///
/// Use [masked] for logging or UI display to avoid exposing the raw value.
extension type const SensitivePassword(String value) {
  /// Returns a fixed masked string (`********`).
  String get masked => '********';

  /// Whether this password is empty or contains only whitespace.
  bool get isBlank => value.trim().isEmpty;

  /// The length of the underlying string.
  int get length => value.length;
}
