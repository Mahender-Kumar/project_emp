import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        // scaffoldBackgroundColor: Colors.grey.shade100,
      ),
      home: const ExampleUsage(),
    );
  }
}
// date_picker_cubit.dart

class DatePickerState extends Equatable {
  final DateTime selectedDate;
  final DateTime today;

  const DatePickerState({required this.selectedDate, required this.today});

  DatePickerState copyWith({DateTime? selectedDate, DateTime? today}) {
    return DatePickerState(
      selectedDate: selectedDate ?? this.selectedDate,
      today: today ?? this.today,
    );
  }

  @override
  List<Object> get props => [selectedDate, today];
}

class DatePickerCubit extends Cubit<DatePickerState> {
  DatePickerCubit()
    : super(
        DatePickerState(
          selectedDate: DateTime.now(),
          today: DateTime(
            DateTime.now().year,
            DateTime.now().month,
            DateTime.now().day,
          ),
        ),
      );

  void selectDate(DateTime date) {
    emit(state.copyWith(selectedDate: date));
  }

  DateTime getNextMonday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.monday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextTuesday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.tuesday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextWeek() {
    return state.today.add(const Duration(days: 7));
  }
}

class MyDatePickerDialog extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;

  const MyDatePickerDialog({
    Key? key,
    this.initialDate,
    this.maxDate,
    this.minDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = DatePickerCubit();
        if (initialDate != null) {
          cubit.selectDate(initialDate!);
        }
        return cubit;
      },
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: DatePickerContent(
          minDate: minDate,
          maxDate: maxDate,
          initialDate: initialDate,
        ),
      ),
    );
  }

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
  }) async {
    return showDialog<DateTime>(
      context: context,
      builder:
          (context) => MyDatePickerDialog(
            initialDate: initialDate,
            minDate: minDate,
            maxDate: maxDate,
          ),
    );
  }
}

class DatePickerContent extends StatelessWidget {
  DatePickerContent({
    Key? key,
    this.initialDate,
    this.minDate,
    this.maxDate,
    this.onTodayPressed,
    this.onNextMondayPressed,
    this.onNextTuesdayPressed,
    this.onNextWednesdayPressed,
    this.onNextThursdayPressed,
    this.onNextFridayPressed,
    this.onNextSaturdayPressed,
    this.onNextSundayPressed,
    this.onAfterOneWeekPressed,
    this.onNoDatePressed,
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
  }) : super(key: key);

  final VoidCallback? onTodayPressed;
  final VoidCallback? onNextMondayPressed;
  final VoidCallback? onNextTuesdayPressed;
  final VoidCallback? onNextWednesdayPressed;
  final VoidCallback? onNextThursdayPressed;
  final VoidCallback? onNextFridayPressed;
  final VoidCallback? onNextSaturdayPressed;
  final VoidCallback? onNextSundayPressed;

