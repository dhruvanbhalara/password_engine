import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../state/generator_state.dart';
import '../strategies/custom_pin_strategy.dart';
import '../strategies/memorable_password_strategy.dart';
import '../strategies/pronounceable_password_strategy.dart';

class PasswordOptions extends StatelessWidget {
  final GeneratorState state;

  const PasswordOptions({
    super.key,
    required this.state,
  });

  String _getStrategyName(IPasswordGenerationStrategy strategy) {
    if (strategy is RandomPasswordStrategy) {
      return 'Random';
    } else if (strategy is PassphrasePasswordStrategy) {
      return 'Passphrase';
    } else if (strategy is MemorablePasswordStrategy) {
      return 'Memorable';
    } else if (strategy is PronounceablePasswordStrategy) {
      return 'Pronounceable';
    } else if (strategy is CustomPinStrategy) {
      return 'Custom PIN';
    }
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Password Options',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          InputDecorator(
            decoration: const InputDecoration(
              labelText: 'Generation Strategy',
              border: OutlineInputBorder(),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<IPasswordGenerationStrategy>(
                key: const Key('strategy_dropdown'),
                value: state.selectedStrategy,
                isDense: true,
                items: state.strategies.map((strategy) {
                  return DropdownMenuItem<IPasswordGenerationStrategy>(
                    value: strategy,
                    child: Text(_getStrategyName(strategy)),
                  );
                }).toList(),
                onChanged: (strategy) {
                  if (strategy != null) {
                    state.setStrategy(strategy);
                  }
                },
              ),
            ),
          ),
          /* strategyControls logic has moved down to StrategyControlsPanel invoked from main.dart explicitly, so this widget only holds the dropdown */
        ],
      ),
    );
  }
}
