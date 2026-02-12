# password_engine_zxcvbn

Optional zxcvbn-based strength estimator for the `password_engine` package.

## Usage
```dart
import 'package:password_engine/password_engine.dart';
import 'package:password_engine_zxcvbn/password_engine_zxcvbn.dart';

final generator = PasswordGenerator(
  strengthEstimator: ZxcvbnStrengthEstimator(),
);
```
