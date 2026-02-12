/// Interface for normalizing passwords before validation or estimation.
abstract class IPasswordNormalizer {
  String normalize(String password);
}
