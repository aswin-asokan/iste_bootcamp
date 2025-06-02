import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/custom_button.dart';
import 'package:todo_app/features/shared/widgets/custom_password_filed.dart';
import 'package:todo_app/features/shared/widgets/custom_text_field.dart';
import 'package:todo_app/services/auth_services.dart';

class ChangeMail extends StatefulWidget {
  const ChangeMail({super.key});

  @override
  State<ChangeMail> createState() => _ChangeMailState();
}

class _ChangeMailState extends State<ChangeMail> {
  TextEditingController newEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String newEmail = "";
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

  Future<void> changeMail(BuildContext context, String mailID) async {
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
                  Text('Do you really want to change the mail ID?'),
                  CustomButton(
                    buttonLabel: "Yes I no longer use this mail ID",
                    action: () async {
                      try {
                        await AuthServices().updateEmail(mailID);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Verification mail sent. Please Login Again after verifying the Mail.",
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
                    buttonLabel: "No I want to Keep my mail ID",
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
          "Change Mail ID",
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
              'Enter current password and new mail ID to proceed on changing. A verification mail will be sent to the new mail ID.',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
            ),
            SizedBox(height: 15),
            CustomTextField(
              nameController: newEmailController,
              hint: "Enter new mail ID",
            ),
            CustomPasswordField(
              passwordController: passwordController,
              hint: "Enter current Password",
            ),
            CustomButton(
              buttonLabel: "Change Mail ID",
              action: () async {
                setState(() {
                  password = passwordController.text;
                  newEmail = newEmailController.text;
                });
                confirmed = await confirmPassword(password);
                if (confirmed) changeMail(context, newEmail);
              },
              color: Colors.black87,
            ),
          ],
        ),
      ),
    );
  }
}
