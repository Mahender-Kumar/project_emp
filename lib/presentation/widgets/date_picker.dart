import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:project_emp/presentation/widgets/test3.dart';

class DatePicker extends StatelessWidget {
  final String? label;
  final TextEditingController controller;
  final bool? validate;
  final dynamic maxDate;
  final dynamic minDate;
  final dynamic initialDate;
  final bool enable;
  final bool isDense;
  final void Function(DateTime) onDateTimeSelected;
  final bool showTodayButton;
  final bool showMondayButton;
  final bool showTuesdayButton;
  final bool showWednesdayButton;
  final bool showThursdayButton;
  final bool showFridayButton;
  final bool showSaturdayButton;
  final bool showOneweekAfterButton;
  final bool showSundayButton;
  final bool showNoDateButton;

  const DatePicker({
    super.key,
    this.label,
    required this.controller,
    this.validate,
    this.maxDate,
    this.minDate,
    this.initialDate,
    required this.onDateTimeSelected,
    this.enable = true,
    this.isDense = true,
    this.showTodayButton = false,
    this.showMondayButton = false,
    this.showTuesdayButton = false,
    this.showWednesdayButton = false,
    this.showThursdayButton = false,
    this.showFridayButton = false,
    this.showSaturdayButton = false,
    this.showOneweekAfterButton = false,
    this.showNoDateButton = false,
    this.showSundayButton = false,
  });

  convertDate(dynamic date) {
    if (date == null) {
      return date;
    }
    if (date is DateTime) {
      return date;
    }
    if (date is Timestamp) {
      return date.toDate();
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime? initialDate = convertDate(this.initialDate);
    DateTime? maxDate = convertDate(this.maxDate);
    DateTime? minDate = convertDate(this.minDate);
    controller.text = _controllerText(initialDate);

    return TextFormField(
      readOnly: true,
      controller: controller,
      validator:
          validate == true
              ? (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter ${label?.toLowerCase()}.';
                }
                return null;
              }
              : null,
      enabled: enable,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        isDense: isDense,
        prefixIcon: const Icon(
          Icons.calendar_today_outlined,
          // size: 8,
        ),
      ),
      onTap: () async {
        final DateTime? date = await MyDatePickerDialog.show(
          context,
          initialDate: DateTime.now(),
          minDate: minDate ?? DateTime(1950),
          maxDate: maxDate ?? DateTime(2101),
        );
        if (date != null) {
          DateTime? picked = date;
          // setState(() {
          //   selectedDate = date;
          // });

          // final DateTime? picked = await myShowDatePicker(
          //   context: context,
          //   initialDate: initialDate,
          //   firstDate: minDate ?? DateTime(1950),
          //   lastDate: maxDate ?? DateTime(2101),
          //   initialDatePickerMode: DatePickerMode.day,
          //   initialEntryMode: DatePickerEntryMode.calendar,
          //   showMondayButton: showMondayButton,
          //   showTuesdayButton: showTuesdayButton,
          //   showWednesdayButton: showWednesdayButton,
          //   showThursdayButton: showThursdayButton,
          //   showFridayButton: showFridayButton,
          //   showSaturdayButton: showSaturdayButton,
          //   showSundayButton: showSundayButton,
          //   showNoDateButton: showNoDateButton,
          //   showTodayButton: showTodayButton,
          //   showOneweekAfterButton: showOneweekAfterButton,

          //   builder: (contex, child) {
          //     return Theme(
          //       data: Theme.of(context).copyWith(
          //         datePickerTheme: DatePickerThemeData(
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(
          //               12,
          //             ), // Adjust the radius as needed
          //           ),
          //           cancelButtonStyle: ButtonStyle(
          //             shape: WidgetStatePropertyAll(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(4),
          //               ),
          //             ),
          //           ),
          //           confirmButtonStyle: ButtonStyle(
          //             shape: WidgetStatePropertyAll(
          //               RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(4),
          //               ),
          //             ),
          //           ),
          //         ),
          //         listTileTheme: ListTileThemeData(dense: true),
          //         primaryColor: Colors.blue,
          //         // accentColor: Colors.blue,
          //         colorScheme: Theme.of(
          //           context,
          //         ).colorScheme.copyWith(primary: Colors.blue),
          //         buttonTheme: const ButtonThemeData(
          //           textTheme: ButtonTextTheme.primary,
          //         ),
          //       ),
          //       child: child!,
          //     );
          //   },
          // );

          controller.text = _controllerText(picked);
          // print(picked);
          onDateTimeSelected(picked);
        }
      },
    );
  }

  String _controllerText(DateTime? dateTime) {
    if (dateTime == null || dateTime == DateTime(0)) {
      return 'No Date';
    }
    DateTime today = DateTime.now();
    DateTime onlyToday = DateTime(today.year, today.month, today.day);
    DateTime onlyDateTime = DateTime(
      dateTime.year,
      dateTime.month,
      dateTime.day,
    );
    if (onlyDateTime == onlyToday) {
      return 'Today';
    }

    int daysUntilNextMonday = (8 - today.weekday) % 7;
    int daysUntilNextTuesday = (9 - today.weekday) % 7;

    DateTime nextMonday = onlyToday.add(Duration(days: daysUntilNextMonday));
    DateTime nextTuesday = onlyToday.add(Duration(days: daysUntilNextTuesday));
    DateTime oneWeekLater = onlyToday.add(const Duration(days: 7));
    if (onlyDateTime == nextMonday) {
      return "Next Monday";
    } else if (onlyDateTime == nextTuesday) {
      return "Next Tuesday";
    } else if (onlyDateTime == oneWeekLater) {
      return "One Week Later";
    } else {
      return onlyDateTime.toFormattedDatetimeString();
    }

    // controller.text = dateTime.toFormattedDatetimeString();
  }
}
