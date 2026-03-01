import 'ipassword_normalizer.dart';

/// Default passthrough normalizer that returns the input unchanged.
///
/// This is an identity implementation intended as a no-op default. For
/// real-world security (e.g., NFC normalization, trimming whitespace, or
/// stripping Unicode confusables), inject a custom [IPasswordNormalizer].
final class DefaultPasswordNormalizer implements IPasswordNormalizer {
  @override
  String normalize(String password) => password;
}
