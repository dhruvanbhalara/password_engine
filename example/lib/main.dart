import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_engine/password_engine.dart';

import 'constants/words.dart';
import 'strategies/custom_pin_strategy.dart';
import 'strategies/memorable_password_strategy.dart';
import 'strategies/pronounceable_password_strategy.dart';
import 'strength_estimators/zxcvbn_strength_estimator.dart';
import 'widgets/action_buttons.dart';
import 'widgets/animated_section.dart';
import 'widgets/background_layers.dart';
import 'widgets/customize_character_sets_dialog.dart';
import 'widgets/header_card.dart';
import 'widgets/password_display.dart';
import 'widgets/password_options.dart';
import 'widgets/policy_controls_card.dart';
import 'widgets/strategy_controls_panel.dart';
import 'widgets/strength_estimator_card.dart';

void main() {
  runApp(const ExampleApp());
}

class ExampleApp extends StatelessWidget {
  const ExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF1F6F78),
      primary: const Color(0xFF1F6F78),
      secondary: const Color(0xFFD95F52),
      surface: const Color(0xFFFFFBF6),
    );
    final baseTheme = ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,
      scaffoldBackgroundColor: colorScheme.surface,
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
    );
    return MaterialApp(
      title: 'Password Studio',
      theme: baseTheme,
      themeMode: ThemeMode.light,
      home: const PasswordExample(),
    );
  }
}

class PasswordExample extends StatefulWidget {
  const PasswordExample({super.key});

  @override
  State<PasswordExample> createState() => _PasswordExampleState();
}

