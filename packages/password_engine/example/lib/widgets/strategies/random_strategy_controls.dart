import 'package:flutter/material.dart';

class RandomStrategyControls extends StatelessWidget {
  final double length;
  final bool useUpperCase;
  final bool useLowerCase;
  final bool useNumbers;
  final bool useSpecialChars;
  final bool excludeAmbiguousChars;
  final ValueChanged<double> onLengthChanged;
  final ValueChanged<bool?> onUpperCaseChanged;
  final ValueChanged<bool?> onLowerCaseChanged;
  final ValueChanged<bool?> onNumbersChanged;
  final ValueChanged<bool?> onSpecialCharsChanged;
  final ValueChanged<bool?> onExcludeAmbiguousCharsChanged;

  const RandomStrategyControls({
    super.key,
    required this.length,
    required this.useUpperCase,
    required this.useLowerCase,
    required this.useNumbers,
    required this.useSpecialChars,
    required this.excludeAmbiguousChars,
    required this.onLengthChanged,
    required this.onUpperCaseChanged,
    required this.onLowerCaseChanged,
    required this.onNumbersChanged,
    required this.onSpecialCharsChanged,
    required this.onExcludeAmbiguousCharsChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Length: ${length.round()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                key: const Key('random_length_slider'),
                value: length,
                min: 12,
                max: 32,
                divisions: 20,
                label: length.round().toString(),
                onChanged: onLengthChanged,
              ),
            ),
          ],
        ),
        CheckboxListTile(
          key: const Key('checkbox_uppercase'),
          title: const Text('Uppercase Letters (A-Z)'),
          value: useUpperCase,
          onChanged: onUpperCaseChanged,
        ),
        CheckboxListTile(
          key: const Key('checkbox_lowercase'),
          title: const Text('Lowercase Letters (a-z)'),
          value: useLowerCase,
          onChanged: onLowerCaseChanged,
        ),
        CheckboxListTile(
          key: const Key('checkbox_numbers'),
          title: const Text('Numbers (0-9)'),
          value: useNumbers,
          onChanged: onNumbersChanged,
        ),
        CheckboxListTile(
          key: const Key('checkbox_special_chars'),
          title: const Text('Special Characters (!@#\$...)'),
          value: useSpecialChars,
          onChanged: onSpecialCharsChanged,
        ),
        CheckboxListTile(
          key: const Key('checkbox_exclude_ambiguous'),
          title: const Text('Exclude Ambiguous Characters'),
          subtitle: const Text('(e.g. I, l, 1, O, 0)'),
          value: excludeAmbiguousChars,
          onChanged: onExcludeAmbiguousCharsChanged,
        ),
      ],
    );
  }
}
