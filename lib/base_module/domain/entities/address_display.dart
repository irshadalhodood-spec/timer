import 'dart:convert';

import 'translation.dart';

/// Encodes and decodes address stored in English and Arabic so the app
/// can save both and show the one matching the current translation.
class AddressDisplay {
  AddressDisplay._();

  static const _keyEn = 'en';
  static const _keyAr = 'ar';

  /// Encodes [addressEn] and [addressAr] into a single string for storage
  /// (e.g. in checkInAddress, checkOutAddress, break start/end address).
  static String encode(String addressEn, String addressAr) {
    return jsonEncode({_keyEn: addressEn, _keyAr: addressAr});
  }

  /// Returns the address to display from [stored], in the language set in App Settings.
  /// [stored] may be:
  /// - JSON with "en" and "ar" keys → returns the value for current app language (en/ar).
  /// - Plain string (legacy) → returned as-is.
  /// Returns null if [stored] is null or empty.
  static String? getDisplay(String? stored) {
    if (stored == null || stored.trim().isEmpty) return null;
    final trimmed = stored.trim();
    if (trimmed.startsWith('{') && trimmed.contains('"$_keyEn"') && trimmed.contains('"$_keyAr"')) {
      try {
        final map = jsonDecode(trimmed) as Map<String, dynamic>;
        final lang = translation.selectedLocale?.languageCode ?? 'en';
        if (lang == 'ar' && map[_keyAr] != null) {
          return map[_keyAr] as String?;
        }
        // English for en, fr, or any other locale
        return map[_keyEn] as String? ?? map[_keyAr] as String?;
      } catch (_) {
        return stored;
      }
    }
    return stored;
  }
}
