// employee_dates_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class EmployeeDatesEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class HireDateChanged extends EmployeeDatesEvent {
  final DateTime hireDate;

  HireDateChanged(this.hireDate);

  @override
  List<Object?> get props => [hireDate];
}

class LeavingDateChanged extends EmployeeDatesEvent {
  final DateTime? leavingDate;

  LeavingDateChanged(this.leavingDate);

  @override
  List<Object?> get props => [leavingDate];
}

// State
class EmployeeDatesState extends Equatable {
  final DateTime hireDate;
  final DateTime? leavingDate;

  const EmployeeDatesState({
    required this.hireDate,
    this.leavingDate,
  });

  EmployeeDatesState copyWith({
    DateTime? hireDate,
    DateTime? leavingDate,
    bool clearLeavingDate = false,
  }) {
    return EmployeeDatesState(
      hireDate: hireDate ?? this.hireDate,
      leavingDate: clearLeavingDate ? null : (leavingDate ?? this.leavingDate),
    );
  }

  @override
  List<Object?> get props => [hireDate, leavingDate];
}

// BLoC
class EmployeeDatesBloc extends Bloc<EmployeeDatesEvent, EmployeeDatesState> {
  EmployeeDatesBloc({required DateTime initialHireDate, DateTime? initialLeavingDate})
      : super(EmployeeDatesState(
          hireDate: initialHireDate,
          leavingDate: initialLeavingDate,
        )) {
    on<HireDateChanged>(_onHireDateChanged);
    on<LeavingDateChanged>(_onLeavingDateChanged);
  }

  void _onHireDateChanged(
    HireDateChanged event,
    Emitter<EmployeeDatesState> emit,
  ) {
    final newHireDate = event.hireDate;
    
    // Check if leaving date needs to be reset
    final needToResetLeavingDate = state.leavingDate != null && 
        newHireDate.isAfter(state.leavingDate!);
    
    emit(state.copyWith(
      hireDate: newHireDate,
      clearLeavingDate: needToResetLeavingDate,
    ));
  }

  void _onLeavingDateChanged(
    LeavingDateChanged event,
    Emitter<EmployeeDatesState> emit,
  ) {
    emit(state.copyWith(leavingDate: event.leavingDate));
  }
}