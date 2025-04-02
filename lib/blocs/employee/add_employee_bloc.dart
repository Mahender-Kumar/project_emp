import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/employee/add_employee_event.dart';
import 'package:project_emp/blocs/employee/add_employee_state.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';
import 'package:project_emp/services/generate_tags.dart';

class AddEmployeeBloc extends Bloc<EmployeeEvent, EmployeeState> {
  final FirestoreService _firestoreService;

  AddEmployeeBloc(this._firestoreService) : super(EmployeeInitial()) {
    on<AddEmployeeEvent>(_onAddTodo);
  }

  Future<void> _onAddTodo(
    AddEmployeeEvent event,
    Emitter<EmployeeState> emit,
  ) async {
    emit(EmployeeLoading());

    try {
      await _firestoreService.saveEmployee(
        event.employee,
        tags: generateTags(event.employee.name),
      );
      // emit(EmployeeSuccess());
    } catch (e) {
      emit(EmployeeFailure(e.toString()));
    }
  }
}
