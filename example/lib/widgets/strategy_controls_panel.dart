import 'package:flutter/material.dart';

import '../state/generator_state.dart';

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
          state.selectedStrategyConfig.controlBuilder
                  ?.call(state, prefixController) ??
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
