import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../policies/custom_corporate_policy.dart';
import '../strategies/app_strategy_config.dart';
import '../strength_estimators/zxcvbn_strength_estimator.dart';

enum CharacterType { upper, lower, numbers, special, spaces }

class GeneratorState extends ChangeNotifier {
  PasswordGenerator _generator = PasswordGenerator();

  // Output State
  SensitivePassword _password = const SensitivePassword('');
  SensitivePassword get password => _password;

  bool _isPasswordVisible = true;
  bool get isPasswordVisible => _isPasswordVisible;

  PasswordStrength _strength = PasswordStrength.veryWeak;
  PasswordStrength get strength => _strength;

  PasswordFeedback _feedback =
      const PasswordFeedback(strength: PasswordStrength.veryWeak);
  PasswordFeedback get feedback => _feedback;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  // Generator Config State
  double _length = 16;
  double get length => _length;

  double get sliderMinLength {
    final baseMin = _selectedStrategyConfig.minLength;
    if (_selectedStrategyConfig.name != 'Random' &&
        _selectedStrategyConfig.name != 'Pronounceable') {
      return baseMin; // Word/PIN formats ignore strict char count policies visually.
    }
    if (_useCorporatePolicy) {
      return CustomCorporatePolicy.strictPolicy.minLength.toDouble();
    }
    if (_usePolicy && _policyMinLength > baseMin) return _policyMinLength;
    return baseMin;
  }

  double get sliderMaxLength {
    final baseMax = _selectedStrategyConfig.maxLength;
    if (_selectedStrategyConfig.name != 'Random' &&
        _selectedStrategyConfig.name != 'Pronounceable') {
      return baseMax;
    }
    if (_useCorporatePolicy) return baseMax;
    if (_usePolicy && _usePolicyMaxLength && _policyMaxLength < baseMax) {
      // Ensure max isn't physically lower than the current min bounds
      return _policyMaxLength < sliderMinLength
          ? sliderMinLength
          : _policyMaxLength;
    }
    return baseMax;
  }

  bool _useUpperCase = true;
  bool get useUpperCase => _useUpperCase;

  bool _useLowerCase = true;
  bool get useLowerCase => _useLowerCase;

  bool _useNumbers = true;
  bool get useNumbers => _useNumbers;

  bool _useSpecialChars = true;
  bool get useSpecialChars => _useSpecialChars;

  bool _excludeAmbiguousChars = false;
  bool get excludeAmbiguousChars => _excludeAmbiguousChars;

  CharacterSetProfile _characterSetProfile = CharacterSetProfile.defaultProfile;
  CharacterSetProfile get characterSetProfile => _characterSetProfile;

  bool _useZxcvbn = false;
  bool get useZxcvbn => _useZxcvbn;

  // Policy Config State
  bool _usePolicy = true;
  bool get usePolicy => _usePolicy;

  bool _useCorporatePolicy = false;
  bool get useCorporatePolicy => _useCorporatePolicy;

  double _policyMinLength = 16;
  double get policyMinLength => _policyMinLength;

  bool _usePolicyMaxLength = false;
  bool get usePolicyMaxLength => _usePolicyMaxLength;

  double _policyMaxLength = 24;
  double get policyMaxLength => _policyMaxLength;

  bool _policyRequireUppercase = false;
  bool get policyRequireUppercase => _policyRequireUppercase;

  bool _policyRequireLowercase = false;
  bool get policyRequireLowercase => _policyRequireLowercase;

  bool _policyRequireNumber = false;
  bool get policyRequireNumber => _policyRequireNumber;

  bool _policyRequireSpecial = false;
  bool get policyRequireSpecial => _policyRequireSpecial;

  bool _policyAllowSpaces = false;
  bool get policyAllowSpaces => _policyAllowSpaces;

  bool _useBlocklist = false;
  bool get useBlocklist => _useBlocklist;

  final int _maxGenerationAttempts =
      PasswordGeneratorConfig.defaultMaxGenerationAttempts;

  static const Set<String> _defaultBlocklist = {
    'password',
    '123456',
    'qwerty',
    'letmein',
    'password1',
    'admin',
  };
  static const _LowercasePasswordNormalizer _blocklistNormalizer =
      _LowercasePasswordNormalizer();

  late final List<AppStrategyConfig> strategies;
  late AppStrategyConfig _selectedStrategyConfig;
  AppStrategyConfig get selectedStrategyConfig => _selectedStrategyConfig;

  String _prefix = 'USER';
  String get prefix => _prefix;

  GeneratorState() {
    strategies = availableAppStrategies;
    _selectedStrategyConfig = strategies[0];
    generatePassword();
  }

  void clearError() {
    if (_errorMessage != null) {
      _errorMessage = null;
      notifyListeners();
    }
  }

  void generatePassword() {
    clearError();
    try {
      _updateGenerator();
      _applyConfig();
      _password = SensitivePassword(_generator.generatePassword());
      _feedback = _generator.estimateFeedback(_password.value);
      _strength = _feedback.strength;
    } catch (e) {
      _handleGenerationError(e);
    }
    notifyListeners();
  }

