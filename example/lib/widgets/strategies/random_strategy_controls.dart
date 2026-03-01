import 'package:flutter/material.dart';

import '../../state/generator_state.dart';

class RandomStrategyControls extends StatelessWidget {
  final GeneratorState state;

  const RandomStrategyControls({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Length: ${state.length.round()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                key: const Key('random_length_slider'),
                value: state.length,
                min: 16,
                max: 128,
                divisions: 112,
                label: state.length.round().toString(),
                onChanged: state.setLength,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            _buildFilterChip(context, 'Uppercase', state.useUpperCase,
                CharacterType.upper, const Key('checkbox_uppercase')),
            _buildFilterChip(context, 'Lowercase', state.useLowerCase,
                CharacterType.lower, const Key('checkbox_lowercase')),
            _buildFilterChip(context, 'Numbers', state.useNumbers,
                CharacterType.numbers, const Key('checkbox_numbers')),
            _buildFilterChip(context, 'Symbols', state.useSpecialChars,
                CharacterType.special, const Key('checkbox_special_chars')),
          ],
        ),
        const SizedBox(height: 16),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: const Text('Exclude Ambiguous Characters'),
          subtitle: const Text('e.g. i, l, 1, L, o, 0, O'),
          value: state.excludeAmbiguousChars,
          onChanged: state.setExcludeAmbiguousChars,
        ),
      ],
    );
  }

  Widget _buildFilterChip(BuildContext context, String label, bool selected,
      CharacterType type, Key key) {
    return FilterChip(
      key: key,
      label: Text(label),
      selected: selected,
      onSelected: (val) => state.setUseCase(val, type),
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      selectedColor: Theme.of(context).colorScheme.primary,
    );
  }
}
