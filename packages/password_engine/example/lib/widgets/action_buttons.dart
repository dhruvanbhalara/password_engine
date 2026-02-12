import 'package:flutter/material.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback onCopy;
  final VoidCallback onGenerate;

  const ActionButtons({
    super.key,
    required this.onCopy,
    required this.onGenerate,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: onCopy,
          icon: const Icon(Icons.copy),
          label: const Text('Copy Password'),
          key: const Key('copy_password_button'),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          onPressed: onGenerate,
          icon: const Icon(Icons.refresh),
          label: const Text('Generate New Password'),
          key: const Key('generate_password_button'),
        ),
      ],
    );
  }
}
