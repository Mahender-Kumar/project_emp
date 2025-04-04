// State
import 'package:equatable/equatable.dart';

class EmployeeDatesState extends Equatable {
  final DateTime hireDate;
  final DateTime? leavingDate;

  const EmployeeDatesState({required this.hireDate, this.leavingDate});

  EmployeeDatesState copyWith({
    DateTime? hireDate,
    DateTime? leavingDate,
    bool clearLeavingDate = true,
  }) {
    return EmployeeDatesState(
      hireDate: hireDate ?? this.hireDate,
      leavingDate: clearLeavingDate ? null : (leavingDate ?? this.leavingDate),
    );
  }

  @override
  List<Object?> get props => [hireDate, leavingDate];
}