class _PasswordExampleState extends State<PasswordExample>
    with SingleTickerProviderStateMixin {
  PasswordGenerator _generator = PasswordGenerator();
  String _password = '';
  PasswordStrength _strength = PasswordStrength.veryWeak;
  PasswordFeedback _feedback =
      const PasswordFeedback(strength: PasswordStrength.veryWeak);
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  // Add password generation parameters
  double _length = 12;
  bool _useUpperCase = true;
  bool _useLowerCase = true;
  bool _useNumbers = true;
  bool _useSpecialChars = true;
  bool _excludeAmbiguousChars = false;
  CharacterSetProfile _characterSetProfile = CharacterSetProfile.defaultProfile;
  bool _useZxcvbn = false;
  bool _usePolicy = true;
  double _policyMinLength = 12;
  bool _usePolicyMaxLength = false;
  double _policyMaxLength = 24;
  bool _policyRequireUppercase = false;
  bool _policyRequireLowercase = false;
  bool _policyRequireNumber = false;
  bool _policyRequireSpecial = false;
  bool _policyAllowSpaces = false;
  bool _useBlocklist = false;
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

  // Strategy selection
  final List<IPasswordGenerationStrategy> _strategies = [
    RandomPasswordStrategy(),
    PassphrasePasswordStrategy(wordlist: words, separator: ' '),
    MemorablePasswordStrategy(),
    PronounceablePasswordStrategy(),
    CustomPinStrategy(),
  ];
  late IPasswordGenerationStrategy _selectedStrategy;

  // Add controllers for text fields
  final TextEditingController _prefixController = TextEditingController(
    text: 'USER',
  );

  @override
  void initState() {
    super.initState();
    _selectedStrategy = _strategies[0];
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Generate initial password after first frame to avoid context issues
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _generatePassword();
    });
  }

  void _generatePassword() {
    setState(() {
      try {
        _updateGenerator();
        _applyConfig();
        _password = _generator.generatePassword();
        _feedback = _generator.estimateFeedback(_password);
        _strength = _feedback.strength;
      } catch (e) {
        _password = 'Error: ${e.toString()}';
        _strength = PasswordStrength.veryWeak;
        _feedback = const PasswordFeedback(
          strength: PasswordStrength.veryWeak,
          warning: 'Generation failed',
          suggestions: ['Review the current settings'],
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      _controller.reset();
      _controller.forward();
    });
  }

  void _generateStrongPassword() {
    setState(() {
      try {
        _updateGenerator();
        _applyConfig();
        _password = _generator.refreshPassword();
        _feedback = _generator.estimateFeedback(_password);
        _strength = _feedback.strength;
      } catch (e) {
        _password = 'Error: ${e.toString()}';
        _strength = PasswordStrength.veryWeak;
        _feedback = const PasswordFeedback(
          strength: PasswordStrength.veryWeak,
          warning: 'Generation failed',
          suggestions: ['Review the current settings'],
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.toString())),
        );
      }
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  void _showCustomizeDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomizeCharacterSetsDialog(
        initialProfile: _characterSetProfile,
        onSave: (profile) {
          setState(() {
            _characterSetProfile = profile;
          });
          _generatePassword();
        },
      ),
    );
  }

  List<String> _collectUserInputs() {
    final prefix = _prefixController.text.trim();
    if (prefix.isEmpty) return const [];
    return [prefix];
  }

  void _updateGenerator() {
    final validator = _useBlocklist
        ? BlocklistPasswordValidator(
            blockedPasswords: _defaultBlocklist,
            normalizer: _blocklistNormalizer,
          )
        : null;
    final feedbackProvider = _ExampleFeedbackProvider(
      blockedPasswords: _defaultBlocklist,
      blocklistEnabled: _useBlocklist,
      normalizer: _blocklistNormalizer,
    );
    _generator = PasswordGenerator(
      validator: validator,
      generationStrategy: _selectedStrategy,
      strengthEstimator: _useZxcvbn
          ? ExampleZxcvbnStrengthEstimator(userInputs: _collectUserInputs())
          : null,
      feedbackProvider: feedbackProvider,
    );
  }

  void _applyConfig() {
    final policy = _buildPolicy();
    final profile = _policyAllowSpaces
        ? _withSpaces(_characterSetProfile)
        : _characterSetProfile;
    _generator.updateConfig(
      PasswordGeneratorConfig(
        length: _length.round(),
        useUpperCase: _useUpperCase,
        useLowerCase: _useLowerCase,
        useNumbers: _useNumbers,
        useSpecialChars: _useSpecialChars,
        excludeAmbiguousChars: _excludeAmbiguousChars,
        characterSetProfile: profile,
        maxGenerationAttempts: _maxGenerationAttempts,
        policy: policy,
        extra: {
          'prefix': _prefixController.text,
        },
      ),
    );
  }

  PasswordPolicy? _buildPolicy() {
    if (!_usePolicy) return null;

    final minLength = _policyMinLength.round();
    final maxLength = _usePolicyMaxLength ? _policyMaxLength.round() : null;
    final safeMaxLength =
        maxLength != null && maxLength < minLength ? minLength : maxLength;

    return PasswordPolicy(
      minLength: minLength,
      maxLength: safeMaxLength,
      requireUppercase: _policyRequireUppercase,
      requireLowercase: _policyRequireLowercase,
      requireNumber: _policyRequireNumber,
      requireSpecial: _policyRequireSpecial,
      allowSpaces: _policyAllowSpaces,
    );
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

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _handleCopyPassword() {
    Clipboard.setData(ClipboardData(text: _password));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleLengthChanged(double value) {
    setState(() {
      _length = value;
      _generatePassword();
    });
  }

  void _handleUpperCaseChanged(bool? value) {
    if (value == false && !_useLowerCase && !_useNumbers && !_useSpecialChars) {
      _showError('At least one character type must be selected');
      return;
    }
    setState(() {
      _useUpperCase = value ?? true;
      _generatePassword();
    });
  }

  void _handleLowerCaseChanged(bool? value) {
    if (value == false && !_useUpperCase && !_useNumbers && !_useSpecialChars) {
      _showError('At least one character type must be selected');
      return;
    }
    setState(() {
      _useLowerCase = value ?? true;
      _generatePassword();
    });
  }

  void _handleNumbersChanged(bool? value) {
    if (value == false &&
        !_useUpperCase &&
        !_useLowerCase &&
        !_useSpecialChars) {
      _showError('At least one character type must be selected');
      return;
    }
    setState(() {
      _useNumbers = value ?? true;
      _generatePassword();
    });
  }

  void _handleSpecialCharsChanged(bool? value) {
    if (value == false && !_useUpperCase && !_useLowerCase && !_useNumbers) {
      _showError('At least one character type must be selected');
      return;
    }
    setState(() {
      _useSpecialChars = value ?? true;
      _generatePassword();
    });
  }

  void _handleExcludeAmbiguousChanged(bool? value) {
    setState(() {
      _excludeAmbiguousChars = value ?? false;
      _generatePassword();
    });
  }

  void _handlePrefixChanged(String _) {
    _generatePassword();
  }

  void _handleStrategyChanged(IPasswordGenerationStrategy? strategy) {
    if (strategy == null) return;
    setState(() {
      _selectedStrategy = strategy;
      if (_selectedStrategy is RandomPasswordStrategy) {
        if (_length < 12) _length = 12;
        if (_length > 32) _length = 32;
      } else if (_selectedStrategy is PassphrasePasswordStrategy) {
        if (_length < 4) _length = 4;
        if (_length > 8) _length = 8;
      } else if (_selectedStrategy is MemorablePasswordStrategy) {
        if (_length < 4) _length = 4;
        if (_length > 8) _length = 8;
      } else if (_selectedStrategy is PronounceablePasswordStrategy) {
        if (_length < 8) _length = 8;
        if (_length > 20) _length = 20;
      } else if (_selectedStrategy is CustomPinStrategy) {
        if (_length < 4) _length = 4;
        if (_length > 12) _length = 12;
      }
      _generatePassword();
    });
  }

  void _handlePolicyEnabledChanged(bool value) {
    setState(() {
      _usePolicy = value;
      _generatePassword();
    });
  }

  void _handlePolicyMinLengthChanged(double value) {
    setState(() {
      _policyMinLength = value;
      if (_usePolicyMaxLength && _policyMaxLength < _policyMinLength) {
        _policyMaxLength = _policyMinLength;
      }
      _generatePassword();
    });
  }

  void _handlePolicyUseMaxLengthChanged(bool value) {
    setState(() {
      _usePolicyMaxLength = value;
      if (_usePolicyMaxLength && _policyMaxLength < _policyMinLength) {
        _policyMaxLength = _policyMinLength;
      }
      _generatePassword();
    });
  }

  void _handlePolicyMaxLengthChanged(double value) {
    setState(() {
      _policyMaxLength = value;
      _generatePassword();
    });
  }

  void _handlePolicyRequireUppercaseChanged(bool? value) {
    setState(() {
      _policyRequireUppercase = value ?? false;
      _generatePassword();
    });
  }

  void _handlePolicyRequireLowercaseChanged(bool? value) {
    setState(() {
      _policyRequireLowercase = value ?? false;
      _generatePassword();
    });
  }

  void _handlePolicyRequireNumberChanged(bool? value) {
    setState(() {
      _policyRequireNumber = value ?? false;
      _generatePassword();
    });
  }

  void _handlePolicyRequireSpecialChanged(bool? value) {
    setState(() {
      _policyRequireSpecial = value ?? false;
      _generatePassword();
    });
  }

  void _handlePolicyAllowSpacesChanged(bool value) {
    setState(() {
      _policyAllowSpaces = value;
      _generatePassword();
    });
  }

  void _handleBlocklistChanged(bool value) {
    setState(() {
      _useBlocklist = value;
      _generatePassword();
    });
  }

  void _handleStrengthEstimatorChanged(bool value) {
    setState(() {
      _useZxcvbn = value;
      _generatePassword();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const BackgroundLayers(),
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedSection(
                      index: 0,
                      child: HeaderCard(onCustomize: _showCustomizeDialog),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 1,
                      child: PasswordDisplay(
                        password: _password,
                        strength: _strength,
                        feedback: _feedback,
                        fadeAnimation: _fadeAnimation,
                        estimatorLabel: _useZxcvbn
                            ? 'zxcvbn (direct)'
                            : 'Entropy (default)',
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 2,
                      child: ActionButtons(
                        onCopy: _handleCopyPassword,
                        onGenerate: _generatePassword,
                        onGenerateStrong: _generateStrongPassword,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 3,
                      child: PasswordOptions(
                        strategies: _strategies,
                        selectedStrategy: _selectedStrategy,
                        strategyControls: StrategyControlsPanel(
                          selectedStrategy: _selectedStrategy,
                          length: _length,
                          useUpperCase: _useUpperCase,
                          useLowerCase: _useLowerCase,
                          useNumbers: _useNumbers,
                          useSpecialChars: _useSpecialChars,
                          excludeAmbiguousChars: _excludeAmbiguousChars,
                          prefixController: _prefixController,
                          onLengthChanged: _handleLengthChanged,
                          onUpperCaseChanged: _handleUpperCaseChanged,
                          onLowerCaseChanged: _handleLowerCaseChanged,
                          onNumbersChanged: _handleNumbersChanged,
                          onSpecialCharsChanged: _handleSpecialCharsChanged,
                          onExcludeAmbiguousCharsChanged:
                              _handleExcludeAmbiguousChanged,
                          onPrefixChanged: _handlePrefixChanged,
                        ),
                        onStrategyChanged: _handleStrategyChanged,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 4,
                      child: PolicyControlsCard(
                        policyEnabled: _usePolicy,
                        minLength: _policyMinLength,
                        useMaxLength: _usePolicyMaxLength,
                        maxLength: _policyMaxLength,
                        requireUppercase: _policyRequireUppercase,
                        requireLowercase: _policyRequireLowercase,
                        requireNumber: _policyRequireNumber,
                        requireSpecial: _policyRequireSpecial,
                        allowSpaces: _policyAllowSpaces,
                        useBlocklist: _useBlocklist,
                        onPolicyEnabledChanged: _handlePolicyEnabledChanged,
                        onMinLengthChanged: _handlePolicyMinLengthChanged,
                        onUseMaxLengthChanged: _handlePolicyUseMaxLengthChanged,
                        onMaxLengthChanged: _handlePolicyMaxLengthChanged,
                        onRequireUppercaseChanged:
                            _handlePolicyRequireUppercaseChanged,
                        onRequireLowercaseChanged:
                            _handlePolicyRequireLowercaseChanged,
                        onRequireNumberChanged:
                            _handlePolicyRequireNumberChanged,
                        onRequireSpecialChanged:
                            _handlePolicyRequireSpecialChanged,
                        onAllowSpacesChanged: _handlePolicyAllowSpacesChanged,
                        onUseBlocklistChanged: _handleBlocklistChanged,
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 5,
                      child: StrengthEstimatorCard(
                        useZxcvbn: _useZxcvbn,
                        onChanged: _handleStrengthEstimatorChanged,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleFeedbackProvider implements IContextualPasswordFeedbackProvider {
  _ExampleFeedbackProvider({
    required Set<String> blockedPasswords,
    required IPasswordNormalizer normalizer,
    required bool blocklistEnabled,
  })  : _blockedPasswords = blockedPasswords,
        _normalizer = normalizer,
        _blocklistEnabled = blocklistEnabled;

  final Set<String> _blockedPasswords;
  final IPasswordNormalizer _normalizer;
  final bool _blocklistEnabled;
  final PasswordFeedbackBuilder _baseBuilder = PasswordFeedbackBuilder();

  @override
  PasswordFeedback build(PasswordStrength strength) {
    return _baseBuilder.build(strength);
  }

  @override
  PasswordFeedback buildWithContext(PasswordFeedbackContext context) {
    if (_blocklistEnabled) {
      final normalized = _normalizer.normalize(context.password);
      if (_blockedPasswords.contains(normalized)) {
        return const PasswordFeedback(
          strength: PasswordStrength.veryWeak,
          warning: 'Blocked password',
          suggestions: ['Avoid common passwords', 'Generate a new one'],
        );
      }
    }

    final baseFeedback = _baseBuilder.build(context.strength);
    final policy = context.config.policy;
    if (policy == null) {
      return baseFeedback;
    }

    final suggestions = <String>[
      ...baseFeedback.suggestions,
    ];
    String? warning;

    if (context.password.length < policy.minLength) {
      warning ??= 'Below policy minimum length';
      suggestions.add('Use at least ${policy.minLength} characters');
    }
    if (policy.maxLength != null &&
        context.password.length > policy.maxLength!) {
      warning ??= 'Exceeds policy maximum length';
      suggestions.add('Keep it under ${policy.maxLength} characters');
    }
    if (policy.requireUppercase && !_hasUppercase(context.password)) {
      suggestions.add('Add an uppercase letter');
    }
    if (policy.requireLowercase && !_hasLowercase(context.password)) {
      suggestions.add('Add a lowercase letter');
    }
    if (policy.requireNumber && !_hasNumber(context.password)) {
      suggestions.add('Add a number');
    }
    if (policy.requireSpecial &&
        !_hasSpecial(context.password, allowSpaces: policy.allowSpaces)) {
      suggestions.add('Add a special character');
    }

    if (suggestions.isEmpty && warning == null) {
      return baseFeedback;
    }

    return PasswordFeedback(
      strength: baseFeedback.strength,
      warning: warning ?? baseFeedback.warning,
      suggestions: suggestions.toSet().toList(),
      estimatedEntropy: baseFeedback.estimatedEntropy,
      score: baseFeedback.score,
    );
  }

  bool _hasUppercase(String password) => RegExp(r'[A-Z]').hasMatch(password);

  bool _hasLowercase(String password) => RegExp(r'[a-z]').hasMatch(password);

  bool _hasNumber(String password) => RegExp(r'\d').hasMatch(password);

  bool _hasSpecial(String password, {required bool allowSpaces}) {
    final pattern = allowSpaces ? r'[^A-Za-z0-9]' : r'[^A-Za-z0-9 ]';
    return RegExp(pattern).hasMatch(password);
  }
}

class _LowercasePasswordNormalizer implements IPasswordNormalizer {
  const _LowercasePasswordNormalizer();

  @override
  String normalize(String password) => password.toLowerCase();
}
