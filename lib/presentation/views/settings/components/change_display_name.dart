import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart'; 

class ChangeDisplayNamePage extends StatefulWidget {
  const ChangeDisplayNamePage({super.key});

  @override
  ChangeDisplayNamePageState createState() => ChangeDisplayNamePageState();
}

class ChangeDisplayNamePageState extends State<ChangeDisplayNamePage> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _currentName = "Loading...";

  @override
  void initState() {
    super.initState();
    _loadDisplayName();
  }

  /// Fetch display name from Firebase Auth
  void _loadDisplayName() {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _currentName = user.displayName ?? "User";
        _controller.text = _currentName;
      });
    }
  }

  /// Save new display name to Firebase Auth
  Future<void> _saveDisplayName() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(_controller.text.trim());
        await user.reload(); // Refresh user data

        setState(() {
          _currentName = _controller.text;
        });

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Display name updated successfully!")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Error updating name: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
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
          Center(child: Icon(Icons.person)),
          ListTile(
            dense: true,
            titleAlignment: ListTileTitleAlignment.center,
            title: Center(child: const Text("Change Display Name")),
            subtitle: const Text("Set a name to be displayed on your profile"),
          ),
          Text(
            "Current Name: $_currentName",
            style: const TextStyle(fontSize: 16),
          ),
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
          ExpandedBtn(
            onPressed: _saveDisplayName,
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(btnRadius),
              ),
            ),
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }
}
