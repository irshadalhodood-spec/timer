import 'package:flutter/material.dart';

/// User-friendly light and dark color palettes for the app.
/// Use [light] for light theme and [dark] for dark theme.
mixin AppColorScheme {
  // ===========================================================================
  // LIGHT THEME (soft, readable, easy on eyes)
  // ===========================================================================
  static const Color lightPrimary = Color(0xFF0891B2); // cyan-600
  static const Color lightPrimaryLight = Color(0xFF0E7490);
  static const Color lightPrimaryDark = Color(0xFF155E75);
  static const Color lightPrimaryContainer = Color(0xFFCFFAFE);
  static const Color lightOnPrimary = Color(0xFFFFFFFF);
  static const Color lightOnPrimaryContainer = Color(0xFF164E63);

  static const Color lightSecondary = Color(0xFF64748B); // slate-500
  static const Color lightSecondaryLight = Color(0xFF94A3B8);
  static const Color lightTertiary = Color(0xFF0D9488); // teal-600
  static const Color lightPrimaryColor = Color(0xFF64748B);

  static const Color lightSuccess = Color(0xFF059669); // emerald-600
  static const Color lightSuccessLight = Color(0xFF10B981);
  static const Color lightSuccessContainer = Color(0xFFD1FAE5);
  static const Color lightError = Color(0xFFDC2626); // red-600
  static const Color lightErrorText = Color(0xFFEF4444);
  static const Color lightErrorContainer = Color(0xFFFEE2E2);
  static const Color lightWarning = Color(0xFFD97706); // amber-600
  static const Color lightWarningContainer = Color(0xFFFEF3C7);
  static const Color lightInfo = Color(0xFF0284C7); // sky-600
  static const Color lightInfoContainer = Color(0xFFE0F2FE);

  static const Color lightBackground = Color(0xFFF8FAFC); // slate-50
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);
  static const Color lightPrimaryText = Color(0xFF1E293B); // slate-800
  static const Color lightSecondaryText = Color(0xFF64748B);
  static const Color lightTertiaryText = Color(0xFF94A3B8);
  static const Color lightOutline = Color(0xFFE2E8F0);
  static const Color lightOutlineVariant = Color(0xFFCBD5E1);
  static const Color lightDivider = Color(0xFFE2E8F0);

  // ===========================================================================
  // DARK THEME (comfortable contrast, no harsh brightness)
  // ===========================================================================
  static const Color darkPrimary = Color(0xFF22D3EE); // cyan-400
  static const Color darkPrimaryLight = Color(0xFF67E8F9);
  static const Color darkPrimaryDark = Color(0xFF06B6D4);
  static const Color darkPrimaryContainer = Color(0xFF164E63);
  static const Color darkOnPrimary = Color(0xFF0C4A6E);
  static const Color darkOnPrimaryContainer = Color(0xFFCFFAFE);

  static const Color darkSecondary = Color(0xFF94A3B8);
  static const Color darkSecondaryLight = Color(0xFFCBD5E1);
  static const Color darkTertiary = Color(0xFF2DD4BF); // teal-400
  static const Color darkPrimaryColor = Color(0xFF94A3B8);

  static const Color darkSuccess = Color(0xFF34D399);
  static const Color darkSuccessLight = Color(0xFF6EE7B7);
  static const Color darkSuccessContainer = Color(0xFF064E3B);
  static const Color darkError = Color(0xFFF87171);
  static const Color darkErrorText = Color(0xFFFCA5A5);
  static const Color darkErrorContainer = Color(0xFF7F1D1D);
  static const Color darkWarning = Color(0xFFFBBF24);
  static const Color darkWarningContainer = Color(0xFF78350F);
  static const Color darkInfo = Color(0xFF38BDF8);
  static const Color darkInfoContainer = Color(0xFF0C4A6E);

  static const Color darkBackground = Color(0xFF0F172A); // slate-900
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkPrimaryText = Color(0xFFF8FAFC); // slate-50
  static const Color darkSecondaryText = Color(0xFF94A3B8);
  static const Color darkTertiaryText = Color(0xFF64748B);
  static const Color darkOutline = Color(0xFF475569);
  static const Color darkOutlineVariant = Color(0xFF334155);
  static const Color darkDivider = Color(0xFF334155);

  // ===========================================================================
  // BACKWARD COMPATIBILITY: default to light theme colors
  // (use Theme.of(context).brightness to pick light vs dark elsewhere)
  // ===========================================================================
  static Color get primary => lightPrimary;
  static Color get primaryLight => lightPrimaryLight;
  static Color get primaryDark => lightPrimaryDark;
  static Color get primaryContainer => lightPrimaryContainer;
  static Color get onPrimary => lightOnPrimary;
  static Color get onPrimaryContainer => lightOnPrimaryContainer;
  static Color get secondary => lightSecondary;
  static Color get secondaryLight => lightSecondaryLight;
  static Color get tertiary => lightTertiary;
  static Color get primaryColor => lightPrimaryColor;
  static Color get success => lightSuccess;
  static Color get successLight => lightSuccessLight;
  static Color get successContainer => lightSuccessContainer;
  static Color get error => lightError;
  static Color get errorText => lightErrorText;
  static Color get errorContainer => lightErrorContainer;
  static Color get warning => lightWarning;
  static Color get warningContainer => lightWarningContainer;
  static Color get info => lightInfo;
  static Color get infoContainer => lightInfoContainer;
  static Color get background => lightBackground;
  static Color get surface => lightSurface;
  static Color get surfaceVariant => lightSurfaceVariant;
  static Color get primaryText => lightPrimaryText;
  static Color get secondaryText => lightSecondaryText;
  static Color get tertiaryText => lightTertiaryText;
  static Color get outline => lightOutline;
  static Color get outlineVariant => lightOutlineVariant;
  static Color get divider => lightDivider;

  /// Resolve color for current brightness (e.g. from Theme.of(context).brightness).
  static Color primaryFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkPrimary : lightPrimary;
  static Color backgroundFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkBackground : lightBackground;
  static Color surfaceFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSurface : lightSurface;
  static Color primaryTextFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkPrimaryText : lightPrimaryText;
  static Color secondaryTextFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSecondaryText : lightSecondaryText;
  static Color errorFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkError : lightError;
  static Color successFor(Brightness brightness) =>
      brightness == Brightness.dark ? darkSuccess : lightSuccess;

  // ---------------------------------------------------------------------------
  // Convenience: palette lists (light theme by default)
  // ---------------------------------------------------------------------------
  static List<Color> get palette => [
        lightPrimary,
        lightPrimaryLight,
        lightPrimaryDark,
        lightSecondary,
        lightTertiary,
        lightSuccess,
        lightSuccessLight,
        lightError,
        lightWarning,
        lightInfo,
        lightPrimaryText,
        lightSecondaryText,
        lightBackground,
        lightSurface,
      ];

  static List<Color> get semanticColors => [
        lightSuccess,
        lightSuccessLight,
        lightError,
        lightErrorText,
        lightWarning,
        lightInfo,
        lightSuccessContainer,
        lightErrorContainer,
        lightWarningContainer,
        lightInfoContainer,
      ];

  static List<Color> get neutralColors => [
        lightBackground,
        lightSurface,
        lightSurfaceVariant,
        lightPrimaryText,
        lightSecondaryText,
        lightTertiaryText,
        lightOutline,
        lightOutlineVariant,
        lightDivider,
      ];
}
