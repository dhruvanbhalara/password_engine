import 'package:flutter/material.dart';

import '../state/generator_state.dart';
import '../strategies/app_strategy_config.dart';

class PasswordOptions extends StatelessWidget {
  final GeneratorState state;

  const PasswordOptions({
    super.key,
    required this.state,
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
              child: DropdownButton<AppStrategyConfig>(
                key: const Key('strategy_dropdown'),
                value: state.selectedStrategyConfig,
                isDense: true,
                items: state.strategies.map((config) {
                  return DropdownMenuItem<AppStrategyConfig>(
                    value: config,
                    child: Text(config.name),
                  );
                }).toList(),
                onChanged: (config) {
                  if (config != null) {
                    state.setStrategyConfig(config);
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
