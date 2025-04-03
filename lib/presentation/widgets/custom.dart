import 'package:flutter/material.dart';

class CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const CustomDatePicker({
    Key? key,
    required this.initialDate,
    required this.onDateSelected,
  }) : super(key: key);

  @override
  CustomDatePickerState createState() => CustomDatePickerState();
}

class CustomDatePickerState extends State<CustomDatePicker> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text("Select a Date"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
              onDateChanged: (selectedDate) {
                setState(() => _selectedDate = selectedDate);
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            widget.onDateSelected(_selectedDate);
            Navigator.pop(context);
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}

void showCustomDatePicker(
  BuildContext context,
  DateTime initialDate,
  Function(DateTime) onDateSelected,
) {
  showDialog(
    context: context,
    builder:
        (context) => CustomDatePicker(
          initialDate: initialDate,
          onDateSelected: onDateSelected,
        ),
  );
}
