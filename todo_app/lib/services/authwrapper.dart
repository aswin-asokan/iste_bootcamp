import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/bottomnavbar.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Bottomnavbar();
    } else {
      return const Loginpage();
    }
  }
}
