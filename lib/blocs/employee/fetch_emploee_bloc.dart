import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:project_emp/blocs/employee/employee_event.dart';
import 'package:project_emp/blocs/employee/employee_state.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';

// Bloc Implementation
class FetchEmployeeBloc extends HydratedBloc<EmployeeEvent, EmployeeState> {
  final FirestoreService firestoreService = FirestoreService();

  FetchEmployeeBloc() : super(EmployeeInitial()) {
    on<LoadEmployees>(_fetchEmployees);
    on<UpdateEmployeesEvent>(
      (event, emit) => emit(EmployeeSuccess(event.employees)),
    );
  }

  Future<void> _fetchEmployees(
    LoadEmployees event,
    Emitter<EmployeeState> emit,
  ) async {
    try {
      emit(EmployeeLoading());

      await emit.forEach(
        firestoreService.getEmployees(),
        onData: (snapshot) {
          final employees =
              snapshot.docs.map((doc) {
                return Employee.fromMap(doc.data());
              }).toList();

          return EmployeeSuccess(employees);
        },
        onError: (error, stackTrace) => EmployeeFailure(error.toString()),
      );
    } catch (e) {
      emit(EmployeeFailure(e.toString()));
    }
  }

  @override
  EmployeeState? fromJson(Map<String, dynamic> json) {
    try {
      final employees =
          (json['employees'] as List).map((e) => Employee.fromMap(e)).toList();
      return EmployeeSuccess(employees);
    } catch (_) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(EmployeeState state) {
    if (state is EmployeeSuccess) {
      return {'employees': state.employees.map((e) => e.toMap()).toList()};
    }
    return null;
  }
}
