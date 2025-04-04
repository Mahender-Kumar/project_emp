import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  DateTime? convertDate(dynamic date) {
    if (date == null) {
      return null;
    }
    if (date is DateTime) {
      return date;
    }
    if (date is Timestamp) {
      return date.toDate();
    }
    // Try to parse string if it's not null and not empty
    if (date is String && date.isNotEmpty && date != 'No Date') {
      try {
        return DateTime.parse(date);
      } catch (e) {
        // Could not parse the date string
        return null;
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    DateTime? initDate = convertDate(this.initialDate);
    DateTime? max = convertDate(this.maxDate);
    DateTime? min = convertDate(this.minDate);

    // Set controller text based on initialDate
    controller.text = _controllerText(initDate);

    return TextFormField(
      readOnly: true,
      controller: controller,
      validator:
          validate == true
              ? (value) {
                if (value == null || value.isEmpty || value == 'No Date') {
                  return 'Please enter ${label?.toLowerCase() ?? "date"}.';
                }
                return null;
              }
              : null,
      enabled: enable,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        labelText: label,
        isDense: isDense,
        prefixIcon: const Icon(Icons.calendar_today_outlined),
      ),
      onTap: () async {
        final DateTime? date = await MyDatePickerDialog.show(
          context,
          initialDate: initDate,
          minDate: min ?? DateTime(1950),
          maxDate: max ?? DateTime(2101),
          showTodayButton: showTodayButton,
          showMondayButton: showMondayButton,
          showTuesdayButton: showTuesdayButton,
          showWednesdayButton: showWednesdayButton,
          showThursdayButton: showThursdayButton,
          showFridayButton: showFridayButton,
          showSaturdayButton: showSaturdayButton,
          showSundayButton: showSundayButton,
          showNoDateButton: showNoDateButton,
          showOneweekAfterButton: showOneweekAfterButton,
        );

        if (date != null) {
          controller.text = _controllerText(date);
          onDateTimeSelected(date);
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
      // Assuming toFormattedDatetimeString() exists in extensions
      try {
        return onlyDateTime.toFormattedDatetimeString();
      } catch (e) {
        // Fallback if extension method isn't available
        return DateFormat.yMMMd().format(dateTime);
      }
    }
  }
}
