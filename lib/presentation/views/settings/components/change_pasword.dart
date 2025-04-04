import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';

abstract class ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String oldPassword;
  final String newPassword;

  ChangePasswordSubmitted({
    required this.oldPassword,
    required this.newPassword,
  });
}

abstract class ChangePasswordState {}

class ChangePasswordInitial extends ChangePasswordState {}

class ChangePasswordLoading extends ChangePasswordState {}

class ChangePasswordSuccess extends ChangePasswordState {}

class ChangePasswordFailure extends ChangePasswordState {
  final String message;
  ChangePasswordFailure(this.message);
}

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
        if (e.code == 'wrong-password')
          msg = 'Old password is incorrect';
        else if (e.code == 'weak-password')
          msg = 'New password is too weak';
        else if (e.code == 'requires-recent-login')
          msg = 'Please log in again and try';

        emit(ChangePasswordFailure(msg));
      }
    });
  }
}

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ChangePasswordBloc(FirebaseAuth.instance),
      child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Password changed successfully!')),
            );
            Navigator.pop(context);
          } else if (state is ChangePasswordFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          final isLoading = state is ChangePasswordLoading;

          return Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close_sharp),
                    ),
                  ],
                ),
                const Center(child: Icon(Icons.lock_reset_sharp)),
                const ListTile(
                  dense: true,
                  titleAlignment: ListTileTitleAlignment.center,
                  title: Center(child: Text("Set a password")),
                  subtitle: Text(
                    'Use a password at least 15 letters long, or at least 8 characters long with both letters and numbers',
                    softWrap: true,
                    textAlign: TextAlign.center,
                  ),
                ),
                const Text("Enter old password:"),
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "Old Password",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.isEmpty ? "Enter your old password" : null,
                ),
                const SizedBox(height: 16),
                const Text("Enter new password:"),
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: "New Password",
                    border: OutlineInputBorder(),
                  ),
                  validator:
                      (value) =>
                          value!.length < 6
                              ? "Password must be at least 6 characters"
                              : null,
                ),
                const SizedBox(height: 16),
                ExpandedBtn(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            if (_formKey.currentState!.validate()) {
                              context.read<ChangePasswordBloc>().add(
                                ChangePasswordSubmitted(
                                  oldPassword: _oldPasswordController.text,
                                  newPassword: _newPasswordController.text,
                                ),
                              );
                            }
                          },
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(btnRadius),
                    ),
                  ),
                  child:
                      isLoading
                          ? SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.secondaryContainer,
                            ),
                          )
                          : const Text("Update password"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
