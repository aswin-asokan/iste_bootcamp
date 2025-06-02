import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_password_filed.dart';
import 'package:todo_app/services/auth_services.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({super.key});

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String newPassword = "";
  String password = "";
  bool confirmed = false;
  Future<bool> confirmPassword(String password) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      await currentUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Error during deletion"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    return true;
  }

  Future<void> updagePassword(BuildContext context, String password) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: Column(
                spacing: 15,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text('Do you really want to change the Password?'),
                  CustomButton(
                    buttonLabel: "Yes I want to update my password",
                    action: () async {
                      try {
                        await AuthServices().updatePassword(password);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Updated Password. Please Login Again for Safety.",
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Loginpage()),
                          (route) => false,
                        );
                      } on FirebaseAuthException catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.message ?? "Error during deletion"),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    color: Colors.redAccent,
                  ),
                  CustomButton(
                    buttonLabel: "No I want to Keep my password",
                    action: () {
                      Navigator.pop(context);
                    },
                    color: Colors.black87,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Update Password",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          spacing: 15,
          children: [
            Text(
              'Enter current password and new password to proceed on updating.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 15),
            CustomPasswordField(
              passwordController: newPasswordController,
              hint: "Enter new Password",
            ),
            CustomPasswordField(
              passwordController: passwordController,
              hint: "Enter current Password",
            ),
            CustomButton(
              buttonLabel: "Update Password",
              action: () async {
                setState(() {
                  password = passwordController.text;
                  newPassword = newPasswordController.text;
                });
                confirmed = await confirmPassword(password);
                if (confirmed) updagePassword(context, newPassword);
              },
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
