import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/forgot_password.dart';
import 'package:todo_app/features/authentication/screens/register_page.dart';
import 'package:todo_app/features/shared/widgets/bottomnavbar.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_password_filed.dart';
import 'package:todo_app/features/shared/widgets/custom_text_field.dart';
import 'package:todo_app/services/auth_services.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  String email = '';
  String password = '';
  bool isValid = false;
  bool hidePassword = true;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void loginAction() async {
    setState(() {
      email = emailController.text;
      password = passwordController.text;
    });
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      try {
        await AuthServices().signInWithEmailAndPassword(email, password);
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavbar()),
          (route) => false,
        );
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
                  'Welcome back! Glad\nto see you, Again!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  nameController: emailController,
                  hint: "Enter your email",
                ),
                SizedBox(height: 15),
                Column(
                  spacing: 10,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    CustomPasswordField(
                      passwordController: passwordController,
                      hint: "Enter your password",
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPassword(),
                          ),
                        );
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.black, fontSize: 13),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30),
                CustomButton(
                  buttonLabel: "Login",
                  action: loginAction,
                  color: Colors.black87,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Container(
        color: Colors.white,
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Don't have an account? "),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterPage()),
                );
              },
              child: Text(
                "Register Now",
                style: TextStyle(color: Colors.blue[200]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
