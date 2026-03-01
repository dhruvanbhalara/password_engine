import '../config/password_generator_config.dart';
import '../utils/character_set_resolver.dart';

/// Extensions on [PasswordGeneratorConfig] for easier configuration handling.
extension PasswordGeneratorConfigX on PasswordGeneratorConfig {
  /// Resolves the enabled character sets for this configuration.
  Map<CharacterSetType, String> resolveCharacterSets({
    bool? useUpperCase,
    bool? useLowerCase,
    bool? useNumbers,
    bool? useSpecialChars,
  }) {
    return CharacterSetResolver.resolve(
      this,
      useUpperCase: useUpperCase,
      useLowerCase: useLowerCase,
      useNumbers: useNumbers,
      useSpecialChars: useSpecialChars,
    );
  }

  /// Returns a single string containing all enabled characters for this configuration.
  String get combinedPool {
    return resolveCharacterSets().values.join();
  }
}
