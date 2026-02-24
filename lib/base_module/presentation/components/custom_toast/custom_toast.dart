import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class ToastHelper {
  static void showSuccessToast({
    required BuildContext context,
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.success,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: description != null
          ? RichText(
              text: TextSpan(
                text: description,
                style: const TextStyle(color: Colors.black),
              ),
            )
          : null,
      alignment: Alignment.topCenter,
      animationDuration: const Duration(milliseconds: 300),
      icon: const Icon(Icons.check),
      showIcon: true,
      primaryColor: Colors.green,
      backgroundColor: Colors.green.shade50,
      foregroundColor: Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Color(0x07000000),
          blurRadius: 16,
          offset: Offset(0, 16),
          spreadRadius: 0,
        )
      ],
      showProgressBar: false,
      closeOnClick: true,
      pauseOnHover: true,
      dragToClose: true,
      applyBlurEffect: true,
    );
  }

  static void showErrorToast({
    required BuildContext context,
    required String title,
    String? description,
  }) {
    toastification.show(
      context: context,
      type: ToastificationType.error,
      style: ToastificationStyle.flat,
      autoCloseDuration: const Duration(seconds: 5),
      title: Text(title),
      description: description != null
          ? RichText(
              text: TextSpan(
                text: description,
                style: const TextStyle(color: Colors.black),
              ),
            )
          : null,
      alignment: Alignment.topCenter,
      primaryColor: Colors.red,
      backgroundColor: Colors.red.shade50,
      foregroundColor: Colors.black,
      icon: const Icon(Icons.error),
      showIcon: true,
      borderRadius: BorderRadius.circular(12),
      showProgressBar: false,
    );
  }
}
