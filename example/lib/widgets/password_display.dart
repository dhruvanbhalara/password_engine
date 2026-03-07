import 'dart:ui';

import 'package:flutter/material.dart';

import '../state/generator_state.dart';
import 'password_strength_indicator.dart';

class PasswordDisplay extends StatelessWidget {
  final GeneratorState state;
  final Animation<double> fadeAnimation;

  const PasswordDisplay({
    super.key,
    required this.state,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              final password = state.isPasswordVisible
                  ? state.password.value
                  : state.password.masked;
              final strength = state.strength;
              final feedback = state.feedback;
              final estimatorLabel =
                  state.useZxcvbn ? 'zxcvbn (direct)' : 'Entropy (default)';
              final isVisible = state.isPasswordVisible;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Generated Password:',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  FadeTransition(
                    opacity: fadeAnimation,
                    child: Row(
                      children: [
                        Expanded(
                          child: SelectableText(
                            password,
                            key: const Key('password_display_text'),
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: state.togglePasswordVisibility,
                          tooltip:
                              isVisible ? 'Hide password' : 'Show password',
                        ),
                      ],
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
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
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
                              .map(
                                  (suggestion) => Chip(label: Text(suggestion)))
                              .toList(),
                        ),
                      ),
                    if (feedback.score != null ||
                        feedback.estimatedEntropy != null)
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
              );
            },
          ),
        ),
      ),
    );
  }
}
