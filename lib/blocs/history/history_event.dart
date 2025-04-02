
import 'package:equatable/equatable.dart';

 
abstract class HistoryEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SelectDateEvent extends HistoryEvent {
  final DateTime selectedDate;

  SelectDateEvent(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}

class FetchHistoryEvent extends HistoryEvent {
  final DateTime selectedDate;

  FetchHistoryEvent(this.selectedDate);

  @override
  List<Object?> get props => [selectedDate];
}
