import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

class PasswordStrengthIndicator extends StatelessWidget {
  final PasswordStrength strength;

  const PasswordStrengthIndicator({super.key, required this.strength});

  static const Map<PasswordStrength, Map<String, dynamic>> _strengthMap = {
    PasswordStrength.veryWeak: {
      'text': 'Very Weak',
      'color': Colors.red,
      'widthFactor': 0.2,
    },
    PasswordStrength.weak: {
      'text': 'Weak',
      'color': Colors.orange,
      'widthFactor': 0.4,
    },
    PasswordStrength.medium: {
      'text': 'Medium',
      'color': Colors.yellow,
      'widthFactor': 0.6,
    },
    PasswordStrength.strong: {
      'text': 'Strong',
      'color': Colors.lightGreen,
      'widthFactor': 0.8,
    },
    PasswordStrength.veryStrong: {
      'text': 'Very Strong',
      'color': Colors.green,
      'widthFactor': 1.0,
    },
  };

  @override
  Widget build(BuildContext context) {
    // If the map doesn't contain the key, fallback to a safe default
    final strengthData =
        _strengthMap[strength] ?? _strengthMap[PasswordStrength.veryWeak]!;

    final color = Theme.of(context).brightness == Brightness.dark
        ? strengthData['color'] as Color
        : Color.lerp(strengthData['color'] as Color, Colors.black, 0.2)!;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: strengthData['widthFactor'] as double,
                  child: Container(
                    height: 10,
                    color: color,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          strengthData['text'] as String,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
