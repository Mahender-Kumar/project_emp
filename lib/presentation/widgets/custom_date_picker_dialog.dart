import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_emp/core/constants/constants.dart';

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

  DateTime getNextWednesday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.wednesday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextThursday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.thursday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextFriday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.friday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextSaturday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.saturday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextSunday() {
    DateTime date = state.today;
    while (date.weekday != DateTime.sunday) {
      date = date.add(const Duration(days: 1));
    }
    return date;
  }

  DateTime getNextWeek() {
    return state.today.add(const Duration(days: 7));
  }

  DateTime? noDate() {
    return null;
  }

  bool isDateValid(DateTime date, DateTime? minDate, DateTime? maxDate) {
    if (minDate != null && date.isBefore(minDate)) {
      return false;
    }
    if (maxDate != null && date.isAfter(maxDate)) {
      return false;
    }
    return true;
  }
}

class MyDatePickerDialog extends StatelessWidget {
  final DateTime? initialDate;
  final DateTime? minDate;
  final DateTime? maxDate;
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

  MyDatePickerDialog({
    super.key,
    this.initialDate,
    this.maxDate,
    this.minDate,
    required this.showTodayButton,
    required this.showMondayButton,
    required this.showTuesdayButton,
    required this.showWednesdayButton,
    required this.showThursdayButton,
    required this.showFridayButton,
    required this.showSaturdayButton,
    required this.showOneweekAfterButton,
    required this.showNoDateButton,
    required this.showSundayButton,
  });

  final Size _calendarPortraitDialogSizeM3 = Size(360.0, 512.0);

  @override
  Widget build(BuildContext context) {
    final double textScaleFactor =
        MediaQuery.textScalerOf(
          context,
        ).clamp(maxScaleFactor: kMaxTextScaleFactor).scale(fontSizeToScale) /
        fontSizeToScale;
    final Size dialogSize = _calendarPortraitDialogSizeM3 * textScaleFactor;
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
        child: AnimatedContainer(
          constraints: BoxConstraints(
            maxWidth: dialogSize.width,
            maxHeight: dialogSize.height,
          ),
          duration: dialogSizeAnimationDuration,
          curve: Curves.easeIn,
          child: MediaQuery.withClampedTextScaling(
            maxScaleFactor: kMaxTextScaleFactor,

            child: DatePickerContent(
              minDate: minDate,
              maxDate: maxDate,
              initialDate: initialDate,
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
            ),
          ),
        ),
      ),
    );
  }

  static Future<DateTime?> show(
    BuildContext context, {
    DateTime? initialDate,
    DateTime? minDate,
    DateTime? maxDate,
    bool? showTodayButton,
    bool? showMondayButton,
    bool? showTuesdayButton,
    bool? showWednesdayButton,
    bool? showThursdayButton,
    bool? showFridayButton,
    bool? showSaturdayButton,
    bool? showOneweekAfterButton,
    bool? showSundayButton,
    bool? showNoDateButton,
  }) async {
    // print("Show Date Picker Dialog: $showTodayButton");
    return showDialog<DateTime>(
      context: context,
      builder:
          (context) => MyDatePickerDialog(
            initialDate: initialDate,
            minDate: minDate,
            maxDate: maxDate,
            showTodayButton: showTodayButton ?? false,
            showMondayButton: showMondayButton ?? false,
            showTuesdayButton: showTuesdayButton ?? false,
            showWednesdayButton: showWednesdayButton ?? false,
            showThursdayButton: showThursdayButton ?? false,
            showFridayButton: showFridayButton ?? false,
            showSaturdayButton: showSaturdayButton ?? false,
            showSundayButton: showSundayButton ?? false,
            showNoDateButton: showNoDateButton ?? false,
            showOneweekAfterButton: showOneweekAfterButton ?? false,
          ),
    );
  }
}

// ignore: must_be_immutable
class DatePickerContent extends StatelessWidget {
  DatePickerContent({
    super.key,
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
    required this.showTodayButton,
    required this.showMondayButton,
    required this.showTuesdayButton,
    required this.showWednesdayButton,
    required this.showThursdayButton,
    required this.showFridayButton,
    required this.showSaturdayButton,
    required this.showOneweekAfterButton,
    required this.showNoDateButton,
    required this.showSundayButton,
  });

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

  

