import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_engine/password_engine.dart';

import 'strategies/custom_pin_strategy.dart';
import 'strategies/memorable_password_strategy.dart';
import 'strategies/pronounceable_password_strategy.dart';
import 'strength_estimators/zxcvbn_strength_estimator.dart';
import 'widgets/action_buttons.dart';
import 'widgets/customize_character_sets_dialog.dart';
import 'widgets/password_display.dart';
import 'widgets/password_options.dart';
import 'widgets/strategies/custom_pin_strategy_controls.dart';
import 'widgets/strategies/memorable_strategy_controls.dart';
import 'widgets/strategies/pronounceable_strategy_controls.dart';
import 'widgets/strategies/random_strategy_controls.dart';

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
      onBackground: const Color(0xFFF6F1EA),
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
  final int _maxGenerationAttempts =
      PasswordGeneratorConfig.defaultMaxGenerationAttempts;

  // Strategy selection
  final List<IPasswordGenerationStrategy> _strategies = [
    RandomPasswordStrategy(),
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
        _strength = _generator.estimateStrength(_password);
      } catch (e) {
        _password = 'Error: ${e.toString()}';
        _strength = PasswordStrength.veryWeak;
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
        _strength = _generator.estimateStrength(_password);
      } catch (e) {
        _password = 'Error: ${e.toString()}';
        _strength = PasswordStrength.veryWeak;
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
    _generator = PasswordGenerator(
      generationStrategy: _selectedStrategy,
      strengthEstimator: _useZxcvbn
          ? ExampleZxcvbnStrengthEstimator(userInputs: _collectUserInputs())
          : null,
    );
  }

  void _applyConfig() {
    _generator.updateConfig(
      PasswordGeneratorConfig(
        length: _length.round(),
        useUpperCase: _useUpperCase,
        useLowerCase: _useLowerCase,
        useNumbers: _useNumbers,
        useSpecialChars: _useSpecialChars,
        excludeAmbiguousChars: _excludeAmbiguousChars,
        characterSetProfile: _characterSetProfile,
        maxGenerationAttempts: _maxGenerationAttempts,
        extra: {
          'prefix': _prefixController.text,
        },
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                        onCopy: () {
                          Clipboard.setData(ClipboardData(text: _password));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Password copied to clipboard'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
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
                          onLengthChanged: (value) {
                            setState(() {
                              _length = value;
                              _generatePassword();
                            });
                          },
                          onUpperCaseChanged: (value) {
                            if (value == false &&
                                !_useLowerCase &&
                                !_useNumbers &&
                                !_useSpecialChars) {
                              _showError(
                                  'At least one character type must be selected');
                              return;
                            }
                            setState(() {
                              _useUpperCase = value ?? true;
                              _generatePassword();
                            });
                          },
                          onLowerCaseChanged: (value) {
                            if (value == false &&
                                !_useUpperCase &&
                                !_useNumbers &&
                                !_useSpecialChars) {
                              _showError(
                                  'At least one character type must be selected');
                              return;
                            }
                            setState(() {
                              _useLowerCase = value ?? true;
                              _generatePassword();
                            });
                          },
                          onNumbersChanged: (value) {
                            if (value == false &&
                                !_useUpperCase &&
                                !_useLowerCase &&
                                !_useSpecialChars) {
                              _showError(
                                  'At least one character type must be selected');
                              return;
                            }
                            setState(() {
                              _useNumbers = value ?? true;
                              _generatePassword();
                            });
                          },
                          onSpecialCharsChanged: (value) {
                            if (value == false &&
                                !_useUpperCase &&
                                !_useLowerCase &&
                                !_useNumbers) {
                              _showError(
                                  'At least one character type must be selected');
                              return;
                            }
                            setState(() {
                              _useSpecialChars = value ?? true;
                              _generatePassword();
                            });
                          },
                          onExcludeAmbiguousCharsChanged: (value) {
                            setState(() {
                              _excludeAmbiguousChars = value ?? false;
                              _generatePassword();
                            });
                          },
                          onPrefixChanged: (_) => _generatePassword(),
                        ),
                        onStrategyChanged: (strategy) {
                          if (strategy != null) {
                            setState(() {
                              _selectedStrategy = strategy;
                              // Clamp length - reusing logic but could be cleaner
                              if (_selectedStrategy is RandomPasswordStrategy) {
                                if (_length < 12) _length = 12;
                                if (_length > 32) _length = 32;
                              } else if (_selectedStrategy
                                  is MemorablePasswordStrategy) {
                                if (_length < 4) _length = 4;
                                if (_length > 8) _length = 8;
                              } else if (_selectedStrategy
                                  is PronounceablePasswordStrategy) {
                                if (_length < 8) _length = 8;
                                if (_length > 20) _length = 20;
                              } else if (_selectedStrategy
                                  is CustomPinStrategy) {
                                if (_length < 4) _length = 4;
                                if (_length > 12) _length = 12;
                              }
                              _generatePassword();
                            });
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    AnimatedSection(
                      index: 4,
                      child: StrengthEstimatorCard(
                        useZxcvbn: _useZxcvbn,
                        onChanged: (value) {
                          setState(() {
                            _useZxcvbn = value;
                            _generatePassword();
                          });
                        },
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

class BackgroundLayers extends StatelessWidget {
  const BackgroundLayers({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFF6F1EA), Color(0xFFEFE6D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
        ),
        Positioned(
          top: -80,
          right: -40,
          child: Container(
            width: 220,
            height: 220,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFFFD6A5), Color(0x00FFD6A5)],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: -60,
          left: -20,
          child: Container(
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [Color(0xFFBDE0FE), Color(0x00BDE0FE)],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class AnimatedSection extends StatelessWidget {
  const AnimatedSection({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 450 + (index * 120));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final translate = 18 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translate),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({super.key, required this.onCustomize});

  final VoidCallback onCustomize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Password Studio',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Craft strong passwords with style, strategy, and real-world scoring.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.black54,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          FilledButton.tonalIcon(
            onPressed: onCustomize,
            icon: const Icon(Icons.tune),
            label: const Text('Character Sets'),
          ),
        ],
      ),
    );
  }
}

class StrengthEstimatorCard extends StatelessWidget {
  const StrengthEstimatorCard({
    super.key,
    required this.useZxcvbn,
    required this.onChanged,
  });

  final bool useZxcvbn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final estimatorLabel = useZxcvbn ? 'zxcvbn (direct)' : 'Entropy (default)';
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withOpacity(0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strength Estimator',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Active: $estimatorLabel'),
            SwitchListTile(
              key: const Key('toggle_zxcvbn'),
              title: const Text('Use zxcvbn directly'),
              subtitle:
                  const Text('More realistic scoring from the zxcvbn package.'),
              value: useZxcvbn,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

class StrategyControlsPanel extends StatelessWidget {
  const StrategyControlsPanel({
    super.key,
    required this.selectedStrategy,
    required this.length,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useNumbers,
    required this.useSpecialChars,
    required this.excludeAmbiguousChars,
    required this.prefixController,
    required this.onLengthChanged,
    required this.onUpperCaseChanged,
    required this.onLowerCaseChanged,
    required this.onNumbersChanged,
    required this.onSpecialCharsChanged,
    required this.onExcludeAmbiguousCharsChanged,
    required this.onPrefixChanged,
  });

  final IPasswordGenerationStrategy selectedStrategy;
  final double length;
  final bool useUpperCase;
  final bool useLowerCase;
  final bool useNumbers;
  final bool useSpecialChars;
  final bool excludeAmbiguousChars;
  final TextEditingController prefixController;
  final ValueChanged<double> onLengthChanged;
  final ValueChanged<bool?> onUpperCaseChanged;
  final ValueChanged<bool?> onLowerCaseChanged;
  final ValueChanged<bool?> onNumbersChanged;
  final ValueChanged<bool?> onSpecialCharsChanged;
  final ValueChanged<bool?> onExcludeAmbiguousCharsChanged;
  final ValueChanged<String> onPrefixChanged;

  @override
  Widget build(BuildContext context) {
    return switch (selectedStrategy) {
      RandomPasswordStrategy() => RandomStrategyControls(
          length: length,
          useUpperCase: useUpperCase,
          useLowerCase: useLowerCase,
          useNumbers: useNumbers,
          useSpecialChars: useSpecialChars,
          excludeAmbiguousChars: excludeAmbiguousChars,
          onLengthChanged: onLengthChanged,
          onUpperCaseChanged: onUpperCaseChanged,
          onLowerCaseChanged: onLowerCaseChanged,
          onNumbersChanged: onNumbersChanged,
          onSpecialCharsChanged: onSpecialCharsChanged,
          onExcludeAmbiguousCharsChanged: onExcludeAmbiguousCharsChanged,
        ),
      MemorablePasswordStrategy() => MemorableStrategyControls(
          length: length,
          onLengthChanged: onLengthChanged,
        ),
      PronounceablePasswordStrategy() => PronounceableStrategyControls(
          length: length,
          onLengthChanged: onLengthChanged,
        ),
      CustomPinStrategy() => CustomPinStrategyControls(
          length: length,
          prefixController: prefixController,
          onLengthChanged: onLengthChanged,
          onPrefixChanged: onPrefixChanged,
        ),
      _ => const SizedBox.shrink(),
    };
  }
}
