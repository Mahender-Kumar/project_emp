import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart'; 

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ChangePasswordPageState createState() => ChangePasswordPageState();
}

class ChangePasswordPageState extends State<ChangePasswordPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isLoading = false;

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw FirebaseAuthException(
          code: 'user-not-found',
          message: 'User not logged in.',
        );
      }

      // Re-authenticate user with old password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _oldPasswordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      // Update the password
      await user.updatePassword(_newPasswordController.text);
 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Password changed successfully!')),
        );
        Navigator.pop(context); // Go back after changing password
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = "An error occurred.";
      if (e.code == 'wrong-password') {
        errorMessage = "Old password is incorrect.";
      } else if (e.code == 'weak-password') {
        errorMessage = "New password is too weak.";
      } else if (e.code == 'requires-recent-login') {
        errorMessage = "Please log in again and retry.";
      }
      if(mounted) {
        ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(errorMessage)));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
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
                icon: Icon(Icons.close_sharp),
              ),
            ],
          ),
          Center(child: Icon(Icons.lock_reset_sharp)),

          ListTile(
            dense: true,
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(child: const Text("Set a password")),
            subtitle: const Text(
              'Use a password at least 15 letters long, or at least 8 characters long with noth letters and numbers',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),
          const Text("Enter old password:"),
          TextFormField(
            controller: _oldPasswordController,

            decoration: const InputDecoration(
              isDense: true,

              hintText: "New Password",
              border: OutlineInputBorder(),
            ),
            obscureText: true,
            validator:
                (value) => value!.isEmpty ? "Enter your old password" : null,
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
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ExpandedBtn(
                onPressed: _changePassword,
                style: FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(btnRadius),
                  ),
                ),
                child: const Text("Set a password"),
              ),
        ],
      ),
    );
  }
}
