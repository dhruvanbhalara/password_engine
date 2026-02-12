import 'package:flutter/material.dart';

class PronounceableStrategyControls extends StatelessWidget {
  final double length;
  final ValueChanged<double> onLengthChanged;

  const PronounceableStrategyControls({
    super.key,
    required this.length,
    required this.onLengthChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
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
            value: length,
            min: 8,
            max: 20,
            divisions: 12,
            label: length.round().toString(),
            onChanged: onLengthChanged,
          ),
        ),
      ],
    );
  }
}
