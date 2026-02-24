import 'package:flutter/material.dart';

void showCustomSnackBar(
    {required BuildContext context,
    required String message,
    Color backgroundColor = Colors.black,
    Color textColor = Colors.white,
    IconData? icon,
    Duration duration = const Duration(seconds: 3),
    TextAlign textAlign = TextAlign.start,
    double elevation = 0.0,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
    BorderRadiusGeometry borderRadius =
        const BorderRadius.all(Radius.circular(10)),
    EdgeInsetsGeometry margin = const EdgeInsets.all(16.0),
    EdgeInsetsGeometry padding =
        const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    TextStyle? textStyle,
    ShapeBorder? shape,
    VoidCallback? onTap,
    Function()? onDismissed,
    SnackBarAction? action,
    bool dismissible = true,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    double iconSize = 20.0}) {
  final snackBar = SnackBar(
    content: GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: mainAxisAlignment,
        children: [
          if (icon != null)
            Icon(
              icon,
              color: textColor,
              size: iconSize,
            ),
          if (icon != null) SizedBox(width: 8),
          Flexible(
            child: Text(
              message,
              textAlign: textAlign,
              style: textStyle ?? TextStyle(color: textColor),
            ),
          ),
        ],
      ),
    ),
    elevation: elevation,
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: behavior,
    shape: shape ?? RoundedRectangleBorder(borderRadius: borderRadius),
    margin: behavior == SnackBarBehavior.floating ? margin : null,
    padding: padding,
    action: action,
    dismissDirection: dismissible ? DismissDirection.down : null,
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar).closed.then((reason) {
    if (onDismissed != null) {
      onDismissed();
    }
  });
}
