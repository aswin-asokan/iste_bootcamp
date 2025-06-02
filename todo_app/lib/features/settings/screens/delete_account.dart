import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_password_filed.dart';
import 'package:todo_app/services/auth_services.dart';

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({super.key});

  @override
  State<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController passwordController = TextEditingController();
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

  Future<void> deleteAccount(BuildContext context) async {
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
                  Text('Do you really want to delete the account?'),
                  CustomButton(
                    buttonLabel: "Yes I no longer use the App",
                    action: () async {
                      try {
                        await AuthServices().deleteAccount();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Account Deleted",
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.black87,
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
                    buttonLabel: "No I want to Keep my Account",
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
          "Delete Account",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Text(
              'Enter your password and proceed on deleting the account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            CustomPasswordField(
              passwordController: passwordController,
              hint: "Enter current Password",
            ),
            SizedBox(height: 15),
            CustomButton(
              buttonLabel: "Delete Account",
              action: () async {
                setState(() {
                  password = passwordController.text;
                });
                confirmed = await confirmPassword(password);
                if (confirmed) deleteAccount(context);
              },
              color: Colors.redAccent,
            ),
          ],
        ),
      ),
    );
  }
}
