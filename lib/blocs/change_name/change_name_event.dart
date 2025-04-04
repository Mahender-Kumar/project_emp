
import 'package:equatable/equatable.dart';

abstract class DisplayNameEvent extends Equatable {
  const DisplayNameEvent();

  @override
  List<Object?> get props => [];
}

class LoadDisplayNameEvent extends DisplayNameEvent {}

class UpdateDisplayNameEvent extends DisplayNameEvent {
  final String newName;
  const UpdateDisplayNameEvent(this.newName);

  @override
  List<Object?> get props => [newName];
}
