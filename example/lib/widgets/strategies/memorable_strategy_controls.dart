import 'package:flutter/material.dart';

import '../../state/generator_state.dart';

class MemorableStrategyControls extends StatelessWidget {
  final GeneratorState state;

  const MemorableStrategyControls({
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
                'Word Count: ${state.length.round()}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Expanded(
              flex: 2,
              child: Slider(
                key: const Key('memorable_length_slider'),
                value: state.length,
                min: 4,
                max: 8,
                divisions: 4,
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
