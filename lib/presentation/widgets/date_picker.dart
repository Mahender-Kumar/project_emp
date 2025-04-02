import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:project_emp/extensions/time_extensions.dart';
import 'package:project_emp/presentation/widgets/custom.dart';
import 'package:project_emp/presentation/widgets/test.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

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
        // showCustomDatePicker(context, DateTime.now(), (selectedDate) {
        //   print("Selected Date: ${selectedDate.toLocal()}");
        // });
        final DateTime? picked = await myShowDatePicker(
          context: context,
          initialDate: initialDate,
          firstDate: minDate ?? DateTime(1950),
          lastDate: maxDate ?? DateTime(2101),
          initialDatePickerMode: DatePickerMode.day,
          initialEntryMode: DatePickerEntryMode.calendar,
          builder: (contex, child) {
            return Theme(
              data: Theme.of(context).copyWith(
                datePickerTheme: DatePickerThemeData(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      12,
                    ), // Adjust the radius as needed
                  ),
                  cancelButtonStyle: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  confirmButtonStyle: ButtonStyle(
                    shape: WidgetStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                listTileTheme: ListTileThemeData(dense: true),
                primaryColor: Colors.blue,
                // accentColor: Colors.blue,
                colorScheme: Theme.of(
                  context,
                ).colorScheme.copyWith(primary: Colors.blue),
                buttonTheme: const ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );
        if (picked != null) {
          final DateTime dateTime = DateTime(
            picked.year,
            picked.month,
            picked.day,
            12,
            0,
          );
          controller.text = (dateTime).toFormattedDatetimeString();
          onDateTimeSelected(dateTime);
        }
      },
    );
  }
}
