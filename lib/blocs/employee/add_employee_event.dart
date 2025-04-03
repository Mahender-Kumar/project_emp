import 'package:equatable/equatable.dart';
import 'package:project_emp/data/models/employee_model.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object> get props => [];
}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}

class LoadEmployees extends EmployeeEvent {}

class UpdateEmployeesEvent extends EmployeeEvent {
  final List<Employee> employees;
  UpdateEmployeesEvent(this.employees);

  @override
  List<Object> get props => [employees];
}

class UpdateEmployeeEvent extends EmployeeEvent {
  final Employee employee;
  UpdateEmployeeEvent(this.employee);
  @override
  List<Object> get props => [employee];
}
