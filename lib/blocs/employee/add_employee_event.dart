import 'package:equatable/equatable.dart';
import 'package:project_emp/data/models/todo_model.dart';

abstract class EmployeeEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddEmployeeEvent extends EmployeeEvent {
  final Employee employee;

  AddEmployeeEvent(this.employee);

  @override
  List<Object> get props => [employee];
}
