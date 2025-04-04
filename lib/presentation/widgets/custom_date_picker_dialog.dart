import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/cubit/custom_date_picker/custom_date_picker_cubit.dart';
import 'package:project_emp/cubit/custom_date_picker/custom_date_picker_state.dart';

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
      barrierDismissible: false,
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
              state.selectedDate!,
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
              state.selectedDate!,
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
              state.selectedDate!,
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
              state.selectedDate!,
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
              state.selectedDate!,
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

              state.selectedDate!,
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

              state.selectedDate!,
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

              state.selectedDate!,
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

              state.selectedDate!,
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
                          DateFormat(
                            'd MMM yyyy',
                          ).format(state.selectedDate ?? DateTime.now()),
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
                          onPressed: () {
                            if (!showNoDateButton) {
                              Navigator.of(context).pop(DateTime.now());
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
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
    DateTime? selectedDate,
  ) {
    return OutlinedButton(
      style: ButtonStyle(
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        ),
      ),
      onPressed: () {
        context.read<DatePickerCubit>().clearDate();
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
