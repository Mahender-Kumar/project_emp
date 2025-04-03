import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:project_emp/data/models/employee_model.dart';
import 'package:project_emp/presentation/services/firestore_service.dart';

// Bloc Events
abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoadEmployees extends EmployeeEvent {}

class UpdateEmployees extends EmployeeEvent {
  final List<Employee> employees;
  UpdateEmployees(this.employees);

  @override
  List<Object> get props => [employees];
}

// Bloc States
abstract class EmployeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<Employee> employees;
  EmployeeSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeFailure extends EmployeeState {
  final String error;
  EmployeeFailure(this.error);

  @override
  List<Object> get props => [error];
}

// Bloc Implementation
class EmployeeBloc extends HydratedBloc<EmployeeEvent, EmployeeState> {
  final FirestoreService firestoreService = FirestoreService();

  EmployeeBloc() : super(EmployeeInitial()) {
    on<LoadEmployees>(_fetchEmployees);
    on<UpdateEmployees>(
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
