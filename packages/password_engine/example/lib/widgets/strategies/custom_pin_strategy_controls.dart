import 'package:flutter/material.dart';

class CustomPinStrategyControls extends StatelessWidget {
  final double length;
  final TextEditingController prefixController;
  final ValueChanged<double> onLengthChanged;
  final ValueChanged<String> onPrefixChanged;

  const CustomPinStrategyControls({
    super.key,
    required this.length,
    required this.prefixController,
    required this.onLengthChanged,
    required this.onPrefixChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: prefixController,
          decoration: const InputDecoration(
            labelText: 'Prefix',
            helperText: 'e.g. USER, PIN, KEY',
          ),
          onChanged: onPrefixChanged,
        ),
        const SizedBox(height: 16),
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
                value: length,
                min: 4,
                max: 12,
                divisions: 8,
                label: length.round().toString(),
                onChanged: onLengthChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
