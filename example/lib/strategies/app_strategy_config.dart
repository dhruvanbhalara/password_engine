import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../constants/words.dart';
import '../state/generator_state.dart';
import '../widgets/strategies/custom_pin_strategy_controls.dart';
import '../widgets/strategies/memorable_strategy_controls.dart';
import '../widgets/strategies/pronounceable_strategy_controls.dart';
import '../widgets/strategies/random_strategy_controls.dart';
import 'custom_pin_strategy.dart';
import 'memorable_password_strategy.dart';
import 'pronounceable_password_strategy.dart';

/// Configuration wrapper for password generation strategies inside the app.
/// This respects the Open/Closed principle by mapping configuration and metadata
/// outside of the actual state variables, avoiding explicit type checks (`is`).
class AppStrategyConfig {
  final String name;
  final IPasswordGenerationStrategy strategy;
  final double minLength;
  final double maxLength;
  final Widget Function(
          GeneratorState state, TextEditingController prefixController)?
      controlBuilder;

  const AppStrategyConfig({
    required this.name,
    required this.strategy,
    required this.minLength,
    required this.maxLength,
    this.controlBuilder,
  });
}

List<AppStrategyConfig> get availableAppStrategies => [
      AppStrategyConfig(
        name: 'Random',
        strategy: RandomPasswordStrategy(),
        minLength: 8,
        maxLength: 128,
        controlBuilder: (state, _) => RandomStrategyControls(state: state),
      ),
      AppStrategyConfig(
        name: 'Passphrase',
        strategy: PassphrasePasswordStrategy(wordlist: words, separator: ' '),
        minLength: 4,
        maxLength: 8,
        controlBuilder: (state, _) => MemorableStrategyControls(state: state),
      ),
      AppStrategyConfig(
        name: 'Memorable',
        strategy: MemorablePasswordStrategy(),
        minLength: 4,
        maxLength: 8,
        controlBuilder: (state, _) => MemorableStrategyControls(state: state),
      ),
      AppStrategyConfig(
        name: 'Pronounceable',
        strategy: PronounceablePasswordStrategy(),
        minLength: 8,
        maxLength: 20,
        controlBuilder: (state, _) =>
            PronounceableStrategyControls(state: state),
      ),
      AppStrategyConfig(
        name: 'Custom PIN',
        strategy: CustomPinStrategy(),
        minLength: 4,
        maxLength: 12,
        controlBuilder: (state, prefixController) => CustomPinStrategyControls(
          state: state,
          prefixController: prefixController,
        ),
      ),
    ];
