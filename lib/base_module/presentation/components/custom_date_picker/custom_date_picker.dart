// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// // import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
// import 'package:intl/intl.dart';

// import '../../core/values/app_constants.dart';

// class DateField extends StatefulWidget {
//   final TextEditingController controller;
//   final DateTime initialDate;
//   final String dateFormat;
//   final double radius;
//   final Color? color;
//   final double height;
//   final Function(DateTime)? onChanged;

//   const DateField({
//     super.key,
//     required this.controller,
//     required this.initialDate,
//     this.dateFormat = 'dd/MM/yyyy',
//     this.radius = 10.0,
//     this.color,
//     this.height = 50.0,
//     this.onChanged,
//   });

//   @override
//   _DateFieldState createState() => _DateFieldState();
// }

// class _DateFieldState extends State<DateField> {
//   @override
//   void initState() {
//     super.initState();
//     _updateText(widget.initialDate);
//   }

//   void _updateText(DateTime date) {
//     widget.controller.text = DateFormat(widget.dateFormat).format(date);
//     if (widget.onChanged != null) {
//       widget.onChanged!(date);
//     }
//   }

//   Future<void> _selectDate(BuildContext context) async {
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: widget.initialDate,

//       firstDate:DateTime(1100),
//       //  DateTime.now(),
//       lastDate: DateTime(2100),
//        builder: (BuildContext context, Widget? child) {

//     return Theme(
//       data: ThemeData.light().copyWith(
//         primaryColor: Theme.of(context).colorScheme.primary,
//         colorScheme: ColorScheme.light(
//           primary: Theme.of(context).colorScheme.primary,
//           outline: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
//         ),
//         dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
//         dividerColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
//         dividerTheme: DividerThemeData(
//           color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
//         ),
//         textTheme: TextTheme(
//           bodyMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400
//                 ),
//         ),
//       ),
//       child: child!,
//     );
//   },
//     );