  void generateStrongPassword() {
    clearError();
    try {
      _updateGenerator();
      _applyConfig();
      _password = SensitivePassword(_generator.refreshPassword());
      _feedback = _generator.estimateFeedback(_password.value);
      _strength = _feedback.strength;
    } catch (e) {
      _handleGenerationError(e);
    }
    notifyListeners();
  }

  void _handleGenerationError(Object e) {
    _password = SensitivePassword('Error: ${e.toString()}');
    _strength = PasswordStrength.veryWeak;
    _feedback = const PasswordFeedback(
      strength: PasswordStrength.veryWeak,
      warning: 'Generation failed',
      suggestions: ['Review the current settings'],
    );
    _errorMessage = e.toString();
  }

  // --- Internals ---

  void _updateGenerator() {
    IPasswordValidator? baseValidator;
    if (_useBlocklist) {
      // Wrap the blocklist validator inside a NormalizedPasswordValidator
      // to demonstrate the decorator pattern described in library-flow.md
      baseValidator = NormalizedPasswordValidator(
        baseValidator: BlocklistPasswordValidator(
          blockedPasswords: _defaultBlocklist,
          normalizer: _blocklistNormalizer,
        ),
        normalizer: _blocklistNormalizer,
      );
    }

    final feedbackProvider = _ExampleFeedbackProvider(
      blockedPasswords: _defaultBlocklist,
      blocklistEnabled: _useBlocklist,
      normalizer: _blocklistNormalizer,
    );

    _generator = PasswordGenerator(
      validator: baseValidator,
      generationStrategy: _selectedStrategyConfig.strategy,
      strengthEstimator: _useZxcvbn
          ? ExampleZxcvbnStrengthEstimator(userInputs: _collectUserInputs())
          : null,
      feedbackProvider: feedbackProvider,
    );
  }

  List<String> _collectUserInputs() {
    final cleanPrefix = _prefix.trim();
    if (cleanPrefix.isEmpty) return const [];
    return [cleanPrefix];
  }

  void _applyConfig() {
    final policy = _buildPolicy();
    final profile = _policyAllowSpaces
        ? _withSpaces(_characterSetProfile)
        : _characterSetProfile;

    final configBuilder = PasswordGeneratorConfigBuilder()
        .length(_length.round())
        .useUpperCase(_useUpperCase)
        .useLowerCase(_useLowerCase)
        .useNumbers(_useNumbers)
        .useSpecialChars(_useSpecialChars)
        .excludeAmbiguousChars(_excludeAmbiguousChars)
        .characterSetProfile(profile)
        .maxGenerationAttempts(_maxGenerationAttempts)
        .policy(policy)
        .extra('prefix', _prefix);

    if (_selectedStrategyConfig.name == 'Passphrase' ||
        _selectedStrategyConfig.name == 'Memorable') {
      configBuilder.extra('wordCount', _length.round());
    } else if (_selectedStrategyConfig.name == 'Custom PIN') {
      configBuilder.extra('numericLength', _length.round());
    }

    _generator.updateConfig(configBuilder.build());
  }

  PasswordPolicy? _buildPolicy() {
    if (!_usePolicy) return null;
    if (_useCorporatePolicy) return CustomCorporatePolicy.strictPolicy;

    final minLength = _policyMinLength.round();
    final maxLength = _usePolicyMaxLength ? _policyMaxLength.round() : null;
    final safeMaxLength =
        maxLength != null && maxLength < minLength ? minLength : maxLength;

    return PasswordPolicyBuilder()
        .minLength(minLength)
        .maxLength(safeMaxLength)
        .requireUppercase(_policyRequireUppercase)
        .requireLowercase(_policyRequireLowercase)
        .requireNumber(_policyRequireNumber)
        .requireSpecial(_policyRequireSpecial)
        .allowSpaces(_policyAllowSpaces)
        .build();
  }

  CharacterSetProfile _withSpaces(CharacterSetProfile profile) {
    final hasSpace = profile.specialCharacters.contains(' ');
    final hasSpaceNonAmbiguous =
        profile.specialCharactersNonAmbiguous.contains(' ');
    if (hasSpace && hasSpaceNonAmbiguous) return profile;

    return profile.copyWith(
      specialCharacters: hasSpace
          ? profile.specialCharacters
          : '${profile.specialCharacters} ',
      specialCharactersNonAmbiguous: hasSpaceNonAmbiguous
          ? profile.specialCharactersNonAmbiguous
          : '${profile.specialCharactersNonAmbiguous} ',
    );
  }

  // --- Intent Handlers (Setters) ---

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void setPrefix(String prefix) {
    _prefix = prefix;
    generatePassword();
  }

  void _clampLengthToPolicy() {
    double tempLength = _length;

    // Always fall within the newly bounded UI layout constraints instead
    final double safeMin = sliderMinLength;
    final double safeMax = sliderMaxLength;

    if (tempLength < safeMin) tempLength = safeMin;
    if (tempLength > safeMax) tempLength = safeMax;

    _length = tempLength;
  }

