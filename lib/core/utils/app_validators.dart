import 'package:flutter/services.dart';
import 'package:grubpac/core/constants/app_strings.dart';

class AppValidators {
  AppValidators._();

  static String? nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.nameRequired;
    }
    if (value.trim().length < 3) {
      return AppStrings.nameTooShort;
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.emailRequired;
    }
    // Standard email validation regex
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.validEmailAddress;
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.phoneRequired;
    }
    // Assumes a standard 10-digit mobile number
    // (You can adjust to r'^\+?[0-9]{10,13}$' if you want to include country codes)
    final regex = RegExp(r'^[0-9]{10}$');
    if (!regex.hasMatch(value.trim())) {
      return AppStrings.validPhone;
    }
    return null;
  }



  static String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (value.length < 6) {
      return AppStrings.passwordTooShort;
    }
    // Optional: Add regex for strong password (uppercase, lowercase, number, special char)
    // final regex = RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[\W_]).{8,}$');
    // if (!regex.hasMatch(value)) {
    //   return 'Password must contain uppercase, lowercase, number and special character';
    // }
    return null;
  }

  static String? durationValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppStrings.durationRequired;
    }
    final duration = int.tryParse(value.trim());
    if (duration == null || duration <= 0) {
      return AppStrings.validDuration;
    }
    return null;
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
