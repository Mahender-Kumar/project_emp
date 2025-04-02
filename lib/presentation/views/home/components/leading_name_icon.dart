
import 'package:flutter/material.dart';
import 'package:project_emp/core/constants/constants.dart';
import 'package:project_emp/presentation/services/auth_service.dart'; 

class LeadingNameIcon extends StatelessWidget {
  LeadingNameIcon({super.key});
  final AuthService _authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.lightGreen,

        borderRadius: BorderRadius.circular(btnRadius),
      ),
      alignment: Alignment.center,
      child: Text(
        (_authService.currentUser?.email ?? ' ').toString().substring(0, 1),
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
