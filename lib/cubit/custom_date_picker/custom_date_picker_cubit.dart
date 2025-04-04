
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/cubit/custom_date_picker/custom_date_picker_state.dart';

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

  void selectDate(DateTime? date) {
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

    void clearDate() {
    emit(state.copyWith(selectedDate: null));
  }
}
