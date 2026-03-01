import 'package:flutter/material.dart';

class AnimatedSection extends StatelessWidget {
  const AnimatedSection({super.key, required this.index, required this.child});

  final int index;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final duration = Duration(milliseconds: 450 + (index * 120));
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: duration,
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        final translate = 18 * (1 - value);
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, translate),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
