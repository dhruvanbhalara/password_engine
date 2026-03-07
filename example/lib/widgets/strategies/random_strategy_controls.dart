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
                min: state.sliderMinLength,
                max: state.sliderMaxLength,
                divisions:
                    (state.sliderMaxLength - state.sliderMinLength).round() > 0
                        ? (state.sliderMaxLength - state.sliderMinLength)
                            .round()
                        : 1,
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
            StrategyFilterChip(
              label: 'Uppercase',
              selected: state.useUpperCase,
              type: CharacterType.upper,
              key: const Key('checkbox_uppercase'),
              state: state,
            ),
            StrategyFilterChip(
              label: 'Lowercase',
              selected: state.useLowerCase,
              type: CharacterType.lower,
              key: const Key('checkbox_lowercase'),
              state: state,
            ),
            StrategyFilterChip(
              label: 'Numbers',
              selected: state.useNumbers,
              type: CharacterType.numbers,
              key: const Key('checkbox_numbers'),
              state: state,
            ),
            StrategyFilterChip(
              label: 'Symbols',
              selected: state.useSpecialChars,
              type: CharacterType.special,
              key: const Key('checkbox_special_chars'),
              state: state,
            ),
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
}

class StrategyFilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final CharacterType type;
  final GeneratorState state;

  const StrategyFilterChip({
    super.key,
    required this.label,
    required this.selected,
    required this.type,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (val) => state.setUseCase(val, type),
      checkmarkColor: Theme.of(context).colorScheme.onPrimary,
      selectedColor: Theme.of(context).colorScheme.primary,
    );
  }
}
