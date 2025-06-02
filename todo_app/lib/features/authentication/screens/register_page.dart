import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_password_filed.dart';
import 'package:todo_app/features/shared/widgets/custom_text_field.dart';
import 'package:todo_app/services/auth_services.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String name = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isEmpty(
    String name,
    String password,
    String email,
    String confirmPassword,
  ) {
    if (name.isEmpty ||
        password.isEmpty ||
        email.isEmpty ||
        confirmPassword.isEmpty) {
      return true;
    } else {
      return false;
    }
  }

  void cancellation() {
    Navigator.pop(context);
  }

  void registerPress() async {
    setState(() {
      name = nameController.text;
      email = emailController.text;
      password = passwordController.text;
      confirmPassword = confirmPasswordController.text;
    });
    if (isEmpty(name, password, email, confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      try {
        await AuthServices().signUpWithEmailAndPassword(email, password, name);
        await AuthServices().signOut(); //for navigating to login page
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Account Registerd Successfully",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.black87,
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Loginpage()),
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
                  'Create Account!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
                CustomTextField(
                  nameController: nameController,
                  hint: "Enter your name",
                ),
                SizedBox(height: 15),
                CustomTextField(
                  nameController: emailController,
                  hint: "Enter your email",
                ),
                SizedBox(height: 15),
                CustomPasswordField(
                  passwordController: passwordController,
                  hint: "Enter your password",
                ),
                SizedBox(height: 15),
                CustomPasswordField(
                  passwordController: confirmPasswordController,
                  hint: "Confirm your password",
                ),
                SizedBox(height: 30),
                CustomButton(
                  buttonLabel: "Register",
                  action: registerPress,
                  color: Colors.black87,
                ),
                SizedBox(height: 15),
                CustomButton(
                  buttonLabel: "Cancel",
                  action: cancellation,
                  color: Colors.redAccent,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
