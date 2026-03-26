import 'package:habit_boost/l10n/app_localizations.dart';

abstract class Validators {
  static final _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? email(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.validatorEmailRequired;
    }
    if (!_emailRegex.hasMatch(value.trim())) {
      return l10n.validatorEmailInvalid;
    }
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) {
      return l10n.validatorPasswordRequired;
    }
    if (value.length < 6) {
      return l10n.validatorPasswordMinLength;
    }
    return null;
  }

  static String? confirmPassword(
    String? value,
    String password,
    AppLocalizations l10n,
  ) {
    final error = Validators.password(value, l10n);
    if (error != null) return error;
    if (value != password) {
      return l10n.validatorPasswordsMismatch;
    }
    return null;
  }

  static String? required(
    String? value,
    AppLocalizations l10n, [
    String? fieldName,
  ]) {
    if (value == null || value.trim().isEmpty) {
      return fieldName != null
          ? l10n.validatorFieldRequired(fieldName)
          : l10n.validatorFieldRequired('');
    }
    return null;
  }
}
