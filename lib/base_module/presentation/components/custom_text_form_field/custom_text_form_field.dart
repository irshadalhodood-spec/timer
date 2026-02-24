import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import '../../core/values/app_constants.dart';
import '../../core/values/color_scheme.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    Key? key,
    this.suffixWidget,
    this.name,
    this.initialValue,
    this.alignment,
    this.width,
    this.margin,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.textStyle,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.maxLines,
    this.maxLength,
    this.hintText,
    this.hintStyle,
    this.prefix,
    this.prefixConstraints,
    this.suffix,
    this.suffixConstraints,
    this.contentPadding,
    this.borderDecoration,
    this.fillColor,
    this.filled = true,
    this.validator,
    this.onChanged,
    this.onTap,
    this.inputFormatters,
    this.onSubmitted,
    this.onEditingComplete
  }) : super(key: key);

  final String? name;

  final String? initialValue;

  final Alignment? alignment;

  final double? width;

  final EdgeInsetsGeometry? margin;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool enabled;

  final bool readOnly;

  final bool autofocus;

  final TextStyle? textStyle;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final int? maxLength;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;
  final Widget? suffixWidget;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final List<TextInputFormatter>? inputFormatters;

  final Color? fillColor;

  final bool? filled;

  final FormFieldValidator<String>? validator;

  final void Function(String?)? onChanged;
  final void Function()? onTap;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => Container(
        width: width ?? double.maxFinite,
        margin: margin,
        child: FormBuilderTextField(
          onSubmitted: onSubmitted,
          onEditingComplete: onEditingComplete,
          maxLength: maxLength,
          textAlign: TextAlign.start,
          onTap: onTap,
          name: name ??
              "form_text_field_${DateTime.now().microsecondsSinceEpoch}",
          initialValue: initialValue,
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          enabled: enabled,
          inputFormatters: inputFormatters,
          readOnly: readOnly,
          autofocus: autofocus,
          style: textStyle,
          obscureText: obscureText ?? false,
          obscuringCharacter: "*",
          textInputAction: textInputAction,
          keyboardType: textInputType,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          onChanged: onChanged,
          cursorColor: AppColorScheme.primaryText,
        ),
      );

  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffix: suffixWidget,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            const EdgeInsets.only(left: 16, top: 12, right: 16, bottom: 12),
        fillColor: fillColor,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide:
                  BorderSide(color: AppColorScheme.primaryText, width: 1),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColorScheme.primaryText,
                width: 1,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColorScheme.primaryText,
                width: 1,
              ),
            ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.5),
          borderSide: BorderSide(
            color: AppColorScheme.error,
            width: 0.2,
          ),
        ),
        disabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(24),
              borderSide: BorderSide(
                color: AppColorScheme.primaryText,
                width: 1,
              ),
            ),
      );
}

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get fillPink => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.00),
        borderSide: BorderSide.none,
      );

  static UnderlineInputBorder get underLinePrimary => UnderlineInputBorder(
        borderSide: BorderSide(color: AppColorScheme.primaryText),
      );

  static OutlineInputBorder get fillPrimary => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.00),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillGrayC => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.00),
        borderSide: BorderSide.none,
      );

  static OutlineInputBorder get fillGrayTL6 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(4.00),
        borderSide: BorderSide.none,
      );
}
