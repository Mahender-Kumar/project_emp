import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/core/constants/image_constant.dart';
import 'package:project_emp/presentation/services/auth_service.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';
import 'package:project_emp/services/email_validator.dart'; 

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();

  final _formKey = GlobalKey<FormState>();

  void _authenticate(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    final user = await _authService.signUp(email, password);
    if (user != null) {
      // print("Login Successful: ${user.email}");
      if (context.mounted) {
        context.go('/');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: size.height * 0.2,
            top: size.height * 0.05,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Hi there, \nReady to get started?",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: defaultGapping * 4),
                Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: SvgPicture.asset(ImageConst.googleLogo),
                  ),
                ),
                SizedBox(height: defaultGapping * 2),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    color: Theme.of(context).colorScheme.outlineVariant,

                    borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
                  ),
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,

                    controller: _emailController,
                    onSaved: (email) {},
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please enter your email";
                      }
                      if (!EmailValidator.validate(value)) {
                        return "This Email is badly formatted !";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      hintText: "Email",
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(height: defaultGapping),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                    color: Theme.of(context).colorScheme.outlineVariant,

                    borderRadius: BorderRadius.all(Radius.circular(btnRadius)),
                  ),
                  child: TextFormField(
                    textInputAction: TextInputAction.done,
                    obscureText: true,

                    controller: _passwordController,
                    validator:
                        (value) =>
                            value!.isEmpty
                                ? "Please enter your password"
                                : null,
                    decoration: const InputDecoration(
                      hintText: "Password",
                      isDense: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding * 3),
                ExpandedBtn(
                  style: FilledButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(btnRadius),
                    ),
                  ),
                  onPressed: () => _authenticate(context),
                  child: Text(
                    "Sign Up".toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: defaultPadding),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
