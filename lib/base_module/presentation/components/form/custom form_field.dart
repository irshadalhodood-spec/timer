

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import '../../core/values/app_constants.dart';
import '../custom_text_form_field/custom_text_form_field.dart';
import '../padding/app_padding.dart';

class CustomformField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController? controller;
  final int? maxLines;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? textInputType;
  final bool? isEditable;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final void Function()? onEditingComplete;
  final void Function(String?)? onSubmitted;
  final FocusNode? focusNode;

  const CustomformField({
    super.key,
    required this.label,
    required this.hint,
     this.controller,
    this.isEditable = true,
    this.maxLines,
    this.prefix,
    this.maxLength,
    this.suffix,
    this.textInputType,
    this.inputFormatters,
    this.onEditingComplete,
    this.onSubmitted,
    this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return 
    Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: 15,
                  fontWeight: FontWeight.w500
                ),
          ),
          const AppPadding(multipliedBy: 0.5),
          CustomTextFormField(
            maxLength: maxLength,
            enabled: isEditable!,
            inputFormatters: inputFormatters,
            controller: controller,
            maxLines: maxLines,
            onSubmitted: onSubmitted,
            onEditingComplete: onEditingComplete,
            focusNode: focusNode,
            
            

            prefix: prefix,
            suffix: suffix,
            textInputType: textInputType,
            validator: (value) => value!.isEmpty ? 'Enter $label' : null,
            borderDecoration: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
            filled: true,
            fillColor: Colors.white38,
            hintText: hint,
            textStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400
                ),

                
          )
        ],
      );
  }
}
