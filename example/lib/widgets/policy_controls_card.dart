import 'package:flutter/material.dart';

class PolicyControlsCard extends StatelessWidget {
  const PolicyControlsCard({
    super.key,
    required this.policyEnabled,
    required this.minLength,
    required this.useMaxLength,
    required this.maxLength,
    required this.requireUppercase,
    required this.requireLowercase,
    required this.requireNumber,
    required this.requireSpecial,
    required this.allowSpaces,
    required this.useBlocklist,
    required this.onPolicyEnabledChanged,
    required this.onMinLengthChanged,
    required this.onUseMaxLengthChanged,
    required this.onMaxLengthChanged,
    required this.onRequireUppercaseChanged,
    required this.onRequireLowercaseChanged,
    required this.onRequireNumberChanged,
    required this.onRequireSpecialChanged,
    required this.onAllowSpacesChanged,
    required this.onUseBlocklistChanged,
  });

  final bool policyEnabled;
  final double minLength;
  final bool useMaxLength;
  final double maxLength;
  final bool requireUppercase;
  final bool requireLowercase;
  final bool requireNumber;
  final bool requireSpecial;
  final bool allowSpaces;
  final bool useBlocklist;
  final ValueChanged<bool> onPolicyEnabledChanged;
  final ValueChanged<double> onMinLengthChanged;
  final ValueChanged<bool> onUseMaxLengthChanged;
  final ValueChanged<double> onMaxLengthChanged;
  final ValueChanged<bool?> onRequireUppercaseChanged;
  final ValueChanged<bool?> onRequireLowercaseChanged;
  final ValueChanged<bool?> onRequireNumberChanged;
  final ValueChanged<bool?> onRequireSpecialChanged;
  final ValueChanged<bool> onAllowSpacesChanged;
  final ValueChanged<bool> onUseBlocklistChanged;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Policy & Validation',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Policy rules can override generator toggles when enabled.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(
              'Length rules apply to the strategy length setting.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            SwitchListTile(
              title: const Text('Enable policy rules'),
              value: policyEnabled,
              onChanged: onPolicyEnabledChanged,
            ),
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Minimum length: ${minLength.round()}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Slider(
                    value: minLength,
                    min: 6,
                    max: 64,
                    divisions: 58,
                    label: minLength.round().toString(),
                    onChanged: policyEnabled ? onMinLengthChanged : null,
                  ),
                ),
              ],
            ),
            SwitchListTile(
              title: const Text('Use maximum length'),
              value: useMaxLength,
              onChanged: policyEnabled ? onUseMaxLengthChanged : null,
            ),
            if (useMaxLength)
              minLength >= 64
                  ? Text(
                      'Maximum length locked to 64.',
                      style: Theme.of(context).textTheme.bodySmall,
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Maximum length: ${maxLength.round()}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Slider(
                            value: maxLength,
                            min: minLength,
                            max: 64,
                            divisions:
                                (64 - minLength).round().clamp(1, 64).toInt(),
                            label: maxLength.round().toString(),
                            onChanged:
                                policyEnabled ? onMaxLengthChanged : null,
                          ),
                        ),
                      ],
                    ),
            const SizedBox(height: 8),
            Text(
              'Required character types',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            CheckboxListTile(
              title: const Text('Require uppercase'),
              value: requireUppercase,
              onChanged: policyEnabled ? onRequireUppercaseChanged : null,
            ),
            CheckboxListTile(
              title: const Text('Require lowercase'),
              value: requireLowercase,
              onChanged: policyEnabled ? onRequireLowercaseChanged : null,
            ),
            CheckboxListTile(
              title: const Text('Require number'),
              value: requireNumber,
              onChanged: policyEnabled ? onRequireNumberChanged : null,
            ),
            CheckboxListTile(
              title: const Text('Require special character'),
              value: requireSpecial,
              onChanged: policyEnabled ? onRequireSpecialChanged : null,
            ),
            SwitchListTile(
              title: const Text('Allow spaces for special requirement'),
              value: allowSpaces,
              onChanged: policyEnabled ? onAllowSpacesChanged : null,
            ),
            const Divider(height: 24),
            SwitchListTile(
              title: const Text('Use common-password blocklist'),
              subtitle: const Text('Applied when generating strong passwords.'),
              value: useBlocklist,
              onChanged: onUseBlocklistChanged,
            ),
            if (useBlocklist)
              Text(
                'Blocked: password, 123456, qwerty, letmein, password1, admin',
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}
