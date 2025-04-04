import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';

class DisplayNameBloc extends Bloc<DisplayNameEvent, DisplayNameState> {
  final FirebaseAuth _auth;

  DisplayNameBloc(this._auth) : super(DisplayNameInitial()) {
    on<LoadDisplayNameEvent>((event, emit) {
      final user = _auth.currentUser;
      if (user != null) {
        emit(DisplayNameLoaded(user.displayName ?? 'User'));
      }
    });

    on<UpdateDisplayNameEvent>((event, emit) async {
      try {
        emit(DisplayNameUpdating());
        final user = _auth.currentUser;
        if (user != null) {
          await user.updateDisplayName(event.newName.trim());
          await user.reload();
          emit(DisplayNameUpdated(event.newName.trim()));
        } else {
          emit(DisplayNameError("No user found"));
        }
      } catch (e) {
        emit(DisplayNameError(e.toString()));
      }
    });
  }
}

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

class ChangeDisplayNamePage extends StatefulWidget {
  const ChangeDisplayNamePage({super.key});

  @override
  ChangeDisplayNamePageState createState() => ChangeDisplayNamePageState();
}

class ChangeDisplayNamePageState extends State<ChangeDisplayNamePage> {
  final TextEditingController _controller = TextEditingController();

  void _saveDisplayName() {
    context.read<DisplayNameBloc>().add(
      UpdateDisplayNameEvent(_controller.text),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DisplayNameBloc, DisplayNameState>(
      listener: (context, state) {
        if (state is DisplayNameUpdated) {
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Display name updated successfully!")),
          );
        } else if (state is DisplayNameError) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error: ${state.error}")));
        } else if (state is DisplayNameLoaded) {
          _controller.text = state.displayName;
        }
      },
      builder: (context, state) {
        return Form(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: () => context.pop(),
                    icon: Icon(Icons.close),
                  ),
                ],
              ),
              const Icon(Icons.person, size: 48),
              const ListTile(
                title: Center(child: Text("Change Display Name")),
                subtitle: Text("Set a name to be displayed on your profile"),
              ),
              if (state is DisplayNameLoaded || state is DisplayNameUpdated)
                Text("Current Name: ${_controller.text}"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  isDense: true,
                  hintText: "Enter your name",
                ),
              ),
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerRight,
                child: ExpandedBtn(
                  onPressed: _saveDisplayName,
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(btnRadius),
                    ),
                  ),
                  child:
                      (state is DisplayNameUpdating)
                          ? SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                            ),
                          )
                          : const Text("Save"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
