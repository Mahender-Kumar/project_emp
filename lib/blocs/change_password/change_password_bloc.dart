
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_emp/blocs/change_password/change_password_event.dart';
import 'package:project_emp/blocs/change_password/change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final FirebaseAuth _auth;

  ChangePasswordBloc(this._auth) : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>((event, emit) async {
      emit(ChangePasswordLoading());

      try {
        final user = _auth.currentUser;
        if (user == null) throw FirebaseAuthException(code: 'user-not-found');

        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: event.oldPassword,
        );

        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(event.newPassword);

        emit(ChangePasswordSuccess());
      } on FirebaseAuthException catch (e) {
        String msg = 'Something went wrong';
        if (e.code == 'wrong-password') {
          msg = 'Old password is incorrect';
        } else if (e.code == 'weak-password')
         { msg = 'New password is too weak';}
        else if (e.code == 'requires-recent-login')
        {  msg = 'Please log in again and try';}

        emit(ChangePasswordFailure(msg));
      }
    });
  }
}

