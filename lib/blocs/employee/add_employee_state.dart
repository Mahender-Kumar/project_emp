import 'package:equatable/equatable.dart';

abstract class EmployeeState extends Equatable {
  @override
  List<Object> get props => [];
}

class EmployeeInitial extends EmployeeState {}

class EmployeeLoading extends EmployeeState {}

class EmployeeSuccess extends EmployeeState {}

class EmployeeFailure extends EmployeeState {
  final String error;

  EmployeeFailure(this.error);

  @override
  List<Object> get props => [error];
}