  void setStrategyConfig(AppStrategyConfig config) {
    _selectedStrategyConfig = config;
    if (_length < config.minLength) _length = config.minLength;
    if (_length > config.maxLength) _length = config.maxLength;
    _clampLengthToPolicy();
    generatePassword();
  }

  void setLength(double value) {
    _length = value;
    _clampLengthToPolicy();
    generatePassword();
  }

  void setUseCase(bool? value, CharacterType type) {
    if (value == false) {
      if (type == CharacterType.upper &&
          !_useLowerCase &&
          !_useNumbers &&
          !_useSpecialChars) {
        _errorMessage = 'At least one character type must be selected';
        notifyListeners();
        return;
      }
      if (type == CharacterType.lower &&
          !_useUpperCase &&
          !_useNumbers &&
          !_useSpecialChars) {
        _errorMessage = 'At least one character type must be selected';
        notifyListeners();
        return;
      }
      if (type == CharacterType.numbers &&
          !_useUpperCase &&
          !_useLowerCase &&
          !_useSpecialChars) {
        _errorMessage = 'At least one character type must be selected';
        notifyListeners();
        return;
      }
      if (type == CharacterType.special &&
          !_useUpperCase &&
          !_useLowerCase &&
          !_useNumbers) {
        _errorMessage = 'At least one character type must be selected';
        notifyListeners();
        return;
      }
    }

    switch (type) {
      case CharacterType.upper:
        _useUpperCase = value ?? true;
        break;
      case CharacterType.lower:
        _useLowerCase = value ?? true;
        break;
      case CharacterType.numbers:
        _useNumbers = value ?? true;
        break;
      case CharacterType.special:
        _useSpecialChars = value ?? true;
        break;
      case CharacterType.spaces:
        break;
    }
    generatePassword();
  }

  void setExcludeAmbiguousChars(bool? value) {
    _excludeAmbiguousChars = value ?? false;
    generatePassword();
  }

  void setCharacterSetProfile(CharacterSetProfile profile) {
    _characterSetProfile = profile;
    generatePassword();
  }

  void toggleZxcvbn(bool value) {
    _useZxcvbn = value;
    generatePassword();
  }

  void togglePolicyEnabled(bool value) {
    _usePolicy = value;
    _clampLengthToPolicy();
    generatePassword();
  }

  void toggleCorporatePolicy(bool value) {
    _useCorporatePolicy = value;
    _clampLengthToPolicy();
    generatePassword();
  }

  void setPolicyMinLength(double value) {
    _policyMinLength = value;
    if (_usePolicyMaxLength && _policyMaxLength < _policyMinLength) {
      _policyMaxLength = _policyMinLength;
    }
    _clampLengthToPolicy();
    generatePassword();
  }

  void togglePolicyMaxLength(bool value) {
    _usePolicyMaxLength = value;
    if (value && _policyMaxLength < _policyMinLength) {
      _policyMaxLength = _policyMinLength;
    }
    _clampLengthToPolicy();
    generatePassword();
  }

  void setPolicyMaxLength(double value) {
    _policyMaxLength = value;
    _clampLengthToPolicy();
    generatePassword();
  }

  void togglePolicyRequirement(bool? value, CharacterType type) {
    final val = value ?? false;
    switch (type) {
      case CharacterType.upper:
        _policyRequireUppercase = val;
        break;
      case CharacterType.lower:
        _policyRequireLowercase = val;
        break;
      case CharacterType.numbers:
        _policyRequireNumber = val;
        break;
      case CharacterType.special:
        _policyRequireSpecial = val;
        break;
      case CharacterType.spaces:
        _policyAllowSpaces = val;
        break;
    }
    generatePassword();
  }

  void toggleBlocklist(bool value) {
    _useBlocklist = value;
    generatePassword();
  }
}

class _LowercasePasswordNormalizer implements IPasswordNormalizer {
  const _LowercasePasswordNormalizer();
  @override
  String normalize(String password) => password.toLowerCase();
}

class _ExampleFeedbackProvider implements IContextualPasswordFeedbackProvider {
  final Set<String> blockedPasswords;
  final bool blocklistEnabled;
  final IPasswordNormalizer normalizer;
  final PasswordFeedbackBuilder _builder = PasswordFeedbackBuilder();

  _ExampleFeedbackProvider({
    required this.blockedPasswords,
    required this.blocklistEnabled,
    required this.normalizer,
  });

  @override
  PasswordFeedback build(PasswordStrength strength) {
    return _builder.build(strength);
  }

  @override
  PasswordFeedback buildWithContext(PasswordFeedbackContext context) {
    if (blocklistEnabled) {
      final normalized = normalizer.normalize(context.password);
      if (blockedPasswords.contains(normalized)) {
        return const PasswordFeedback(
          strength: PasswordStrength.veryWeak,
          warning: 'This password is in the blocklist',
          suggestions: ['Choose a completely different password'],
        );
      }
    }
    // Delegate to the robust library builder for localized policy suggestions
    return _builder.buildWithContext(context);
  }
}
