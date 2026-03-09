import 'package:string_validator/string_validator.dart';

import '../../domain/entities/translation.dart';

class Validate {
  static String? email(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? translation.of("required")
        : !isEmail(value0)
            ? translation.of("invalid_email")
            : null;
  }

  static String? optionalEmail(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? null
        : !isEmail(value0)
            ? translation.of("invalid_email")
            : null;
  }

  static String? value(String? value) {
    final value0 = value?.trim() ?? "";
    return value0.isEmpty ? translation.of("required") : null;
  }

  static String? number(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? translation.of("required")
        : double.tryParse(value0) == null
            ? translation.of("should_be_number")
            : null;
  }

  static String? equal(String? value1, String? value2) {
    final value10 = value1?.trim() ?? "";
    final value20 = value2?.trim() ?? "";

    return value10.isNotEmpty && value10 != value20
        ? translation.of("not_equal")
        : null;
  }

  static String? password(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? translation.of("required")
        : value0.length < 6
            ? translation.of("password_length")
            : null;
  }

  static String? phone(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? translation.of("required")
        : !RegExp(r'^[0-9]{10,}$').hasMatch(value0)
            ? translation.of("mobile_length")
            : null;
  }

  static String? optionalPhone(String? value) {
    final value0 = value?.trim() ?? "";

    return value0.isEmpty
        ? null
        : !RegExp(r'^[0-9]{6,}$').hasMatch(value0)
            ? translation.of("mobile_length")
            : null;
  }
}