  final VoidCallback? onAfterOneWeekPressed;
  final VoidCallback? onNoDatePressed;
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
  final DateTime? minDate;
  final DateTime? maxDate;
  final DateTime? initialDate;
  Widget _buildButton(
    String text,
    VoidCallback? onPressed,
    bool isVisible,
    context,
  ) {
    return Expanded(
      child:
          isVisible
              ? TextButton(
                style: ButtonStyle(
                  // backgroundColor: WidgetStatePropertyAll(
                  //   Theme.of(context).colorScheme.onSecondary,
                  // ),
                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                onPressed: onPressed,
                child: Text(text),
              )
              : const SizedBox(), // Empty space when button is not visible
    );
  }

  GlobalKey calendarKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<Widget> buttonRows = [];

    if (showTodayButton == true) {
      buttonRows.add(
        _buildButton('Today', onTodayPressed, showTodayButton == true, context),
      );
    }
    if (showMondayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Monday',
          onNextMondayPressed,
          showMondayButton == true,
          context,
        ),
      );
    }

    // Row 2: Next Tuesday and After 1 Week
    if (showTuesdayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Tuesday',
          onNextTuesdayPressed,
          showTuesdayButton == true,
          context,
        ),
      );
    }
    if (showOneweekAfterButton == true) {
      buttonRows.add(
        _buildButton(
          'After 1 Week',
          onAfterOneWeekPressed,
          showOneweekAfterButton == true,
          context,
        ),
      );
    }

    // Row 3: Next Wednesday and Next Thursday
    if (showWednesdayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Wednesday',
          onNextWednesdayPressed,
          showWednesdayButton == true,
          context,
        ),
      );
    }
    if (showThursdayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Thursday',
          onNextThursdayPressed,
          showThursdayButton == true,
          context,
        ),
      );
    }

    // Row 4: Next Friday and Next Saturday
    if (showFridayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Friday',
          onNextFridayPressed,
          showFridayButton == true,
          context,
        ),
      );
    }
    if (showSaturdayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Saturday',
          onNextSaturdayPressed,
          showSaturdayButton == true,
          context,
        ),
      );
    }
    if (showSundayButton == true) {
      buttonRows.add(
        _buildButton(
          'Next Sunday',
          onNextSundayPressed,
          showSundayButton == true,
          context,
        ),
      );
    }
    if (showNoDateButton == true) {
      buttonRows.add(
        _buildButton(
          'No Date',
          onNoDatePressed,
          showNoDateButton == true,
          context,
        ),
      );
    }

    return BlocBuilder<DatePickerCubit, DatePickerState>(
      builder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                // color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                spreadRadius: 1,
              ),
            ],
            // border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Quick selection buttons
              for (int i = 0; i < buttonRows.length; i += 2) ...[
                if (i > 0) const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    buttonRows[i],
                    SizedBox(width: 8),
                    if (i + 1 < buttonRows.length)
                      buttonRows[i + 1] // Prevent out-of-range
                    else
                      Expanded(child: Container()),
                  ],
                ),
              ],
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _quickDateButton(
                        context,
                        "Today",
                        state.today,
                        state.selectedDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickDateButton(
                        context,
                        "Next Monday",
                        context.read<DatePickerCubit>().getNextMonday(),
                        state.selectedDate,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _quickDateButton(
                        context,
                        "Next Tuesday",
                        context.read<DatePickerCubit>().getNextTuesday(),
                        state.selectedDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _quickDateButton(
                        context,
                        "After 1 week",
                        context.read<DatePickerCubit>().getNextWeek(),
                        state.selectedDate,
                      ),
                    ),
                  ],
                ),
              ),

              // Built-in Calendar DatePicker
              CalendarDatePicker(
                key: calendarKey,
                initialDate: state.selectedDate,
                firstDate: minDate ?? DateTime(2020),
                lastDate: maxDate ?? DateTime(2030),
                onDateChanged: (DateTime newDate) {
                  context.read<DatePickerCubit>().selectDate(newDate);
                },
                currentDate: state.selectedDate,
              ),

              // Resolution indicator
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    // color: Colors.purple.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text("396 Hug × 472 Hug"),
                ),
              ),

              // Bottom bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('d MMM yyyy').format(state.selectedDate),
                      style: const TextStyle(fontSize: 16),
                    ),
                    const Spacer(),
                    TextButton(
                      child: const Text("Cancel"),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: const Text("Save"),
                      onPressed:
                          () => Navigator.of(context).pop(state.selectedDate),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _quickDateButton(
    BuildContext context,
    String text,
    DateTime date,
    DateTime selectedDate,
  ) {
    final bool isSelected =
        date.day == selectedDate.day &&
        date.month == selectedDate.month &&
        date.year == selectedDate.year;

    return GestureDetector(
      onTap: () {
        context.read<DatePickerCubit>().selectDate(date);
        calendarKey = GlobalKey();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          // color:
          //     isSelected
          //         ? Colors.blue.withOpacity(0.1)
          //         : Colors.blue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.blue,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

class ExampleUsage extends StatefulWidget {
  const ExampleUsage({Key? key}) : super(key: key);

  @override
  State<ExampleUsage> createState() => _ExampleUsageState();
}

class _ExampleUsageState extends State<ExampleUsage> {
  DateTime? selectedDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Date Picker Example')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              selectedDate != null
                  ? 'Selected date: ${DateFormat('d MMM yyyy').format(selectedDate!)}'
                  : 'No date selected',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final DateTime? date = await MyDatePickerDialog.show(
                  context,
                  initialDate: selectedDate,
                  minDate: DateTime(2020),
                  maxDate: DateTime(2030),
                );
                if (date != null) {
                  setState(() {
                    selectedDate = date;
                  });
                }
              },
              child: const Text('Select Date'),
            ),
          ],
        ),
      ),
    );
  }
}

