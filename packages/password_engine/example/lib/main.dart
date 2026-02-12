import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_zxcvbn/password_engine_zxcvbn.dart';

import 'strategies/custom_pin_strategy.dart';
import 'strategies/memorable_password_strategy.dart';
import 'strategies/pronounceable_password_strategy.dart';
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
    return MaterialApp(
      title: 'Password Generator Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: ThemeMode.system,
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
  PasswordGenerator _generator = PasswordGenerator(
    strengthEstimator: ZxcvbnStrengthEstimator(),
  );
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
        _generator.updateConfig(
          PasswordGeneratorConfig(
            length: _length.round(),
            useUpperCase: _useUpperCase,
            useLowerCase: _useLowerCase,
            useNumbers: _useNumbers,
            useSpecialChars: _useSpecialChars,
            excludeAmbiguousChars: _excludeAmbiguousChars,
            extra: {
              'prefix': _prefixController.text,
            },
          ),
        );
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
        onSave: _generatePassword,
      ),
    );
  }

  Widget _buildStrategyControls() {
    return switch (_selectedStrategy) {
      RandomPasswordStrategy() => RandomStrategyControls(
          length: _length,
          useUpperCase: _useUpperCase,
          useLowerCase: _useLowerCase,
          useNumbers: _useNumbers,
          useSpecialChars: _useSpecialChars,
          excludeAmbiguousChars: _excludeAmbiguousChars,
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
              _showError('At least one character type must be selected');
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
              _showError('At least one character type must be selected');
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
              _showError('At least one character type must be selected');
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
              _showError('At least one character type must be selected');
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
        ),
      MemorablePasswordStrategy() => MemorableStrategyControls(
          length: _length,
          onLengthChanged: (value) {
            setState(() {
              _length = value;
              _generatePassword();
            });
          },
        ),
      PronounceablePasswordStrategy() => PronounceableStrategyControls(
          length: _length,
          onLengthChanged: (value) {
            setState(() {
              _length = value;
              _generatePassword();
            });
          },
        ),
      CustomPinStrategy() => CustomPinStrategyControls(
          length: _length,
          prefixController: _prefixController,
          onLengthChanged: (value) {
            setState(() {
              _length = value;
              _generatePassword();
            });
          },
          onPrefixChanged: (_) => _generatePassword(),
        ),
      _ => const SizedBox.shrink(),
    };
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Password Generator Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showCustomizeDialog,
            tooltip: 'Customize Character Sets',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              PasswordDisplay(
                password: _password,
                strength: _strength,
                fadeAnimation: _fadeAnimation,
              ),
              const SizedBox(height: 24),
              ActionButtons(
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
              ),
              const SizedBox(height: 24),
              PasswordOptions(
                strategies: _strategies,
                selectedStrategy: _selectedStrategy,
                strategyControls: _buildStrategyControls(),
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
                      } else if (_selectedStrategy is CustomPinStrategy) {
                        if (_length < 4) _length = 4;
                        if (_length > 12) _length = 12;
                      }

                      _generator = PasswordGenerator(
                        generationStrategy: _selectedStrategy,
                        strengthEstimator: ZxcvbnStrengthEstimator(),
                      );
                      _generator.updateConfig(
                        PasswordGeneratorConfig(
                          length: _length.round(),
                          useUpperCase: _useUpperCase,
                          useLowerCase: _useLowerCase,
                          useNumbers: _useNumbers,
                          useSpecialChars: _useSpecialChars,
                          excludeAmbiguousChars: _excludeAmbiguousChars,
                        ),
                      );
                      _generatePassword();
                    });
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
