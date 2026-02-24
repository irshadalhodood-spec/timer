
import 'package:flutter/material.dart';

class CustomDropdownMenu extends StatefulWidget {
  late String myVal;
  late List<String> myList;
  final bool enabled;

  CustomDropdownMenu(
      {super.key,
      required String selVal,
      required List<String> list,
      this.enabled = true}) {
    myVal = selVal;

    myList = list;
  }

  @override
  State<CustomDropdownMenu> createState() => _CustomDropdownMenuState();
}

class _CustomDropdownMenuState extends State<CustomDropdownMenu> {
  /*String selectedValue = myVal;
  List<String> dropdownItems = myList;*/
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color.fromRGBO(114, 114, 114, 1)),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            value: widget.myVal,
            icon: const Icon(Icons
                .keyboard_arrow_down_outlined), // Icon aligned at the center right
            iconSize: 18,
            elevation: 16,
            style: const TextStyle(
              color: Color.fromRGBO(114, 114, 114, 1),
              fontSize: 14,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w500,
            ),
            onChanged: widget.enabled
                ? (val) {
                    widget.myVal = val!;
                    setState(() {});
                  }
                : null,
            items: widget.myList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Container(
                  height: 30,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    textAlign: TextAlign.left,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
