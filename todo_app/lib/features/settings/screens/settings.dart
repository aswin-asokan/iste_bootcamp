import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/settings/screens/change_mail.dart';
import 'package:todo_app/features/settings/screens/delete_account.dart';
import 'package:todo_app/features/settings/screens/update_password.dart';
import 'package:todo_app/features/settings/widgets/account_card.dart';
import 'package:todo_app/features/settings/widgets/settings_tile.dart';
import 'package:todo_app/services/auth_services.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  String userName = "";
  String mailId = "";
  void logout() async {
    try {
      await AuthServices().signOut();
      if (!mounted) return;
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

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    userName = currentUser!.displayName!;
    mailId = currentUser.email!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            AccountCard(name: userName, mailID: mailId),
            SizedBox(height: 30),
            SettingsTile(
              title: "Change Password",
              leadingIcon: Icons.password_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UpdatePassword()),
                );
              },
            ),
            SettingsTile(
              title: "Change Email address",
              leadingIcon: Icons.email_outlined,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChangeMail()),
                );
              },
            ),
            SettingsTile(
              title: "Delete Account",
              leadingIcon: Icons.delete_outline_rounded,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DeleteAccount()),
                );
              },
            ),
            SettingsTile(
              title: "Logout",
              leadingIcon: Icons.logout_rounded,
              onTap: logout,
            ),
          ],
        ),
      ),
    );
  }
}
