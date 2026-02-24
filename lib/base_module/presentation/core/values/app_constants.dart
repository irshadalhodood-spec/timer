import 'package:flutter/material.dart';

class AppConstants {
  static const appName = "Track";

  static const appCaption = "";
  static const cornerRadius = 10.0;
  static const cornerRadiuscircle = 50.0;
  static const smallCornerRadius = 6.0;
  static const cornerRadiusLarge = 16.0;
  static const defaultPadding = 18.0;
  static const dummyUrls = 'url';
  static const imgUrl = '';
  static const elevation = 0.0;
  static const appVersion = "1.0.1";

  /// Expected work seconds per day (8 hours). Checkout before this is treated as early → prompt for note and mark partial leave.
  static const int expectedWorkSecondsPerDay = 8 * 3600;


  static const dummyInviteUrl = 'https://app.employee-track.example.com/invite/demo-org-xyz';
  static const dummyUsername = 'demo_user';
  static const dummyPassword = 'Demo@123';


 static BoxDecoration getDecoration(BuildContext context) {
    return BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Theme.of(context).shadowColor.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(cornerRadius * 0.2),
    );
  }
}