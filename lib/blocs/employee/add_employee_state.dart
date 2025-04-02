import 'package:equatable/equatable.dart';
import 'package:project_emp/data/models/employee_model.dart';
 

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
