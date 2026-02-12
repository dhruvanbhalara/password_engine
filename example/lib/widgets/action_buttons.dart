import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onGenerate;
  final VoidCallback onGenerateStrong;

  const ActionButtons({
    super.key,
    required this.onCopy,
    required this.onGenerate,
    required this.onGenerateStrong,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        FilledButton.icon(
          onPressed: onGenerate,
          icon: const Icon(Icons.refresh),
          label: const Text('Generate New Password'),
          key: const Key('generate_password_button'),
        ),
        FilledButton.tonalIcon(
          onPressed: onGenerateStrong,
          icon: const Icon(Icons.security),
          label: const Text('Generate Strong Password'),
          key: const Key('generate_strong_password_button'),
        ),
        OutlinedButton.icon(
          onPressed: onCopy,
          icon: const Icon(Icons.copy),
          label: const Text('Copy Password'),
          key: const Key('copy_password_button'),
        ),
      ],
    );
  }
}
