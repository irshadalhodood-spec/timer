import 'package:flutter/material.dart';

import '../../core/values/app_constants.dart';
import '../custom_button/button.dart';
import '../padding/app_padding.dart';

class ConfirmationDialog extends StatefulWidget {
  final String? title;
  final String? description;
  final String? buttonText;
  final String? highlightedText;
  final VoidCallback onConfirm;
  final bool? loading;

  const ConfirmationDialog({
    Key? key,
    this.title,
    this.description,
    this.buttonText,
    this.highlightedText,
    this.loading,
    required this.onConfirm,
  }) : super(key: key);

  @override
  State<ConfirmationDialog> createState() => _ConfirmationDialogState();
}

class _ConfirmationDialogState extends State<ConfirmationDialog> {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Dialog(
      shadowColor: Theme.of(context).shadowColor.withValues(alpha:0.1),
      alignment: Alignment.center,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.3),
      ),
      child: SizedBox(
        width: size.width * 0.2,
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const AppPadding(),
              Text(
                widget.title ?? "Confirm",
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.error),
              ),
              const AppPadding(),
              Text.rich(
                TextSpan(
                  text: widget.description ?? "Are you sure?",
                  style: Theme.of(context).textTheme.bodySmall,
                  children: widget.highlightedText != null
                      ? [
                          TextSpan(
                              text: " ${widget.highlightedText}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  )),
                          const TextSpan(text: "?"),
                        ]
                      : [],
                ),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
              const AppPadding(multipliedBy: 1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: PrimaryButton(
                    height: 40,
                    onTap: () => Navigator.pop(context),
                    text: "Cancel",
                    textColor: Colors.black,
                    bgColor: Colors.transparent,
                    borderColor: Colors.black,
                    borderWidth: 0.08,
                  )),
                  const AppPadding(),
                  Expanded(
                    child: PrimaryButton(
                      isLoading: widget.loading ?? false,
                      height: 40,
                      onTap: widget.onConfirm,
                      text: widget.buttonText ?? "Update",
                      textColor: Theme.of(context).colorScheme.error,
                      borderColor: Theme.of(context).colorScheme.error,
                      borderWidth: 0.5,
                      bgColor: Theme.of(context).colorScheme.errorContainer.withValues(alpha:0.05),
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