  GlobalKey calendarKey = GlobalKey();
  bool _isDateValid(DateTime date) {
    if (minDate != null && date.isBefore(minDate!)) {
      return false;
    }
    if (maxDate != null && date.isAfter(maxDate!)) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // print(showTodayButton);
    return BlocBuilder<DatePickerCubit, DatePickerState>(
      builder: (context, state) {
        final DatePickerCubit cubit = context.read<DatePickerCubit>();

        final DateTime today = state.today;
        final DateTime nextMonday = cubit.getNextMonday();
        final DateTime nextTuesday = cubit.getNextTuesday();
        final DateTime nextWeek = cubit.getNextWeek();

        // Calculate dates for other weekdays if needed
        DateTime nextWednesday = today;
        while (nextWednesday.weekday != DateTime.wednesday) {
          nextWednesday = nextWednesday.add(const Duration(days: 1));
        }

        DateTime nextThursday = today;
        while (nextThursday.weekday != DateTime.thursday) {
          nextThursday = nextThursday.add(const Duration(days: 1));
        }

        DateTime nextFriday = today;
        while (nextFriday.weekday != DateTime.friday) {
          nextFriday = nextFriday.add(const Duration(days: 1));
        }

        DateTime nextSaturday = today;
        while (nextSaturday.weekday != DateTime.saturday) {
          nextSaturday = nextSaturday.add(const Duration(days: 1));
        }

        DateTime nextSunday = today;
        while (nextSunday.weekday != DateTime.sunday) {
          nextSunday = nextSunday.add(const Duration(days: 1));
        }

        // Check if dates are valid according to min/max constraints
        final bool isTodayValid = _isDateValid(today);
        final bool isNextMondayValid = _isDateValid(nextMonday);
        final bool isNextTuesdayValid = _isDateValid(nextTuesday);
        final bool isNextWednesdayValid = _isDateValid(nextWednesday);
        final bool isNextThursdayValid = _isDateValid(nextThursday);
        final bool isNextFridayValid = _isDateValid(nextFriday);
        final bool isNextSaturdayValid = _isDateValid(nextSaturday);
        final bool isNextSundayValid = _isDateValid(nextSunday);
        final bool isNextWeekValid = _isDateValid(nextWeek);

        List<Widget> buttonRows = [];

        if (showTodayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Today',
              state.today,
              state.selectedDate,
              isTodayValid,
            ),
          );
        }
        if (showMondayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              "Next Monday",
              context.read<DatePickerCubit>().getNextMonday(),
              state.selectedDate,
              isNextMondayValid,
            ),
          );
        }

        // Row 2: Next Tuesday and After 1 Week
        if (showTuesdayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              "Next Tuesday",
              context.read<DatePickerCubit>().getNextTuesday(),
              state.selectedDate,
              isNextTuesdayValid,
            ),
          );
        }
        if (showOneweekAfterButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              "After 1 week",
              context.read<DatePickerCubit>().getNextWeek(),
              state.selectedDate,
              isNextWeekValid,
            ),
          );
        }

        if (showWednesdayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Next Wednesday',
              context.read<DatePickerCubit>().getNextWednesday(),
              state.selectedDate,
              isNextWednesdayValid,
            ),
          );
        }
        if (showThursdayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Next Thursday',
              context.read<DatePickerCubit>().getNextThursday(),

              state.selectedDate,
              isNextThursdayValid,
            ),
          );
        }

        // Row 4: Next Friday and Next Saturday
        if (showFridayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Next Friday',
              context.read<DatePickerCubit>().getNextFriday(),

              state.selectedDate,
              isNextFridayValid,
            ),
          );
        }
        if (showSaturdayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Next Saturday',
              context.read<DatePickerCubit>().getNextSaturday(),

              state.selectedDate,
              isNextSaturdayValid,
            ),
          );
        }
        if (showSundayButton == true) {
          buttonRows.add(
            _quickDateButton(
              context,
              'Next Sunday',
              context.read<DatePickerCubit>().getNextSunday(),

              state.selectedDate,
              isNextSundayValid,
            ),
          );
        }
        if (showNoDateButton == true) {
          buttonRows.add(
            _buildNoDateButton(context, 'No Date', state.selectedDate),
          );
        }
        final double currentScale =
            MediaQuery.textScalerOf(context).scale(fontSizeToScale) /
            fontSizeToScale;
        final double maxHeaderTextScaleFactor = math.min(
          currentScale,

          kMaxHeaderWithEntryTextScaleFactor,
        );
        final double textScaleFactor =
            MediaQuery.textScalerOf(context)
                .clamp(maxScaleFactor: maxHeaderTextScaleFactor)
                .scale(fontSizeToScale) /
            fontSizeToScale;
        final double headerScaleFactor =
            textScaleFactor > 1 ? textScaleFactor : 1.0;

        // print("Button Rows: ${buttonRows.length}");
        final double fontScaleAdjustedHeaderHeight =
            headerScaleFactor > 1.3 ? headerScaleFactor - 0.2 : 1.0;
        return Container(
          decoration: BoxDecoration(
            // color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              // BoxShadow(
              //   // color: Colors.black.withOpacity(0.1),
              //   // blurRadius: 10,
              //   spreadRadius: 1,
              // ),
            ],
            // border: Border.all(color: Colors.purple.withOpacity(0.5), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Quick selection buttons
                Container(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  constraints: BoxConstraints(
                    maxHeight:
                        datePickerHeaderPortraitHeight *
                        fontScaleAdjustedHeaderHeight,
                  ),

                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,

                      children: [
                        for (int i = 0; i < buttonRows.length; i += 2) ...[
                          if (i > 0) const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Expanded(child: buttonRows[i]),
                                SizedBox(width: 12),
                                if (i + 1 < buttonRows.length)
                                  Expanded(
                                    child: buttonRows[i + 1],
                                  ) // Prevent out-of-range
                                else
                                  Expanded(child: Container()),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),

                // Built-in Calendar DatePicker
                CalendarDatePicker(
                  key: calendarKey,
                  initialDate: initialDate,
                  firstDate: minDate ?? DateTime(2020),
                  lastDate: maxDate ?? DateTime(2030),
                  onDateChanged: (DateTime newDate) {
                    context.read<DatePickerCubit>().selectDate(newDate);
                  },
                  currentDate: state.selectedDate,
                ),

                // Bottom bar
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today, size: defaultIconSize),
                        const SizedBox(width: 8),
                        Text(
                          DateFormat('d MMM yyyy').format(state.selectedDate),
                          style: const TextStyle(fontSize: 16),
                        ),
                        const Spacer(),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(btnRadius),
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.titleSmall?.color,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(btnRadius),
                            ),
                          ),
                          child: const Text("Save"),
                          onPressed:
                              () =>
                                  Navigator.of(context).pop(state.selectedDate),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoDateButton(
    BuildContext context,
    String text,
    DateTime selectedDate,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      onPressed: () {
        // When pressed, return null through the Navigator
        Navigator.of(context).pop(null);
      },
      child: Text(text),
    );
  }

  Widget _quickDateButton(
    BuildContext context,
    String text,
    DateTime date,
    DateTime selectedDate,
    bool isEnabled,
  ) {
    // final bool isSelected =
    //     date.day == selectedDate.day &&
    //     date.month == selectedDate.month &&
    //     date.year == selectedDate.year;

    return OutlinedButton(
      style: ButtonStyle(
        // backgroundColor: WidgetStatePropertyAll(
        //   Theme.of(context).colorScheme.onSecondary,
        // ),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      onPressed:
          isEnabled
              ? () {
                context.read<DatePickerCubit>().selectDate(date);
                calendarKey = GlobalKey();
              }
              : null,
      child: Text(text),
    );
  }
}

class ExampleUsage extends StatefulWidget {
  const ExampleUsage({super.key});

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
