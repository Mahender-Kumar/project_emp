import 'package:equatable/equatable.dart';

abstract class DisplayNameState extends Equatable {
  const DisplayNameState();

  @override
  List<Object?> get props => [];
}

class DisplayNameInitial extends DisplayNameState {}

class DisplayNameLoaded extends DisplayNameState {
  final String displayName;
  const DisplayNameLoaded(this.displayName);

  @override
  List<Object?> get props => [displayName];
}

class DisplayNameUpdating extends DisplayNameState {}

class DisplayNameUpdated extends DisplayNameState {
  final String newName;
  const DisplayNameUpdated(this.newName);

  @override
  List<Object?> get props => [newName];
}

class DisplayNameError extends DisplayNameState {
  final String error;
  const DisplayNameError(this.error);

  @override
  List<Object?> get props => [error];
}
