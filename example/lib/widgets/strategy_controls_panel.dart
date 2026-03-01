import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../state/generator_state.dart';
import '../strategies/custom_pin_strategy.dart';
import '../strategies/memorable_password_strategy.dart';
import '../strategies/pronounceable_password_strategy.dart';
import 'strategies/custom_pin_strategy_controls.dart';
import 'strategies/memorable_strategy_controls.dart';
import 'strategies/pronounceable_strategy_controls.dart';
import 'strategies/random_strategy_controls.dart';

class StrategyControlsPanel extends StatelessWidget {
  final GeneratorState state;
  final TextEditingController prefixController;

  const StrategyControlsPanel({
    super.key,
    required this.state,
    required this.prefixController,
  });

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
        children: [
          Text(
            'Strategy Settings',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          if (state.selectedStrategy is RandomPasswordStrategy)
            RandomStrategyControls(state: state)
          else if (state.selectedStrategy is PassphrasePasswordStrategy)
            MemorableStrategyControls(state: state)
          else if (state.selectedStrategy is MemorablePasswordStrategy)
            MemorableStrategyControls(state: state)
          else if (state.selectedStrategy is PronounceablePasswordStrategy)
            PronounceableStrategyControls(state: state)
          else if (state.selectedStrategy is CustomPinStrategy)
            CustomPinStrategyControls(
                state: state, prefixController: prefixController)
          else
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No additional configuration required.'),
              ),
            ),
        ],
      ),
    );
  }
}
