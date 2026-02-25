import 'package:flutter/material.dart';
import 'base_module/presentation/core/values/color_scheme.dart';

final globalNavigatorKey = GlobalKey<NavigatorState>();

final globalSnackBarKey = GlobalKey<ScaffoldMessengerState>();

void showSnackBar(SnackBar snackBar) {
  globalSnackBarKey.currentState?.showSnackBar(snackBar);
}

void showToast(String message, {Duration? duration}) {
  final context = globalSnackBarKey.currentContext;
  if (context == null) {
    print('Error: Context is null');
    return;
  }

  showSnackBar(
    SnackBar(
      content: Text(message),
      duration: duration ?? Duration(seconds: 3),
    ),
  );
}

void showSuccessToast(String message, {Duration? duration}) {
  final context = globalSnackBarKey.currentContext;
  if (context == null) {
    print('Error: Context is null');
    return;
  }

  
  

  showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: AppColorScheme.success,
      duration: duration ?? Duration(seconds: 3),
    ),
  );
}

void showErrorToast(String message, {Duration? duration}) {
  final context = globalSnackBarKey.currentContext;
  if (context == null) {
    // Handle error if context is null
    print('Error: Context is null');
    return;
  }

  showSnackBar(
    SnackBar(
      content: Text(message),
      backgroundColor: Theme.of(context).colorScheme.error,
      duration: duration ?? Duration(seconds: 3),
    ),
  );
}

showBottomSheetPopup(
    {required WidgetBuilder builder, required BuildContext context}) {
  showModalBottomSheet(
    isScrollControlled: true,
    enableDrag: true,
    context: globalNavigatorKey.currentContext!,
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    barrierColor: AppColorScheme.primaryText.withValues(alpha:0.9),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: builder(context),
      );
    },
  );
}

void globalNavigateToWelcomeScreen() {
  globalClearUserData();

  // globalNavigatorKey.currentState?.pushAndRemoveUntil(
  // MaterialPageRoute(builder: (_) => const SignInPage()
  // ),
  // (route) => false,
  // );
}

void globalNavigateToHomeScreen() {
  // Widget nextScreen = const SignIn();

  // if (authentication.isAuthenticated) {
  //   globalReloadCommonData();
  //   globalReloadUserData();
  // }

  // globalNavigatorKey.currentState?.pushAndRemoveUntil(
  //   MaterialPageRoute(builder: (_) => nextScreen),
  //   (route) => false,
  // );
}

void globalReloadCommonData() {
  if (globalNavigatorKey.currentContext == null) return;

  //can add extra common blocs here

  // if (!authentication.isAuthenticated) return;
}

void globalReloadUserData() {
  // if (globalNavigatorKey.currentContext == null ||
  //     !authentication.isAuthenticated) {
  //   return;
  // }

  //can add extra user blocs here
}

void globalClearUserData() {
  if (globalNavigatorKey.currentContext == null) return;
}