// To use this in your app, add these dependencies to pubspec.yaml:
// dependencies:
//   flutter_bloc: ^8.1.3
//   equatable: ^2.0.5
//   intl: ^0.18.1
// class DatePickerScreen extends StatefulWidget {
//   const DatePickerScreen({Key? key}) : super(key: key);

//   @override
//   State<DatePickerScreen> createState() => _DatePickerScreenState();
// }

// class _DatePickerScreenState extends State<DatePickerScreen> {
//   DateTime selectedDate = DateTime(2023, 9, 5);
//   final DateTime today = DateTime(2023, 9, 4);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Container(
//           margin: const EdgeInsets.all(20),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.1),
//                 blurRadius: 10,
//                 spreadRadius: 1,
//               ),
//             ],
//             border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               // Quick selection buttons
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(child: _quickDateButton("Today", today)),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: _quickDateButton("Next Monday", _getNextMonday()),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 12,
//                   vertical: 8,
//                 ),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           _quickDateButton("Next Tuesday", _getNextTuesday()),
//                           Positioned(
//                             right: -5,
//                             top: -5,
//                             child: Container(
//                               width: 24,
//                               height: 24,
//                               decoration: const BoxDecoration(
//                                 color: Colors.green,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "3",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const SizedBox(width: 12),
//                     Expanded(
//                       child: Stack(
//                         clipBehavior: Clip.none,
//                         children: [
//                           _quickDateButton(
//                             "After 1 week",
//                             today.add(const Duration(days: 7)),
//                           ),
//                           Positioned(
//                             right: -5,
//                             top: -5,
//                             child: Container(
//                               width: 24,
//                               height: 24,
//                               decoration: const BoxDecoration(
//                                 color: Colors.pink,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: const Center(
//                                 child: Text(
//                                   "6",
//                                   style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               // Built-in Calendar DatePicker
//               CalendarDatePicker(
//                 initialDate: selectedDate,
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime(2030),
//                 onDateChanged: (DateTime newDate) {
//                   setState(() {
//                     selectedDate = newDate;
//                   });
//                 },
//                 currentDate: selectedDate,
//               ),

//               // Resolution indicator
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8),
//                 child: Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 8,
//                     vertical: 4,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.purple.withOpacity(0.2),
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: const Text("396 Hug × 472 Hug"),
//                 ),
//               ),

//               // Bottom bar
//               Container(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(Icons.calendar_today, color: Colors.blue),
//                     const SizedBox(width: 8),
//                     Text(
//                       DateFormat('d MMM yyyy').format(selectedDate),
//                       style: const TextStyle(fontSize: 16),
//                     ),
//                     const Spacer(),
//                     TextButton(child: const Text("Cancel"), onPressed: () {}),
//                     const SizedBox(width: 8),
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         // primary: Colors.blue,
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 24,
//                           vertical: 12,
//                         ),
//                       ),
//                       child: const Text("Save"),
//                       onPressed: () {},
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   DateTime _getNextMonday() {
//     DateTime date = today;
//     while (date.weekday != DateTime.monday) {
//       date = date.add(const Duration(days: 1));
//     }
//     return date;
//   }

//   DateTime _getNextTuesday() {
//     DateTime date = today;
//     while (date.weekday != DateTime.tuesday) {
//       date = date.add(const Duration(days: 1));
//     }
//     return date;
//   }

//   Widget _quickDateButton(String text, DateTime date) {
//     final bool isSelected =
//         date.day == selectedDate.day &&
//         date.month == selectedDate.month &&
//         date.year == selectedDate.year;

//     return GestureDetector(
//       onTap: () {
//         setState(() {
//           selectedDate = date;
//         });
//       },
//       child: Container(
//         padding: const EdgeInsets.symmetric(vertical: 12),
//         decoration: BoxDecoration(
//           color:
//               isSelected
//                   ? Colors.blue.withOpacity(0.1)
//                   : Colors.blue.withOpacity(0.05),
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: Center(
//           child: Text(
//             text,
//             style: TextStyle(
//               color: Colors.blue,
//               fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
