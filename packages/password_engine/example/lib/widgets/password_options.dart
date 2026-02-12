import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import '../strategies/custom_pin_strategy.dart';
import '../strategies/memorable_password_strategy.dart';
import '../strategies/pronounceable_password_strategy.dart';

class PasswordOptions extends StatelessWidget {
  final List<IPasswordGenerationStrategy> strategies;
  final IPasswordGenerationStrategy selectedStrategy;
  final ValueChanged<IPasswordGenerationStrategy?> onStrategyChanged;
  final Widget strategyControls;

  const PasswordOptions({
    super.key,
    required this.strategies,
    required this.selectedStrategy,
    required this.onStrategyChanged,
    required this.strategyControls,
  });

  String _getStrategyName(IPasswordGenerationStrategy strategy) {
    if (strategy is RandomPasswordStrategy) {
      return 'Random';
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
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
                  value: selectedStrategy,
                  isDense: true,
                  items: strategies.map((strategy) {
                    return DropdownMenuItem<IPasswordGenerationStrategy>(
                      value: strategy,
                      child: Text(_getStrategyName(strategy)),
                    );
                  }).toList(),
                  onChanged: onStrategyChanged,
                ),
              ),
            ),
            const SizedBox(height: 16),
            strategyControls,
          ],
        ),
      ),
    );
  }
}
