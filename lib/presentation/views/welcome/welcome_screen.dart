import 'package:flutter/material.dart';
import 'package:project_emp/presentation/widgets/background.dart'; 
import 'components/login_signup_btn.dart';
import 'components/welcome_image.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Background(
      child: SingleChildScrollView(
        child: SafeArea(
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WelcomeImage(),
              Row(
                children: [
                  Spacer(),
                  Expanded(flex: 8, child: LoginAndSignupBtn()),
                  Spacer(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
