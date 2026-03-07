import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'state/generator_state.dart';
import 'theme/app_theme.dart';
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

class PasswordExample extends StatefulWidget {
  final ThemeMode currentThemeMode;
  final VoidCallback onThemeToggle;

  const PasswordExample({
    super.key,
    required this.currentThemeMode,
    required this.onThemeToggle,
  });

  @override
  State<PasswordExample> createState() => _PasswordExampleState();
}

class _PasswordExampleState extends State<PasswordExample>
    with SingleTickerProviderStateMixin {
  late final GeneratorState _state;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  final TextEditingController _prefixController =
      TextEditingController(text: 'USER');
  String _lastPassword = '';

  @override
  void initState() {
    super.initState();
    _state = GeneratorState();
    _state.addListener(_onStateChanged);

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _prefixController.addListener(() {
      _state.setPrefix(_prefixController.text);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _state.generatePassword();
    });
  }

  void _onStateChanged() {
    if (_state.errorMessage != null) {
      final errorMessage = _state.errorMessage!;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        _state.clearError();
      });
    }

    if (_state.password.value != _lastPassword) {
      _lastPassword = _state.password.value;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _state.removeListener(_onStateChanged);
    _state.dispose();
    _controller.dispose();
    _prefixController.dispose();
    super.dispose();
  }

  void _showCustomizeDialog() {
    showDialog(
      context: context,
      builder: (context) => CustomizeCharacterSetsDialog(
        initialProfile: _state.characterSetProfile,
        onSave: (profile) {
          _state.setCharacterSetProfile(profile);
        },
      ),
    );
  }

  void _handleCopyPassword() {
    Clipboard.setData(ClipboardData(text: _state.password.value));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password copied to clipboard'),
        duration: Duration(seconds: 2),
      ),
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
                child: ListenableBuilder(
                  listenable: _state,
                  builder: (context, _) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AnimatedSection(
                          index: 0,
                          child: HeaderCard(
                            onCustomize: _showCustomizeDialog,
                            currentThemeMode: widget.currentThemeMode,
                            onThemeToggle: widget.onThemeToggle,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AnimatedSection(
                          index: 1,
                          child: PasswordDisplay(
                            password: _state.isPasswordVisible
                                ? _state.password.value
                                : _state.password.masked,
                            strength: _state.strength,
                            feedback: _state.feedback,
                            fadeAnimation: _fadeAnimation,
                            estimatorLabel: _state.useZxcvbn
                                ? 'zxcvbn (direct)'
                                : 'Entropy (default)',
                            isVisible: _state.isPasswordVisible,
                            onVisibilityToggle: _state.togglePasswordVisibility,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSection(
                          index: 2,
                          child: ActionButtons(
                            onGenerate: _state.generatePassword,
                            onGenerateStrong: _state.generateStrongPassword,
                            onCopy: _handleCopyPassword,
                          ),
                        ),
                        const SizedBox(height: 24),
                        AnimatedSection(
                          index: 3,
                          child: PasswordOptions(state: _state),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSection(
                          index: 4,
                          child: StrengthEstimatorCard(
                            useZxcvbn: _state.useZxcvbn,
                            onChanged: _state.toggleZxcvbn,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSection(
                          index: 5,
                          child: StrategyControlsPanel(
                            state: _state,
                            prefixController: _prefixController,
                          ),
                        ),
                        const SizedBox(height: 16),
                        AnimatedSection(
                          index: 6,
                          child: PolicyControlsCard(state: _state),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
