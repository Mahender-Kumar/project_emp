import 'package:equatable/equatable.dart';
import 'package:project_emp/data/models/employee_model.dart';

abstract class EmployeeState extends Equatable {
  const EmployeeState();
  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {
  final List<Employee> employees;

  const EmployeeSuccess(this.employees);

  @override
  List<Object> get props => [employees];
}

class EmployeeFailure extends EmployeeState {
  final String error;

  const EmployeeFailure(this.error);

  @override
  List<Object> get props => [error];
}
