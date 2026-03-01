// GENERATED CODE - DO NOT MODIFY BY HAND.
// Generated from lib/l10n/messages.i18n.yaml.

class Messages {
  const Messages();

  FeedbackMessages get feedback => FeedbackMessages(this);
  ErrorMessages get error => ErrorMessages(this);
}

class FeedbackMessages {
  const FeedbackMessages(this._parent);

  final Messages _parent;

  FeedbackWarningMessages get warning => FeedbackWarningMessages(_parent);
  FeedbackSuggestionMessages get suggestion =>
      FeedbackSuggestionMessages(_parent);
}

class ErrorMessages {
  const ErrorMessages(this._parent);

  final Messages _parent;

  String maxAttemptsExceeded(int maxAttempts) =>
      'Unable to generate a strong password within $maxAttempts attempts.';
  String get maxGenerationAttemptsPositive =>
      'maxGenerationAttempts must be greater than 0';
  String get policyMinExceedsMax =>
      'PasswordPolicy minLength cannot exceed maxLength';
  String passwordLengthMin(int min) => 'Password length must be at least $min';
  String get atLeastOneCharType =>
      'At least one character type must be selected';
  String get selectedCharSetsNotEmpty =>
      'Selected character sets must not be empty';
  String get wordlistEmpty => 'Wordlist must not be empty';
  String get wordlistHasEmptyWords => 'Wordlist must not contain empty words';
  String get wordCountPositive => 'Word count must be greater than 0';
  String get wordCountExceedsWordlist =>
      'Word count exceeds wordlist size when duplicates are disabled';
  String get characterPoolEmpty => 'Character pool cannot be empty';
  String get lengthNonNegative => 'Length must be non-negative';
  String get invalidFormat => 'invalid format';
  String get invalidLength => 'invalid length';
}

class FeedbackWarningMessages {
  const FeedbackWarningMessages(this._parent);

  final Messages _parent;

  String get tooWeak => 'Too weak';
  String get weak => 'Weak password';
  String get medium => 'Could be stronger';
  String get policyNotMet => 'Does not meet policy requirements';
  String get policyPartiallyMet => 'Policy requirements partially met';
  String get almostThere => 'Almost there';
}

class FeedbackSuggestionMessages {
  const FeedbackSuggestionMessages(this._parent);

  final Messages _parent;

  String get useLonger => 'Use a longer password';
  String get addWordPhrase => 'Add another word or phrase';
  String get mixCharacterTypes => 'Mix more character types';
  String get addLengthOrWord => 'Add length or another word';
  String get avoidCommonPatterns => 'Avoid common patterns';
  String get increaseLengthSlightly => 'Increase length slightly';
  String get addWordOrSymbol => 'Add another word or symbol';
  String increaseLengthMin(int min) => 'Increase length to at least $min';
  String get addUppercase => 'Add an uppercase letter';
  String get addLowercase => 'Add a lowercase letter';
  String get addNumber => 'Add a number';
  String get addSpecial => 'Add a special character';
  String get useMoreVariety => 'Use more variety for higher security';
}
