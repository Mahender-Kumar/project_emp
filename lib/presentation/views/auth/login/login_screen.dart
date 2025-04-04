import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:project_emp/blocs/auth/auth_bloc.dart';
import 'package:project_emp/blocs/auth/auth_event.dart';
import 'package:project_emp/blocs/auth/auth_state.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/widgets/expanded_btn.dart';
import 'package:project_emp/services/email_validator.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _authenticate(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) return;

    // 🔥 Dispatch Login Event
    context.read<AuthBloc>().add(
      LoginRequested(email: email, password: password),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            context.go('/'); // Navigate to home
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SingleChildScrollView(
          child: Container(
            width: size.width,
            height: size.height,
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              bottom: size.height * 0.2,
              top: size.height * 0.05,
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "Hello,\nWelcome Back",
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: defaultGapping * 4),

                    SizedBox(height: defaultGapping * 2),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        color: Theme.of(context).colorScheme.outlineVariant,

                        borderRadius: BorderRadius.all(
                          Radius.circular(btnRadius),
                        ),
                      ),
                      child: TextFormField(
                        controller: _emailController,
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.emailAddress,
                        validator:
                            (value) =>
                                value!.isEmpty
                                    ? "Enter your email"
                                    : (!EmailValidator.validate(value)
                                        ? "Invalid email"
                                        : null),
                        decoration: const InputDecoration(
                          hintText: "Email",
                          isDense: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: defaultGapping * 2),

                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                        color: Theme.of(context).colorScheme.outlineVariant,

                        borderRadius: BorderRadius.all(
                          Radius.circular(btnRadius),
                        ),
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        validator:
                            (value) =>
                                value!.isEmpty ? "Enter your password" : null,
                        decoration: const InputDecoration(
                          isDense: true,
                          hintText: "Password",
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: defaultGapping / 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Forgot Password?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                    const SizedBox(height: defaultPadding * 4),

                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return ExpandedBtn(
                          style: FilledButton.styleFrom(
                            backgroundColor:
                                Theme.of(context).colorScheme.onSurface,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(btnRadius),
                            ),
                          ),
                          onPressed:
                              state is AuthLoading
                                  ? null
                                  : () => _authenticate(context),
                          child:
                              state is AuthLoading
                                  ? SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: const CircularProgressIndicator(),
                                  )
                                  : Text(
                                    "Login",
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color:
                                          Theme.of(
                                            context,
                                          ).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        );
                      },
                    ),

                    const SizedBox(height: defaultPadding),
                    // Center(
                    //   child: ExpandedBtn(
                    //     style: FilledButton.styleFrom(
                    //       backgroundColor:
                    //           Theme.of(context).colorScheme.onInverseSurface,
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(btnRadius),
                    //       ),
                    //     ),
                    //     onPressed: () {
                    //       context.go('/signup');
                    //     },
                    //     child: Text(
                    //       "Create Account",
                    //       style: Theme.of(
                    //         context,
                    //       ).textTheme.bodySmall?.copyWith(
                    //         color:
                    //             Theme.of(
                    //               context,
                    //             ).colorScheme.onPrimaryContainer,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: defaultPadding),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
