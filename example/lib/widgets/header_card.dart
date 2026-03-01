import 'dart:ui';

import 'package:flutter/material.dart';

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    super.key,
    required this.onCustomize,
    required this.currentThemeMode,
    required this.onThemeToggle,
  });

  final VoidCallback onCustomize;
  final ThemeMode currentThemeMode;
  final VoidCallback onThemeToggle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.7),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Password Studio',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Craft strong passwords with style, strategy, and real-world scoring.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      currentThemeMode == ThemeMode.light
                          ? Icons.dark_mode
                          : currentThemeMode == ThemeMode.dark
                              ? Icons.brightness_auto
                              : Icons.light_mode,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: onThemeToggle,
                    tooltip: 'Toggle Theme',
                  ),
                  const SizedBox(height: 8),
                  FilledButton.tonalIcon(
                    onPressed: onCustomize,
                    icon: const Icon(Icons.tune),
                    label: const Text('Character Sets'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
