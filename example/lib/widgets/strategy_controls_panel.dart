import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../strategies/custom_pin_strategy.dart';
import '../strategies/memorable_password_strategy.dart';
import '../strategies/pronounceable_password_strategy.dart';
import 'strategies/custom_pin_strategy_controls.dart';
import 'strategies/memorable_strategy_controls.dart';
import 'strategies/pronounceable_strategy_controls.dart';
import 'strategies/random_strategy_controls.dart';

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
      PassphrasePasswordStrategy() => MemorableStrategyControls(
          length: length,
          onLengthChanged: onLengthChanged,
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
