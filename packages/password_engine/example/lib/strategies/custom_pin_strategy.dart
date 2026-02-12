import 'dart:math';

import 'package:password_engine/password_engine.dart';

/// A custom strategy that generates a PIN-like password with a prefix.
///
/// This demonstrates how to use the `extra` field in [PasswordGeneratorConfig]
/// to pass custom parameters to a strategy.
class CustomPinStrategy implements IPasswordGenerationStrategy {
  @override
  String generate(PasswordGeneratorConfig config) {
    validate(config);

    final prefix = config.extra['prefix'] as String? ?? 'USER';
    final random = Random.secure();
    final buffer = StringBuffer();

    // Add prefix
    buffer.write('$prefix-');

    // Generate numeric part
    for (var i = 0; i < config.length; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  @override
  void validate(PasswordGeneratorConfig config) {
    if (config.length < 4) {
      throw ArgumentError('PIN length must be at least 4');
    }
  }
}
