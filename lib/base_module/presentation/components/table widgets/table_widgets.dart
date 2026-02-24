
import 'package:employee_track/base_module/presentation/components/num_dropdown/custom_dropdown.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../core/values/color_scheme.dart';

Widget vSpace(double h) {
  return SizedBox(
    height: h,
  );
}

Widget wSpace(double w) {
  return SizedBox(
    width: w,
  );
}

String selectedDropdownValue = "10";
String selectedDropdownValue1 = "10";
Widget tableHeading({required String heading}) {
  return Row(
    children: [
      Expanded(
        child: Container(
            color: AppColorScheme.primary,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 5),
              child: Text(heading,
                  style: const TextStyle(color: Colors.white, fontSize: 14)),
            )),
      ),
    ],
  );
}

Widget searchBar({void Function(String)? onChanged, required double size}) {
  return Row(
    children: [
      Expanded(
          child: Container(
        color: const Color(0xffE2E2E2),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Row(
              children: [
                
                // const Text("Search",
                //     style: TextStyle(
                //       color: Colors.black,
                //       fontSize: 12,
                //       fontWeight: FontWeight.w600,
                //     )),
                // wSpace(10),
                SizedBox(
                  height: 35,
                  width: 290,
                  child: TextField(
                    
                    
                    decoration: InputDecoration(
                      hintText: "Search",
                      prefixIcon: const Icon(
                        CupertinoIcons.search
                      ),
                      border: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 0.5, color: Colors.grey.shade600),
                      ),
                      enabledBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: .5, color: Color(0xffA0A0A0)),
                      ),
                      focusedBorder: const OutlineInputBorder(
                        borderSide:
                            BorderSide(width: .5, color: Color(0xFF091057)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 5),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    textAlign: TextAlign.left,
                    keyboardType: TextInputType.multiline,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 13,
                        textBaseline: TextBaseline.alphabetic,
                        fontWeight: FontWeight.w400),
                    onChanged: onChanged,
                  ),
                ),


                Expanded(
                  flex: 7,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text("Display",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                          )),
                      wSpace(6),
                      SizedBox(
                          width: 65,
                          height: 22,
                          child: CustomDropdownMenu(
                              selVal: "10", list: const ["10", "20", "30"])),
                      wSpace(6),
                      size > 600
                          ? const Text("records",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.w400),)
                          : Container(),
                    ],
                  ),
                ),
              ],
            )),
      )),
    ],
  );
}

class TableColumn extends StatelessWidget {
  const TableColumn(
    this.text, {
    Key? key,
    this.heading = false,
    this.index,
    this.width,
    this.onTap,
    this.colorbool = false,
    this.textTrim = false,
  })  : assert(!heading || index == null,
            'If heading is true, index must be null'),
        assert(
            heading || index != null, 'If heading is false, index is required'),
        super(key: key);

  final String text;
  final bool heading;
  final int? index;
  final double? width;
  final void Function()? onTap;
  final bool colorbool;
  final bool textTrim;

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: size.height,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(4.0),
        constraints: BoxConstraints(
          minWidth: width ?? 0,
        ),
        color: heading
            ? const Color(0xffF6F6F6)
            : (index! % 2 != 0)
                ? const Color(0xffF6F6F6)
                : Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            !textTrim
                ? Padding(
                  padding: const EdgeInsets.only(left: 3.0),
                  child: SelectableText(
                      text,textAlign: TextAlign.justify,
                      style: TextStyle(
                        color:
                            colorbool ? Colors.blueAccent : Colors.black,
                        fontSize: 13,
                        overflow: TextOverflow.ellipsis,
                        fontWeight:
                            !heading ? FontWeight.normal : FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      maxLines: 1,
                      // overflow: TextOverflow.ellipsis,
                    ),
                )
                : Container(
                    constraints: const BoxConstraints(maxWidth: 255),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 3.0),
                      child: SelectableText(
                        text,
                        
                        
                        style: TextStyle(
                          color: colorbool
                              ? Colors.blueAccent
                              : Colors.black87,
                          fontSize: 13,
                          fontWeight:
                              !heading ? FontWeight.normal : FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                        maxLines: 10,
                        // overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

class TableColumnActionIcon extends StatelessWidget {
  const TableColumnActionIcon({
    super.key,
    required this.icon,
    required this.index,
    this.onPressed,
  });

  final Widget icon;
  final int index;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: (index % 2 != 0) ? const Color(0xffF6F6F6) : Colors.white,
      // width: double.infinity,
      alignment: Alignment.centerLeft,
      child: IconButton(
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        disabledColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        icon: icon,
      ),
    );
  }
}
