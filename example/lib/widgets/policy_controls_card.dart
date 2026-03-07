import 'dart:ui';

import 'package:flutter/material.dart';

import '../state/generator_state.dart';

class PolicyControlsCard extends StatelessWidget {
  final GeneratorState state;

  const PolicyControlsCard({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
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
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    title: Text(
                      'Enforce Password Policy',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    subtitle:
                        const Text('Ensure passwords meet complexity rules'),
                    value: state.usePolicy,
                    onChanged: state.togglePolicyEnabled,
                  ),
                  if (state.usePolicy) ...[
                    const Divider(height: 1),
                    SwitchListTile(
                      title: const Text('Use strict CustomCorporatePolicy'),
                      subtitle: const Text('Overrides manual policy rules'),
                      value: state.useCorporatePolicy,
                      onChanged: state.toggleCorporatePolicy,
                    ),
                    if (!state.useCorporatePolicy) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 16),
                            Text(
                              'Minimum Length: ${state.policyMinLength.round()}',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            Slider(
                              value: state.policyMinLength,
                              min: 8,
                              max: 64,
                              divisions: 56,
                              label: state.policyMinLength.round().toString(),
                              onChanged: state.setPolicyMinLength,
                            ),
                            SwitchListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Enforce Maximum Length'),
                              value: state.usePolicyMaxLength,
                              onChanged: state.togglePolicyMaxLength,
                            ),
                            if (state.usePolicyMaxLength) ...[
                              Text(
                                'Maximum Length: ${state.policyMaxLength.round()}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Slider(
                                value: state.policyMaxLength,
                                min: state.policyMinLength,
                                max: 128,
                                divisions:
                                    (128 - state.policyMinLength).round(),
                                label: state.policyMaxLength.round().toString(),
                                onChanged: state.setPolicyMaxLength,
                              ),
                            ],
                            const SizedBox(height: 8),
                          ],
                        ),
                      ),
                      PolicyRequirementTile(
                        title: 'Require Uppercase',
                        value: state.policyRequireUppercase,
                        type: CharacterType.upper,
                        state: state,
                      ),
                      PolicyRequirementTile(
                        title: 'Require Lowercase',
                        value: state.policyRequireLowercase,
                        type: CharacterType.lower,
                        state: state,
                      ),
                      PolicyRequirementTile(
                        title: 'Require Numbers',
                        value: state.policyRequireNumber,
                        type: CharacterType.numbers,
                        state: state,
                      ),
                      PolicyRequirementTile(
                        title: 'Require Special Characters',
                        value: state.policyRequireSpecial,
                        type: CharacterType.special,
                        state: state,
                      ),
                      PolicyRequirementTile(
                        title: 'Allow Spaces',
                        value: state.policyAllowSpaces,
                        type: CharacterType.spaces,
                        state: state,
                      ),
                    ],
                  ],
                  const Divider(height: 1),
                  SwitchListTile(
                    title: const Text('Enable Password Blocklist'),
                    subtitle:
                        const Text('Rejects common passwords like "123456"'),
                    value: state.useBlocklist,
                    onChanged: state.toggleBlocklist,
                    activeTrackColor: Theme.of(context)
                        .colorScheme
                        .error
                        .withValues(alpha: 0.5),
                    activeThumbColor: Theme.of(context).colorScheme.error,
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PolicyRequirementTile extends StatelessWidget {
  final String title;
  final bool value;
  final CharacterType type;
  final GeneratorState state;

  const PolicyRequirementTile({
    super.key,
    required this.title,
    required this.value,
    required this.type,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(title),
      value: value,
      onChanged: (val) => state.togglePolicyRequirement(val, type),
    );
  }
}
