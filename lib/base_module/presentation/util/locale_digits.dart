import 'package:flutter/material.dart';

import '../../domain/entities/translation.dart';

/// Arabic-Indic digits ٠١٢٣٤٥٦٧٨٩ (U+0660–U+0669).
const String _arabicDigits = '٠١٢٣٤٥٦٧٨٩';

/// Converts numbers to Arabic numerals when app language is Arabic.
/// Use [format] for any string containing digits, or [ofInt]/[ofDouble] for numbers.
class LocaleDigits {
  LocaleDigits._();

  /// Returns [s] with Western digits (0-9) replaced by Arabic-Indic (٠-٩) when app is Arabic.
  static String format(String s) {
    if (!translation.isArabic) return s;
    final buffer = StringBuffer();
    for (final rune in s.runes) {
      final c = String.fromCharCode(rune);
      if (c.compareTo('0') >= 0 && c.compareTo('9') <= 0) {
        buffer.write(_arabicDigits[int.parse(c)]);
      } else {
        buffer.write(c);
      }
    }
    return buffer.toString();
  }

  /// Returns integer as string in locale digits (e.g. 42 → "42" or "٤٢" in Arabic).
  static String ofInt(int n) => format(n.toString());

  /// Returns double as string in locale digits (e.g. 1.5 → "1.5" or "١.٥" in Arabic).
  static String ofDouble(double d, [int? fractionDigits]) {
    final s = fractionDigits != null ? d.toStringAsFixed(fractionDigits) : d.toString();
    return format(s);
  }
}

/// Displays text with digits in app locale (Arabic numerals when Arabic).
/// Use wherever you show numbers and want them in Arabic when the app is in Arabic.
class LocaleDigitsText extends StatelessWidget {
  const LocaleDigitsText(
    this.text, {
    super.key,
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
  });

  final String text;
  final TextStyle? style;
  final StrutStyle? strutStyle;
  final TextAlign? textAlign;
  final TextDirection? textDirection;
  final Locale? locale;
  final bool? softWrap;
  final TextOverflow? overflow;
  final double? textScaleFactor;
  final int? maxLines;
  final String? semanticsLabel;

  @override
  Widget build(BuildContext context) {
    return Text(
      LocaleDigits.format(text),
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
    );
  }
}
