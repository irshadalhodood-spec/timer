import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/values/app_constants.dart';



class CustomDropdownMenu<T> extends StatelessWidget {
  final T initialSelection;
  final List<T> items;
  final String? label;
  final ValueChanged<T?> onSelected;
  final bool enableFilter;
  final bool enableSearch;
  final TextEditingController? controller;
  final bool enabled;
  final String? errorText;
  final EdgeInsets? expandedInsets;
  final FocusNode? focusNode;
  final String? helperText;
  final String? hintText;
  final InputDecorationTheme? inputDecorationTheme;
  final List<TextInputFormatter>? inputFormatters;
  final Key? widgetKey;
  final Widget? leadingIcon;
  final double? menuHeight;
  final MenuStyle? menuStyle;
  final Widget? selectedTrailingIcon;
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final Widget? trailingIcon;
  final double? width;
  final String Function(T)? itemLabelBuilder; 

   const CustomDropdownMenu({
    super.key,
    required this.initialSelection,
    required this.items,
    required this.onSelected,
    this.label,
    this.enableFilter = false,
    this.enableSearch = false,
    this.controller,
    this.enabled = true,
    this.errorText,
    this.expandedInsets,
    this.focusNode,
    this.helperText,
    this.hintText,
    this.inputDecorationTheme,
    this.inputFormatters,
    this.widgetKey,
    this.leadingIcon,
    this.menuHeight,
    this.menuStyle,
    this.selectedTrailingIcon,
    this.textAlign = TextAlign.start,
    this.textStyle,
    this.trailingIcon,
    this.width,
    this.itemLabelBuilder, 
  });
  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      key: widgetKey,
      initialSelection: initialSelection,
      requestFocusOnTap: true,
      label: label != null ? Text(label!) : null,
      // filterCallback: (entries, filter) {
//   if (filter.isEmpty) return entries;
//   final filteredEntries = entries
//       ?.where((item) => 
//           item != null && 
//           item.toString().toLowerCase().contains(filter.toLowerCase())
//       )
//       .toList() ?? [];
//   return filteredEntries.isNotEmpty 
//       ? filteredEntries
//       : entries; 
// },



      // filterCallback: (entries, filter) => entries.where((item) => item.toString().toLowerCase().contains(filter.toLowerCase())).toList(),
      // enableFilter: enableFilter,
      enableSearch: enableSearch,
      controller: controller,
      enabled: enabled,
      errorText: errorText,
      expandedInsets: expandedInsets ?? const EdgeInsets.all(0),
      focusNode: focusNode,
      helperText: helperText,
      hintText: hintText,
      inputDecorationTheme: inputDecorationTheme ??
          InputDecorationTheme(
            contentPadding: const EdgeInsets.only(left: 10, right: 10),
            constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
            outlineBorder: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.2),
            fillColor: Colors.white38,
            filled: true,
            activeIndicatorBorder: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.2),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.error, width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  width: 0.2),
              borderRadius: const BorderRadius.all(
                Radius.circular(AppConstants.cornerRadius * 0.5),
              ),
            ),
          ),
      inputFormatters: inputFormatters,
      leadingIcon: leadingIcon,
      menuHeight: menuHeight ?? 450,
      menuStyle: menuStyle,
      selectedTrailingIcon: selectedTrailingIcon ??
          const Icon(CupertinoIcons.chevron_up, size: 15),
      textAlign: textAlign,
      textStyle: textStyle,
      trailingIcon:
          trailingIcon ?? const Icon(CupertinoIcons.chevron_down, size: 15),
      width: width ?? 280,
      onSelected: onSelected,
      dropdownMenuEntries: items.isNotEmpty?
       items.map<DropdownMenuEntry<T>>((T item) {
        return DropdownMenuEntry<T>(
          value: item,
          label: itemLabelBuilder != null
              ? itemLabelBuilder!(item)
              : item.toString(), 
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
            ),
            minimumSize: const WidgetStatePropertyAll(Size(0, 35)),
            textStyle: WidgetStateProperty.all<TextStyle>(
              Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
        );
      }
      
      ).toList():
      [
     
      ],
    );
  }
}




