import 'package:flutter/material.dart';

import '../../state/generator_state.dart';

class CustomPinStrategyControls extends StatelessWidget {
  final GeneratorState state;
  final TextEditingController prefixController;

  const CustomPinStrategyControls({
    super.key,
    required this.state,
    required this.prefixController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: prefixController,
          decoration: const InputDecoration(
            labelText: 'PIN Prefix',
            hintText: 'e.g., USER',
            border: OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                'Numeric Length: ${state.length.round()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Slider(
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
      ],
    );
  }
}
