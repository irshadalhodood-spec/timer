
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/values/app_constants.dart';


class CustomChip extends StatelessWidget {
  final double? fontSize;
  final double? iconsize;

  final name;
  final VoidCallback onDeleted;

  const CustomChip({
    Key? key,
    required this.name,
    
    required this.onDeleted,
    this.fontSize,
    this.iconsize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Chip(
      
      padding: EdgeInsets.zero,
      
      backgroundColor: Colors.white38,
       shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(AppConstants.smallCornerRadius), 
  ),
      side: BorderSide(color:  Theme.of(context).colorScheme.primaryContainer,width: 0.1),
      deleteIcon: Icon(
        CupertinoIcons.clear,
        size:iconsize?? 15,
        color: Colors.black
      ),
      label: Text(
 name ?? '' ,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
      ),
      onDeleted: onDeleted,
    );
  }
}

