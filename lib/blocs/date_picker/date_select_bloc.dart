// employee_dates_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/date_picker/date_select_event.dart';
import 'package:project_emp/blocs/date_picker/date_select_state.dart';



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