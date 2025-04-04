// Events
import 'package:equatable/equatable.dart';

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
