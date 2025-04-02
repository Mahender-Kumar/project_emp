import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart'; 

class LoginAndSignupBtn extends StatelessWidget {
  const LoginAndSignupBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: () {
            context.go('/login');

            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (context) {
            //       return const LoginScreen();
            //     },
            //   ),
            // );
          },
          child: Text("Login".toUpperCase()),
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            context.go('/signup');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: kPrimaryLightColor,
            elevation: 0,
          ),
          child: Text(
            "Sign Up".toUpperCase(),
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
