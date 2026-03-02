// GENERATED FILE, do not edit!
// ignore_for_file: annotate_overrides, non_constant_identifier_names, prefer_single_quotes, unused_element, unused_field, sort_constructors_first
import 'package:i18n/i18n.dart' as i18n;

String get _languageCode => 'en';
String _plural(
  int count, {
  String? zero,
  String? one,
  String? two,
  String? few,
  String? many,
  String? other,
}) => i18n.plural(
  count,
  _languageCode,
  zero: zero,
  one: one,
  two: two,
  few: few,
  many: many,
  other: other,
);
String _ordinal(
  int count, {
  String? zero,
  String? one,
  String? two,
  String? few,
  String? many,
  String? other,
}) => i18n.ordinal(
  count,
  _languageCode,
  zero: zero,
  one: one,
  two: two,
  few: few,
  many: many,
  other: other,
);
String _cardinal(
  int count, {
  String? zero,
  String? one,
  String? two,
  String? few,
  String? many,
  String? other,
}) => i18n.cardinal(
  count,
  _languageCode,
  zero: zero,
  one: one,
  two: two,
  few: few,
  many: many,
  other: other,
);

class Messages {
  const Messages();
  String get locale => "en";
  String get languageCode => "en";
  FeedbackMessages get feedback => FeedbackMessages(this);
  ErrorMessages get error => ErrorMessages(this);
}

class FeedbackMessages {
  final Messages _parent;
  const FeedbackMessages(this._parent);
  WarningFeedbackMessages get warning => WarningFeedbackMessages(this);
  SuggestionFeedbackMessages get suggestion => SuggestionFeedbackMessages(this);
}

class WarningFeedbackMessages {
  final FeedbackMessages _parent;
  const WarningFeedbackMessages(this._parent);

  /// ```dart
  /// "Too weak"
  /// ```
  String get tooWeak => """Too weak""";

  /// ```dart
  /// "Weak password"
  /// ```
  String get weak => """Weak password""";

  /// ```dart
  /// "Could be stronger"
  /// ```
  String get medium => """Could be stronger""";

  /// ```dart
  /// "Does not meet policy requirements"
  /// ```
  String get policyNotMet => """Does not meet policy requirements""";

  /// ```dart
  /// "Policy requirements partially met"
  /// ```
  String get policyPartiallyMet => """Policy requirements partially met""";

  /// ```dart
  /// "Almost there"
  /// ```
  String get almostThere => """Almost there""";
}

class SuggestionFeedbackMessages {
  final FeedbackMessages _parent;
  const SuggestionFeedbackMessages(this._parent);

  /// ```dart
  /// "Use a longer password"
  /// ```
  String get useLonger => """Use a longer password""";

  /// ```dart
  /// "Add another word or phrase"
  /// ```
  String get addWordPhrase => """Add another word or phrase""";

  /// ```dart
  /// "Mix more character types"
  /// ```
  String get mixCharacterTypes => """Mix more character types""";

  /// ```dart
  /// "Add length or another word"
  /// ```
  String get addLengthOrWord => """Add length or another word""";

  /// ```dart
  /// "Avoid common patterns"
  /// ```
  String get avoidCommonPatterns => """Avoid common patterns""";

  /// ```dart
  /// "Increase length slightly"
  /// ```
  String get increaseLengthSlightly => """Increase length slightly""";

  /// ```dart
  /// "Add another word or symbol"
  /// ```
  String get addWordOrSymbol => """Add another word or symbol""";

  /// ```dart
  /// "Increase length to at least $min"
  /// ```
  String increaseLengthMin(int min) => """Increase length to at least $min""";

  /// ```dart
  /// "Add an uppercase letter"
  /// ```
  String get addUppercase => """Add an uppercase letter""";

  /// ```dart
  /// "Add a lowercase letter"
  /// ```
  String get addLowercase => """Add a lowercase letter""";

  /// ```dart
  /// "Add a number"
  /// ```
  String get addNumber => """Add a number""";

  /// ```dart
  /// "Add a special character"
  /// ```
  String get addSpecial => """Add a special character""";

  /// ```dart
  /// "Use more variety for higher security"
  /// ```
  String get useMoreVariety => """Use more variety for higher security""";
}

class ErrorMessages {
  final Messages _parent;
  const ErrorMessages(this._parent);

  /// ```dart
  /// "Unable to generate a strong password within $maxAttempts attempts."
  /// ```
  String maxAttemptsExceeded(int maxAttempts) =>
      """Unable to generate a strong password within $maxAttempts attempts.""";

