import 'package:flutter/material.dart';
import 'package:password_engine/password_engine.dart';

class CustomizeCharacterSetsDialog extends StatefulWidget {
  final CharacterSetProfile initialProfile;
  final ValueChanged<CharacterSetProfile> onSave;

  const CustomizeCharacterSetsDialog({
    super.key,
    required this.initialProfile,
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
  late final TextEditingController _upperCaseNonAmbiguousController;
  late final TextEditingController _lowerCaseNonAmbiguousController;
  late final TextEditingController _numbersNonAmbiguousController;
  late final TextEditingController _specialCharsNonAmbiguousController;

  @override
  void initState() {
    super.initState();
    _upperCaseController = TextEditingController(
      text: widget.initialProfile.upperCaseLetters,
    );
    _lowerCaseController = TextEditingController(
      text: widget.initialProfile.lowerCaseLetters,
    );
    _numbersController = TextEditingController(
      text: widget.initialProfile.numbers,
    );
    _specialCharsController = TextEditingController(
      text: widget.initialProfile.specialCharacters,
    );
    _upperCaseNonAmbiguousController = TextEditingController(
      text: widget.initialProfile.upperCaseLettersNonAmbiguous,
    );
    _lowerCaseNonAmbiguousController = TextEditingController(
      text: widget.initialProfile.lowerCaseLettersNonAmbiguous,
    );
    _numbersNonAmbiguousController = TextEditingController(
      text: widget.initialProfile.numbersNonAmbiguous,
    );
    _specialCharsNonAmbiguousController = TextEditingController(
      text: widget.initialProfile.specialCharactersNonAmbiguous,
    );
  }

  @override
  void dispose() {
    _upperCaseController.dispose();
    _lowerCaseController.dispose();
    _numbersController.dispose();
    _specialCharsController.dispose();
    _upperCaseNonAmbiguousController.dispose();
    _lowerCaseNonAmbiguousController.dispose();
    _numbersNonAmbiguousController.dispose();
    _specialCharsNonAmbiguousController.dispose();
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
            const SizedBox(height: 16),
            Text(
              'Non-Ambiguous Sets',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _upperCaseNonAmbiguousController,
              decoration: const InputDecoration(
                labelText: 'Uppercase (Non-Ambiguous)',
                helperText: 'Default: A, B, C (no I/O)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _lowerCaseNonAmbiguousController,
              decoration: const InputDecoration(
                labelText: 'Lowercase (Non-Ambiguous)',
                helperText: 'Default: a, b, c (no l/o)',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _numbersNonAmbiguousController,
              decoration: const InputDecoration(
                labelText: 'Numbers (Non-Ambiguous)',
                helperText: 'Default: 2-9',
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _specialCharsNonAmbiguousController,
              decoration: const InputDecoration(
                labelText: 'Special (Non-Ambiguous)',
                helperText: 'Default: !@#\$%^&*()_+-=[]:|;,.<>?',
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            const profile = CharacterSetProfile.defaultProfile;
            setState(() {
              _upperCaseController.text = profile.upperCaseLetters;
              _lowerCaseController.text = profile.lowerCaseLetters;
              _numbersController.text = profile.numbers;
              _specialCharsController.text = profile.specialCharacters;
              _upperCaseNonAmbiguousController.text =
                  profile.upperCaseLettersNonAmbiguous;
              _lowerCaseNonAmbiguousController.text =
                  profile.lowerCaseLettersNonAmbiguous;
              _numbersNonAmbiguousController.text = profile.numbersNonAmbiguous;
              _specialCharsNonAmbiguousController.text =
                  profile.specialCharactersNonAmbiguous;
            });
            widget.onSave(profile);
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
            final profile = CharacterSetProfile(
              upperCaseLetters: _upperCaseController.text,
              lowerCaseLetters: _lowerCaseController.text,
              numbers: _numbersController.text,
              specialCharacters: _specialCharsController.text,
              upperCaseLettersNonAmbiguous:
                  _upperCaseNonAmbiguousController.text,
              lowerCaseLettersNonAmbiguous:
                  _lowerCaseNonAmbiguousController.text,
              numbersNonAmbiguous: _numbersNonAmbiguousController.text,
              specialCharactersNonAmbiguous:
                  _specialCharsNonAmbiguousController.text,
            );
            widget.onSave(profile);
            Navigator.of(context).pop();
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
