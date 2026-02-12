# Password Engine

A secure, modular, and extensible password generation library for Dart and Flutter.

## Features

- **Cryptographically Secure**: Uses `Random.secure()` for strong random number generation.
- **Modular Design**: Built with interfaces (`IPasswordGenerationStrategy`, `IPasswordStrengthEstimator`) for maximum flexibility.
- **Customizable**:
  - Configure length, character sets, and exclusion of ambiguous characters.
  - Inject custom generation strategies.
  - Inject custom strength estimators.
  - Inject custom validators, feedback providers, and normalizers.
- **Extensible**: Easily add new strategies (e.g., passphrases, PINs) without modifying the core library.
- **Validation**: Built-in validation with config-aware and policy-aware rules.
- **Passphrases**: Built-in passphrase strategy using wordlists.
- **Blocklist Support**: Rejects known weak passwords via blocklist validation.
- **Feedback**: Optional warnings and suggestions via `estimateFeedback()`.

## Getting Started

Add the package to your `pubspec.yaml`:

```yaml
dependencies:
  password_engine: ^1.0.0
```

## Usage

### Basic Usage

```dart
import 'package:password_engine/password_engine.dart';

void main() {
  // Create a generator with default settings (RandomPasswordStrategy)
  final generator = PasswordGenerator();

  // Generate a password
  String password = generator.generatePassword();
  print(password); // e.g., "aB3$kL9@pQ2!"
}
```

### Custom Configuration

```dart
final generator = PasswordGenerator();

generator.updateConfig(
  PasswordGeneratorConfig(
    length: 20,
    useUpperCase: true,
    useLowerCase: true,
    useNumbers: true,
    useSpecialChars: true,
    excludeAmbiguousChars: true, // e.g., excludes 'I', 'l', '1', 'O', '0'
  ),
);

String password = generator.generatePassword();
```

### Using Custom Strategies

The library supports custom generation strategies. You can implement `IPasswordGenerationStrategy` to create your own.

**Note**: The `MemorablePasswordStrategy` and `PronounceablePasswordStrategy` have been moved to the `example` app to serve as learning resources. You can copy them into your project if needed.

```dart
// Example of using a custom strategy (e.g., from the example app)
final memorableStrategy = MemorablePasswordStrategy(separator: '-');
final generator = PasswordGenerator(generationStrategy: memorableStrategy);

generator.updateConfig(PasswordGeneratorConfig(length: 4)); // 4 words
String password = generator.generatePassword(); // e.g., "correct-horse-battery-staple"
```

### Passphrase Strategy

```dart
final strategy = PassphrasePasswordStrategy(
  wordlist: ['alpha', 'beta', 'gamma', 'delta'],
  separator: '-',
);
final generator = PasswordGenerator(generationStrategy: strategy);

generator.updateConfig(const PasswordGeneratorConfig(length: 4)); // 4 words
final passphrase = generator.generatePassword();
```

### Password Strength Estimation

The library includes a default entropy-based strength estimator, but you can inject your own (e.g., one based on zxcvbn).

```dart
class MyCustomStrengthEstimator implements IPasswordStrengthEstimator {
  @override
  PasswordStrength estimatePasswordStrength(String password) {
    // Your custom logic here
    return PasswordStrength.strong;
  }
}

final generator = PasswordGenerator(
  strengthEstimator: MyCustomStrengthEstimator(),
);

PasswordStrength strength = generator.estimateStrength("myPassword123");
```

### Password Feedback

```dart
final generator = PasswordGenerator();
final feedback = generator.estimateFeedback("password");

print(feedback.strength);
print(feedback.warning);
print(feedback.suggestions);
```

### Password Policies

```dart
final generator = PasswordGenerator();

generator.updateConfig(
  const PasswordGeneratorConfig(
    policy: PasswordPolicy(
      minLength: 16,
      requireNumber: true,
      requireSpecial: true,
      allowSpaces: true,
    ),
  ),
);
```

### Blocklist Validation

```dart
final validator = BlocklistPasswordValidator(
  blockedPasswords: {'password', '123456'},
  baseValidator: ConfigAwarePasswordValidator(),
);

final generator = PasswordGenerator(validator: validator);
```

### Password Normalizer

```dart
class TrimPasswordNormalizer implements IPasswordNormalizer {
  @override
  String normalize(String password) => password.trim();
}

final generator = PasswordGenerator(
  normalizer: TrimPasswordNormalizer(),
);
```

## Configuration Options

| Parameter               | Type | Default | Description                                      |
| ----------------------- | ---- | ------- | ------------------------------------------------ |
| `length`                | int  | 12      | Password length (or word count for some strategies) |
| `useUpperCase`          | bool | true    | Include uppercase letters                        |
| `useLowerCase`          | bool | true    | Include lowercase letters                        |
| `useNumbers`            | bool | true    | Include numbers                                  |
| `useSpecialChars`       | bool | true    | Include special characters                       |
| `excludeAmbiguousChars` | bool | false   | Exclude characters like 'I', 'l', '1', 'O', '0'  |
| `characterSetProfile`   | CharacterSetProfile | defaultProfile | Custom character sets for generation             |
| `maxGenerationAttempts` | int  | 1000    | Max retry count for `refreshPassword()`          |
| `policy`                | PasswordPolicy? | null | Optional policy rules for validation           |
| `extra`                 | Map  | {}      | Custom parameters for user-defined strategies    |

## Security Notes

- **CSPRNG**: Uses `Random.secure()` for all random number generation.
- **Entropy**: The default strength estimator uses Shannon entropy to calculate password strength.
- **Validation**: Strategies include a `validate` method to ensure configuration parameters are safe before generation.

## Additional Information

- **Source Code**: [GitHub Repository](https://github.com/dhruvanbhalara/password_engine)
- **Issues**: [Issue Tracker](https://github.com/dhruvanbhalara/password_engine/issues)
- **Library Flow**: [Library Flow](docs/library-flow.md)
- **Examples**: Check the `example` folder for a full Flutter app demonstrating custom strategies and UI integration.

## License

MIT License - see the [LICENSE](LICENSE) file for details.
