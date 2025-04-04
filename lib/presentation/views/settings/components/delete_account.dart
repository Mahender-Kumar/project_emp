import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/presentation/views/home/components/leading_name_icon.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';

class DeleteAccountPage extends StatelessWidget {
  DeleteAccountPage({super.key});

  final AuthService _authService = AuthService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  /// Delete the user's Firebase account
  Future<void> _deleteAccount(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    try {
      // Re-authenticate the user if necessary

      User? user = AuthService().currentUser;

      // Re-authenticate user with old password
      AuthCredential credential = EmailAuthProvider.credential(
        email: user!.email!,
        password: _passwordController.text,
      );

      await user.reauthenticateWithCredential(credential);

      await user.delete();

      // print('deleted account');

      if (context.mounted) {
        context.pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Account deleted successfully!")),
        );
      }
    } catch (e) {
      // print(e);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error deleting account: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
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
          Center(child: Icon(Icons.error_outline, color: Colors.red)),

          ListTile(
            dense: true,
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(
              child: const Text("Delete your entire account permanently"),
            ),
            subtitle: const Text(
              'This action cannot be undone. This will permanently delete your account.',
              softWrap: true,
              textAlign: TextAlign.center,
            ),
          ),

          Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(btnRadius),
              side: const BorderSide(color: Colors.grey, width: 0.5),
            ),

            child: ListTile(
              dense: true,
              leading: LeadingNameIcon(),
              title: Text("${_authService.currentUser?.displayName}"),
              subtitle: Text("${_authService.currentUser?.email}"),
            ),
          ),
          Form(
            key: _formKey,
            child: Card(
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Please type in your password to confirm",
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  SizedBox(height: defaultGapping / 2),
                  TextFormField(
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: "${_authService.currentUser?.email}",
                      border: OutlineInputBorder(),
                    ),
                    controller: _passwordController,
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? "Please type password to continue"
                                : null,
                  ),
                  SizedBox(height: defaultGapping),
                  ExpandedBtn(
                    onPressed: () => _deleteAccount(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(btnRadius),
                      ),
                    ),
                    child: const Text(
                      "Delete Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: defaultGapping),
                  ExpandedBtn(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      overlayColor: Colors.grey[50],
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(btnRadius),
                      ),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
