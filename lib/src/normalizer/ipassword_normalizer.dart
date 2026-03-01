/// Interface for normalizing passwords before validation or estimation.
abstract interface class IPasswordNormalizer {
  /// Returns the normalized form of [password].
  String normalize(String password);
}
