import 'package:equatable/equatable.dart';

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
