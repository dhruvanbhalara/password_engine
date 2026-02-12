import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import 'password_strength_indicator.dart';

class PasswordDisplay extends StatelessWidget {
  final String password;
  final PasswordStrength strength;
  final PasswordFeedback feedback;
  final Animation<double> fadeAnimation;
  final String estimatorLabel;

  const PasswordDisplay({
    super.key,
    required this.password,
    required this.strength,
    required this.feedback,
    required this.fadeAnimation,
    required this.estimatorLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.surface,
            Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Generated Password:',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          FadeTransition(
            opacity: fadeAnimation,
            child: SelectableText(
              password,
              key: const Key('password_display_text'),
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
          const SizedBox(height: 16),
          PasswordStrengthIndicator(strength: strength),
          const SizedBox(height: 10),
          Text(
            'Estimator: $estimatorLabel',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          if (feedback.warning != null ||
              feedback.suggestions.isNotEmpty ||
              feedback.score != null ||
              feedback.estimatedEntropy != null) ...[
            const SizedBox(height: 16),
            Text(
              'Feedback',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (feedback.warning != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  feedback.warning!,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            if (feedback.suggestions.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: feedback.suggestions
                      .map((suggestion) => Chip(label: Text(suggestion)))
                      .toList(),
                ),
              ),
            if (feedback.score != null || feedback.estimatedEntropy != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Wrap(
                  spacing: 16,
                  children: [
                    if (feedback.score != null)
                      Text('Score: ${feedback.score}/4'),
                    if (feedback.estimatedEntropy != null)
                      Text(
                        'Entropy: ${feedback.estimatedEntropy!.toStringAsFixed(1)}',
                      ),
                  ],
                ),
              ),
          ],
        ],
      ),
    );
  }
}
