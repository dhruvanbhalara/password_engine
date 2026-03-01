import 'package:flutter/material.dart';

class StrengthEstimatorCard extends StatelessWidget {
  const StrengthEstimatorCard({
    super.key,
    required this.useZxcvbn,
    required this.onChanged,
  });

  final bool useZxcvbn;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final estimatorLabel = useZxcvbn ? 'zxcvbn (direct)' : 'Entropy (default)';
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Strength Estimator',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Active: $estimatorLabel'),
            SwitchListTile(
              key: const Key('toggle_zxcvbn'),
              title: const Text('Use zxcvbn directly'),
              subtitle:
                  const Text('More realistic scoring from the zxcvbn package.'),
              value: useZxcvbn,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