  /// ```dart
  /// "maxGenerationAttempts must be greater than 0"
  /// ```
  String get maxGenerationAttemptsPositive =>
      """maxGenerationAttempts must be greater than 0""";

  /// ```dart
  /// "PasswordPolicy minLength cannot exceed maxLength"
  /// ```
  String get policyMinExceedsMax =>
      """PasswordPolicy minLength cannot exceed maxLength""";

  /// ```dart
  /// "Password length must be at least $min"
  /// ```
  String passwordLengthMin(int min) =>
      """Password length must be at least $min""";

  /// ```dart
  /// "At least one character type must be selected"
  /// ```
  String get atLeastOneCharType =>
      """At least one character type must be selected""";

  /// ```dart
  /// "Selected character sets must not be empty"
  /// ```
  String get selectedCharSetsNotEmpty =>
      """Selected character sets must not be empty""";

  /// ```dart
  /// "Wordlist must not be empty"
  /// ```
  String get wordlistEmpty => """Wordlist must not be empty""";

  /// ```dart
  /// "Wordlist must not contain empty words"
  /// ```
  String get wordlistHasEmptyWords =>
      """Wordlist must not contain empty words""";

  /// ```dart
  /// "Word count must be greater than 0"
  /// ```
  String get wordCountPositive => """Word count must be greater than 0""";

  /// ```dart
  /// "Word count exceeds wordlist size when duplicates are disabled"
  /// ```
  String get wordCountExceedsWordlist =>
      """Word count exceeds wordlist size when duplicates are disabled""";

  /// ```dart
  /// "Character pool cannot be empty"
  /// ```
  String get characterPoolEmpty => """Character pool cannot be empty""";

  /// ```dart
  /// "Length must be non-negative"
  /// ```
  String get lengthNonNegative => """Length must be non-negative""";

  /// ```dart
  /// "invalid format"
  /// ```
  String get invalidFormat => """invalid format""";

  /// ```dart
  /// "invalid length"
  /// ```
  String get invalidLength => """invalid length""";
}

Map<String, String> get messagesMap => {
  """feedback.warning.tooWeak""": """Too weak""",
  """feedback.warning.weak""": """Weak password""",
  """feedback.warning.medium""": """Could be stronger""",
  """feedback.warning.policyNotMet""": """Does not meet policy requirements""",
  """feedback.warning.policyPartiallyMet""":
      """Policy requirements partially met""",
  """feedback.warning.almostThere""": """Almost there""",
  """feedback.suggestion.useLonger""": """Use a longer password""",
  """feedback.suggestion.addWordPhrase""": """Add another word or phrase""",
  """feedback.suggestion.mixCharacterTypes""": """Mix more character types""",
  """feedback.suggestion.addLengthOrWord""": """Add length or another word""",
  """feedback.suggestion.avoidCommonPatterns""": """Avoid common patterns""",
  """feedback.suggestion.increaseLengthSlightly""":
      """Increase length slightly""",
  """feedback.suggestion.addWordOrSymbol""": """Add another word or symbol""",
  """feedback.suggestion.addUppercase""": """Add an uppercase letter""",
  """feedback.suggestion.addLowercase""": """Add a lowercase letter""",
  """feedback.suggestion.addNumber""": """Add a number""",
  """feedback.suggestion.addSpecial""": """Add a special character""",
  """feedback.suggestion.useMoreVariety""":
      """Use more variety for higher security""",
  """error.maxGenerationAttemptsPositive""":
      """maxGenerationAttempts must be greater than 0""",
  """error.policyMinExceedsMax""":
      """PasswordPolicy minLength cannot exceed maxLength""",
  """error.atLeastOneCharType""":
      """At least one character type must be selected""",
  """error.selectedCharSetsNotEmpty""":
      """Selected character sets must not be empty""",
  """error.wordlistEmpty""": """Wordlist must not be empty""",
  """error.wordlistHasEmptyWords""":
      """Wordlist must not contain empty words""",
  """error.wordCountPositive""": """Word count must be greater than 0""",
  """error.wordCountExceedsWordlist""":
      """Word count exceeds wordlist size when duplicates are disabled""",
  """error.characterPoolEmpty""": """Character pool cannot be empty""",
  """error.lengthNonNegative""": """Length must be non-negative""",
  """error.invalidFormat""": """invalid format""",
  """error.invalidLength""": """invalid length""",
};
