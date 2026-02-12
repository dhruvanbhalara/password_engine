import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

import 'password_strength_indicator.dart';

class PasswordDisplay extends StatelessWidget {
  final String password;
  final PasswordStrength strength;
  final Animation<double> fadeAnimation;

  const PasswordDisplay({
    super.key,
    required this.password,
    required this.strength,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Generated Password:',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            FadeTransition(
              opacity: fadeAnimation,
              child: SelectableText(
                password,
                key: const Key('password_display_text'),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 16),
            PasswordStrengthIndicator(strength: strength),
          ],
        ),
      ),
    );
  }
}
