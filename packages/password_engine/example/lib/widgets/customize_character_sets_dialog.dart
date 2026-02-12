import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

class CustomizeCharacterSetsDialog extends StatefulWidget {
  final VoidCallback onSave;

  const CustomizeCharacterSetsDialog({
    super.key,
    required this.onSave,
  });

  @override
  State<CustomizeCharacterSetsDialog> createState() =>
      _CustomizeCharacterSetsDialogState();
}

class _CustomizeCharacterSetsDialogState
    extends State<CustomizeCharacterSetsDialog> {
  late final TextEditingController _upperCaseController;
  late final TextEditingController _lowerCaseController;
  late final TextEditingController _numbersController;
  late final TextEditingController _specialCharsController;

  @override
  void initState() {
    super.initState();
    _upperCaseController = TextEditingController(
      text: PasswordConstants.upperCaseLetters,
    );
    _lowerCaseController = TextEditingController(
      text: PasswordConstants.lowerCaseLetters,
    );
    _numbersController = TextEditingController(
      text: PasswordConstants.numbers,
    );
    _specialCharsController = TextEditingController(
      text: PasswordConstants.specialCharacters,
    );
  }

  @override
  void dispose() {
    _upperCaseController.dispose();
    _lowerCaseController.dispose();
    _numbersController.dispose();
    _specialCharsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Customize Character Sets'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _upperCaseController,
              decoration: const InputDecoration(
                labelText: 'Uppercase Letters',
                helperText: 'Default: A-Z',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lowerCaseController,
              decoration: const InputDecoration(
                labelText: 'Lowercase Letters',
                helperText: 'Default: a-z',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numbersController,
              decoration: const InputDecoration(
                labelText: 'Numbers',
                helperText: 'Default: 0-9',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _specialCharsController,
              decoration: const InputDecoration(
                labelText: 'Special Characters',
                helperText: 'Default: !@#\$%^&*()_+-=[]{}|;:,.<>?',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            PasswordConstants.resetToDefaults();
            setState(() {
              _upperCaseController.text = PasswordConstants.upperCaseLetters;
              _lowerCaseController.text = PasswordConstants.lowerCaseLetters;
              _numbersController.text = PasswordConstants.numbers;
              _specialCharsController.text =
                  PasswordConstants.specialCharacters;
            });
            widget.onSave();
            Navigator.of(context).pop();
          },
          child: const Text('Reset to Defaults'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: () {
            PasswordConstants.customize(
              upperCase: _upperCaseController.text,
              lowerCase: _lowerCaseController.text,
              numbersParam: _numbersController.text,
              special: _specialCharsController.text,
            );
            widget.onSave();
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
