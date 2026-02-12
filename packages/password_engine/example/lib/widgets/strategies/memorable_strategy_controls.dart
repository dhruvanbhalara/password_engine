import 'package:flutter/material.dart';

class MemorableStrategyControls extends StatelessWidget {
  final double length;
  final ValueChanged<double> onLengthChanged;

  const MemorableStrategyControls({
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
            'Number of Words: ${length.round()}',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        Expanded(
          flex: 2,
          child: Slider(
            value: length,
            min: 4,
            max: 8,
            divisions: 4,
            label: length.round().toString(),
            onChanged: onLengthChanged,
          ),
        ),
      ],
    );
  }
}