//     if (pickedDate != null) {
//       setState(() {
//         _updateText(pickedDate);
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return PrimaryContainer(
//       radius: widget.radius,
//       color: widget.color,
//       height: widget.height,
//       child: TextFormField(
//         readOnly: true,
//         style: Theme.of(context).textTheme.titleMedium!.copyWith(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400
//                 ),
//         controller: widget.controller,
//         textAlignVertical: TextAlignVertical.center,
//         onTap: () => _selectDate(context),
//         decoration: InputDecoration(
//           contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
//           border: OutlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   width: 0.2),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(AppConstants.cornerRadius * 0.5),
//               ),
//             ),
//           filled: false,
//           focusedBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   width: 0.2),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(AppConstants.cornerRadius * 0.5),
//               ),
//             ),
//           errorBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   width: 0.2),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(AppConstants.cornerRadius * 0.5),
//               ),
//             ),
//           disabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   width: 0.2),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(AppConstants.cornerRadius * 0.5),
//               ),
//             ),
//           enabledBorder: OutlineInputBorder(
//               borderSide: BorderSide(
//                   color: Theme.of(context).colorScheme.primaryContainer,
//                   width: 0.2),
//               borderRadius: const BorderRadius.all(
//                 Radius.circular(AppConstants.cornerRadius * 0.5),
//               ),
//             ),
//           hintText: widget.dateFormat.toUpperCase(),
//           suffixIcon: const Icon(Icons.calendar_today),
//           hintStyle:Theme.of(context).textTheme.titleMedium!.copyWith(
//                   color: Colors.black,
//                   fontSize: 15,
//                   fontWeight: FontWeight.w400
//                 ),
//         ),
//       ),
//     );
//   }
// }

// class PrimaryContainer extends StatelessWidget {
//   final Widget child;
//   final double radius;
//   final Color? color;
//   final double height;

//   const PrimaryContainer({
//     super.key,
//     required this.child,
//     this.radius = 10.0,
//     this.color,
//     this.height = 50.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: height,
//       decoration: BoxDecoration(
//       boxShadow: [
//         BoxShadow(
//           color: Theme.of(context).shadowColor.withOpacity(0.04),
//           spreadRadius: 2,
//           blurRadius: 5,
//           offset: const Offset(0, 3),
//         ),
//       ],
//       color: Theme.of(context).colorScheme.surface,
//       borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.2),
//     ),

//       child: child,
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/values/app_constants.dart';

class DateField extends StatefulWidget {
  final TextEditingController controller;
  final DateTime initialDate;
  final String dateFormat;
  final double radius;
  final Color? color;
  final double height;
  final Function(String)? onChanged;

  const DateField({
    Key? key,
    required this.controller,
    required this.initialDate,
    this.dateFormat = 'dd/MM/yyyy',
    this.radius = 10.0,
    this.color,
    this.height = 50.0,
    this.onChanged,
  }) : super(key: key);

  @override
  _DateFieldState createState() => _DateFieldState();
}

class _DateFieldState extends State<DateField> {
  DateTime selectedDateTime = DateTime.now();

  @override
  void initState() {
    super.initState();
    _updateText(widget.initialDate);
  }

  void _updateText(DateTime dateTime) {
    selectedDateTime = dateTime;
    widget.controller.text =
        DateFormat(widget.dateFormat + ' HH:mm').format(dateTime);
    if (widget.onChanged != null) {
      widget.onChanged!(widget.controller.text);
    }
  }

  Future<void> _selectDateTime(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDateTime,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Theme.of(context).colorScheme.primary,
            colorScheme: ColorScheme.light(
              primary: Theme.of(context).colorScheme.primary,
              outline:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
            dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
            dividerColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            dividerTheme: DividerThemeData(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            ),
            textTheme: TextTheme(
              bodyMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w400),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(selectedDateTime),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
              primaryColor: Theme.of(context).colorScheme.primary,
              colorScheme: ColorScheme.light(
                primary: Theme.of(context).colorScheme.primary,
                outline: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
              ),
              dialogBackgroundColor: Theme.of(context).scaffoldBackgroundColor,
              dividerColor:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
              dividerTheme: DividerThemeData(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.3),
              ),
              textTheme: TextTheme(
                bodyMedium: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.w400),
              ),
            ),
            child: child!,
          );
        },
      );

      if (pickedTime != null) {
        DateTime combinedDateTime = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          pickedTime.hour,
          pickedTime.minute,
        );

        setState(() {
          _updateText(combinedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return PrimaryContainer(
      radius: widget.radius,
      color: widget.color,
      height: widget.height,
      child: TextFormField(
        readOnly: true,
        style: Theme.of(context).textTheme.titleMedium!.copyWith(
            color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        controller: widget.controller,
        textAlignVertical: TextAlignVertical.center,
        onTap: () => _selectDateTime(context),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 20, right: 20, bottom: 3),
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.2),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.cornerRadius * 0.5),
            ),
          ),
          filled: false,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.2),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.cornerRadius * 0.5),
            ),
          ),
          errorBorder: OutlineInputBorder(
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
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 0.2),
            borderRadius: const BorderRadius.all(
              Radius.circular(AppConstants.cornerRadius * 0.5),
            ),
          ),
          hintText: widget.dateFormat.toUpperCase(),
          suffixIcon: const Icon(Icons.calendar_today),
          hintStyle: Theme.of(context).textTheme.titleMedium!.copyWith(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }
}

String formatDateTimeForAPI(DateTime dateTime) {
  DateFormat apiFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSSZ");
  return apiFormat.format(dateTime.toUtc());
}

class PrimaryContainer extends StatelessWidget {
  final Widget child;
  final double radius;
  final Color? color;
  final double height;

  const PrimaryContainer({
    super.key,
    required this.child,
    this.radius = 10.0,
    this.color,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.04),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.cornerRadius * 0.2),
      ),
      child: child,
    );
  }
}
