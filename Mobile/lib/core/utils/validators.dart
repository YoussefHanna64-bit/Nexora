import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Validators {
  static String? username(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.usernameRequired;
    }
    if (value.trim().length < 3) {
      return l10n.usernameTooShort;
    }
    return null;
  }

  static String? email(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.trim().isEmpty) {
      return l10n.emailRequired;
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
      return l10n.emailInvalid;
    }
    return null;
  }

  static String? password(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.passwordRequired;
    }
    if (value.length < 8) {
      return l10n.passwordTooShort;
    }
    return null;
  }

  static String? confirmPassword(
      BuildContext context, String? value, String password) {
    final l10n = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) {
      return l10n.confirmPasswordRequired;
    }
    if (value != password) {
      return l10n.passwordsDoNotMatch;
    }
    return null;
  }

  static String? street(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.streetRequired;
    }
    return null;
  }

  static String? city(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.cityRequired;
    }
    return null;
  }

  static String? postalCode(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.postalCodeRequired;
    }

    if (!RegExp(r'^[0-9]{5}$').hasMatch(value.trim())) {
      return l10n.invalidPostalCode;
    }
    return null;
  }

  static String? phone(BuildContext context, String? value) {
    final l10n = AppLocalizations.of(context)!;

    if (value == null || value.trim().isEmpty) {
      return l10n.phoneRequired;
    }

    if (!RegExp(r'^01[0125][0-9]{8}$').hasMatch(value.trim())) {
      return l10n.invalidPhone;
    }
    return null;
  }
}
