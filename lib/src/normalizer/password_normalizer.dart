import 'ipassword_normalizer.dart';

/// Default normalizer that returns the input unchanged.
class DefaultPasswordNormalizer implements IPasswordNormalizer {
  @override
  String normalize(String password) => password;
}
