import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_text_field.dart';
import 'package:todo_app/services/auth_services.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String email = '';
  TextEditingController emailController = TextEditingController();

  void resetPassword() async {
    try {
      setState(() {
        email = emailController.text;
      });
      await AuthServices().resetPassword(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Reset password via link shared on Email",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black87,
        ),
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30),
                Text(
                  'Enter your Registered Mail ID for Password Reset',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  nameController: emailController,
                  hint: "Enter your email",
                ),
                SizedBox(height: 15),

                SizedBox(height: 30),
                CustomButton(
                  buttonLabel: "Request Reset",
                  action: resetPassword,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
