import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/change_name/change_name_event.dart';
import 'package:project_emp/blocs/change_name/change_name_state.dart';

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

