import 'package:flutter/material.dart';
import '../../presentation/feature/theming/bloc/theme_bloc.dart';
import '../../presentation/core/values/color_scheme.dart';

mixin AppThemes {
  
 static appThemeData(BuildContext context) => {
        ThemeState.light: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColorScheme.lightTertiary,
          scaffoldBackgroundColor: AppColorScheme.lightBackground,
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: AppColorScheme.lightPrimary,
            onPrimary: AppColorScheme.lightOnPrimary,
            primaryContainer: AppColorScheme.lightPrimaryContainer,
            onPrimaryContainer: AppColorScheme.lightOnPrimaryContainer,
            secondary: AppColorScheme.lightSecondary,
            onSecondary: AppColorScheme.lightPrimaryText,
            tertiary: AppColorScheme.lightTertiary,
            error: AppColorScheme.lightError,
            onError: AppColorScheme.lightOnPrimary,
            errorContainer: AppColorScheme.lightErrorContainer,
            surface: AppColorScheme.lightSurface,
            onSurface: AppColorScheme.lightPrimaryText,
            surfaceContainerHighest: AppColorScheme.lightSurfaceVariant,
            outline: AppColorScheme.lightOutline,
          ),
          textTheme: _lightTextTheme(context),
          listTileTheme: const ListTileThemeData(),
        ),
        ThemeState.dark: ThemeData(
          fontFamily: 'Poppins',
          primaryColor: AppColorScheme.darkTertiary,
          scaffoldBackgroundColor: AppColorScheme.darkBackground,
          colorScheme: ColorScheme(
            brightness: Brightness.dark,
            primary: AppColorScheme.darkPrimary,
            onPrimary: AppColorScheme.darkOnPrimary,
            primaryContainer: AppColorScheme.darkPrimaryContainer,
            onPrimaryContainer: AppColorScheme.darkOnPrimaryContainer,
            secondary: AppColorScheme.darkSecondary,
            onSecondary: AppColorScheme.darkPrimaryText,
            tertiary: AppColorScheme.darkTertiary,
            error: AppColorScheme.darkError,
            onError: AppColorScheme.darkOnPrimary,
            errorContainer: AppColorScheme.darkErrorContainer,
            surface: AppColorScheme.darkSurface,
            onSurface: AppColorScheme.darkPrimaryText,
            surfaceContainerHighest: AppColorScheme.darkSurfaceVariant,
            outline: AppColorScheme.darkOutline,
          ),
          textTheme: _darkTextTheme(context),
          listTileTheme: const ListTileThemeData(),
        ),
      };




  /// Light theme text styles (Poppins body, Poppins for display/headlines).
  static TextTheme _lightTextTheme(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return TextTheme(
      displayLarge: base.displayLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.lightPrimaryText,
      ),
      displayMedium: base.displayMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.lightPrimaryText,
      ),
      displaySmall: base.displaySmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.lightPrimaryText,
      ),
      headlineLarge: base.headlineLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.lightPrimaryText,
      ),
      headlineMedium: base.headlineMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.lightPrimaryText,
      ),
      headlineSmall: base.headlineSmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.lightPrimaryText,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.lightPrimaryText,
      ),
      titleMedium: base.titleMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColorScheme.lightPrimaryText,
      ),
      titleSmall: base.titleSmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColorScheme.lightPrimaryText,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightPrimaryText,
      ),
      bodyMedium: base.bodyMedium!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightPrimaryText,
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightSecondaryText,
      ),
      labelLarge: base.labelLarge!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightPrimaryText,
      ),
      labelMedium: base.labelMedium!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightPrimaryText,
      ),
      labelSmall: base.labelSmall!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.lightSecondaryText,
      ),
    );
  }

  /// Dark theme text styles (Poppins body, Poppins for display/headlines).
  static TextTheme _darkTextTheme(BuildContext context) {
    final base = Theme.of(context).textTheme;
    return TextTheme(
      displayLarge: base.displayLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.darkPrimaryText,
      ),
      displayMedium: base.displayMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.darkPrimaryText,
      ),
      displaySmall: base.displaySmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.darkPrimaryText,
      ),
      headlineLarge: base.headlineLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w700,
        color: AppColorScheme.darkPrimaryText,
      ),
      headlineMedium: base.headlineMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.darkPrimaryText,
      ),
      headlineSmall: base.headlineSmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.darkPrimaryText,
      ),
      titleLarge: base.titleLarge!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: AppColorScheme.darkPrimaryText,
      ),
      titleMedium: base.titleMedium!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColorScheme.darkPrimaryText,
      ),
      titleSmall: base.titleSmall!.copyWith(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        color: AppColorScheme.darkPrimaryText,
      ),
      bodyLarge: base.bodyLarge!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkPrimaryText,
      ),
      bodyMedium: base.bodyMedium!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkPrimaryText,
      ),
      bodySmall: base.bodySmall!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkSecondaryText,
      ),
      labelLarge: base.labelLarge!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkPrimaryText,
      ),
      labelMedium: base.labelMedium!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkPrimaryText,
      ),
      labelSmall: base.labelSmall!.copyWith(
        fontFamily: 'Poppins',
        color: AppColorScheme.darkSecondaryText,
      ),
    );
  }

 
}
