# Firebase Authentication

As mentioned earlier Firebase Authentication offers a complete identity solution, making it simple to manage users in your application. For implementing the online user authentication in your Flutter application follow the instructions.

> In this project we will be using authentication with email and password.

## Table of contents

1. [Setting up Authentication in Firebase Console](#setting-up-authentication-in-firebase-console)
2. [Setting up Authentication Services](#setting-up-authentication-services)
3. [Sign in Function for Login Page](#sign-in-function-for-login-page)
4. [Authwrapper class](#authwrapper-class)
5. [Registration Function](#registration-function)
6. [Forgot Password Function](#forgot-password-function)
7. [Fetching Username](#fetching-user-name)
8. [Logout Function](#logout-function)
9. [Confirm Password](#confirm-password)  
10. [Update Mail ID](#update-mail-id)  
11. [Update Password](#update-password)  
12. [Delete Account](#deleting-account)

### Setting up Authentication in Firebase Console

- From the side menu of the Project console in Firebase, choose `Authentication`
- Press on **Get Started**
- Choose **Email/Password** `Sign-in Method`
- Enable the **Email/Password** and `Save` the changes
- In the users tab you can manage the users in your application

### Setting up Authentication Services

- Create a new file **auth_services.dart** to setup authentication services

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final authServicesNotifier = ValueNotifier<AuthServices>(AuthServices());

class AuthServices {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  User? get user => firebaseAuth.currentUser;
  Stream<User?> get userStream => firebaseAuth.authStateChanges();
  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signUpWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await userCredential.user?.updateProfile(displayName: displayName);
      }
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> deleteAccount() async {
    try {
      await firebaseAuth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updateEmail(String email) async {
    try {
      await firebaseAuth.currentUser?.verifyBeforeUpdateEmail(email);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  Future<void> updatePassword(String password) async {
    try {
      await firebaseAuth.currentUser?.updatePassword(password);
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }
}
```

**What is this file doing?**

It defines an AuthServices class that wraps Firebase Auth methods like:

- Login
- Signup
- Logout
- Password reset
- Updating email/password
- Deleting account

This helps keep all authentication-related functions in one place, making the code cleaner and reusable.

**1. Import Statements**

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
```

- `firebase_auth`: This is the official package to interact with Firebase Authentication.
- `flutter/material.dart`: Needed for using ValueNotifier and other Flutter widgets.

**2. Global Notifier for Access**

```dart
final authServicesNotifier = ValueNotifier<AuthServices>(AuthServices());
```

This creates a ValueNotifier, which:

- Notifies listeners when AuthServices changes.
- Can be used in UI to rebuild widgets when user signs in/out.

**3. The AuthServices Class**

This is where all the actual authentication logic lives.

```dart
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
```

This creates a Firebase Auth object to use throughout the class.

**4. Get Current User**

```dart
User? get user => firebaseAuth.currentUser;
```

user: Gives access to the currently logged-in user (or null if no one is logged in).

**5. User State Stream**

```dart
Stream<User?> get userStream => firebaseAuth.authStateChanges();
```

userStream: Gives real-time updates when the user logs in or out. You can use this in a StreamBuilder to automatically update the UI.

All other methods are used for various authentication services such as sign in, register, etc.

### Sign in Function for Login Page

```dart
//This is an async function, meaning it can await for tasks like Firebase login that take time to complete.
void loginAction() async {
    //updates the UI with the values entered by the user
    setState(() {
      email = emailController.text;
      password = passwordController.text;
    });
    //checks if the user left any field blank.
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      //Tries to log in using your custom AuthServices class.
      //Uses await to pause execution until Firebase returns a result.
      try {
        await AuthServices().signInWithEmailAndPassword(email, password);
        //mounted ensures the widget is still in the widget tree (not disposed) before using context.
        //Prevents potential errors if login completes after the screen is closed.
        if (!mounted) return;
        //If login is successful, navigates to the Bottomnavbar() screen.
        //Removes all previous routes so the user can’t go back to the login page using the back button.
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Bottomnavbar()),
          (route) => false,
        );
      } on FirebaseAuthException catch (e) {
        //If Firebase throws an error (like wrong password, user not found), this block will handle it.
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
```

> ⚠️ You should change the page to be loaded after according to your application. Like if your app only has a home screen navigate to that page instead of BottomNavBar

#### Authwrapper class

Create a Authentication wrapper file for managing the state according to if a user is logged in or not. The AuthWrapper widget is a simple authentication gatekeeper for your Flutter app using Firebase. It decides which screen to show based on whether the user is logged in or not.

```dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/features/authentication/screens/login_page.dart';
import 'package:todo_app/features/shared/widgets/bottomnavbar.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});
  @override
  Widget build(BuildContext context) {
    //This line gets the currently logged-in user from Firebase.
    //If user is null, it means no one is logged in.
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return Bottomnavbar();
    } else {
      return const Loginpage();
    }
  }
}
```

AuthWrapper is used in main.dart as the entry point screen, so that users are always taken to the correct page depending on their auth status.

```dart
//main.dart
Widget build(BuildContext context) {
    return MaterialApp(
      title: 'To Do App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),//home set as AuthWrapper class
    );
  }
```

**Working:**

- AuthWrapper checks Firebase:
- If user is signed in → go to home (Bottomnavbar).
- If not → show Loginpage.

### Registration Function

```dart
void registerPress() async {
    //Collects user input from text fields and stores them in variables.
    //setState is used so that the UI updates if necessary.
    setState(() {
      name = nameController.text;
      email = emailController.text;
      password = passwordController.text;
      confirmPassword = confirmPasswordController.text;
    });
    //Checks if any of the fields are empty using a custom isEmpty() function.
    //If any field is empty, shows a red snackbar and exits the function.
    if (isEmpty(name, password, email, confirmPassword)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all fields"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else if (password != confirmPassword) {
        //Checks if the password and confirm password are not equal.
        //Shows an error if passwords don’t match.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Passwords do not match"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    } else {
      try {
        //Calls your custom auth service to create a user with email and password.
        //Also sets the display name using .updateProfile() inside the service.
        await AuthServices().signUpWithEmailAndPassword(email, password, name);
        //After successful registration, signs the user out.
        //Optional, but used here to force the user to login again
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
        //Redirects user to Login page using pushReplacement (removes the Register screen from the stack).
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
```

> ⚠️ You can update the code so that the user can directly move to home screen instead of login page as registration will automatically sign in the user to the app.

### Forgot Password Function

```dart
void resetPassword() async {
    try {
      setState(() {
        email = emailController.text;
      });
      //Calls the resetPassword method in your custom AuthServices class
      //Sends a password reset link to the provided email address via Firebase.
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
      //Closes the current screen (usually returning to the login screen).
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
        //If an error occurs (e.g., invalid email, user not found), it catches the error, updates the UI, and shows an error message in a red snackbar.
      String errorMessage = '';
      setState(() {
        errorMessage = e.message ?? 'An error occurred';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }
  }
```

### Fetching User name

To fetch the user name given while registering the app you need to initialize the values at initState of your page where you want to display the name

```dart
//The initState() is part of a StatefulWidget in Flutter and is used to initialize some values when the widget is first inserted into the widget tree.
void initState() {
    //You must call super.initState() first to ensure the parent class (State) sets up everything properly.
    super.initState();
    //Gets the currently logged-in Firebase user using Firebase Auth.
    final currentUser = FirebaseAuth.instance.currentUser;
    //Fetches the displayName of the current user and assigns it to a variable called userName.
    userName = currentUser!.displayName!;
    //Similarly, fetches the email of the user and stores it in the mailId variable.
    mailId = currentUser.email!;
    //userName and mailId are variables decalred inside the stateful class
}
```

### Logout Function

You can give this option as an action on the appbar or an option from the settings page.

```dart
void logout() async {
    try {
        //Calls the signOut() method from your AuthServices class:
      await AuthServices().signOut();
      if (!mounted) return;
      //Replaces the current screen with the Loginpage using pushReplacement
      //so the user can't go back to the logged-in area by pressing back.
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
```

When a user taps a logout button in your app:

- This function is triggered.
- Firebase ends their session.
- They are redirected to the login screen.

### Confirm Password

From here on out you need to check if the password entered by user is correct as we are making changes to password, email,etc. Firebase requires recent login credentials for critical actions. So if a user has been logged in for a long time, they'll need to re-enter their password to confirm it's really them.

```dart
//The function returns a Future<bool> — true if password is correct, false otherwise.
Future<bool> confirmPassword(String password) async {
    //Get the currently logged-in user.
    final currentUser = FirebaseAuth.instance.currentUser;
    try {
        //Create a credential using the entered password and user's email.
      final credential = EmailAuthProvider.credential(
        email: currentUser!.email!,
        password: password,
      );
      //Reauthenticate the user using the credentials. If it fails, it throws an exception.
      await currentUser.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
        //If the password is wrong or the reauth fails, it shows an error using SnackBar and returns false.
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.message ?? "Error during deletion"),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    }
    //If no error occurred, it returns true, meaning the password is correct and the user is reauthenticated.
    return true;
  }
```

### Update Mail ID

```dart
//context: Required to display the dialog and handle navigation/snackbars.
//mailID: The new email address the user wants to update to.
Future<void> changeMail(BuildContext context, String mailID) async {
    //It uses showDialog() to create a popup confirmation window.
    //This dialog will ask the user whether they want to proceed with the email change.
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
                        //Calls AuthServices().updateEmail(mailID) to update the email in Firebase.
                        await AuthServices().updateEmail(mailID);
                        //Shows a green SnackBar that tells the user a verification mail was sent.
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Verification mail sent. Please Login Again after verifying the Mail.",
                              style: TextStyle(color: Colors.black),
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                        //Logs the user out and redirects to the Login page.
                        //This clears the navigation stack so users can’t return without logging in again.
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
```

**Usage:**

```dart
onPress: () async {
    setState(() {
        password = passwordController.text;
        newEmail = newEmailController.text;
    });
    //confirms if the password entered is the right one
    confirmed = await confirmPassword(password);
    //if the password is correct allow user to change the mail id
    if (confirmed) changeMail(context, newEmail);
},
```

Upon successful change of mail ID a verification mail will be sent to the new mail ID. After verification users can use the new mail ID for signing in. A notification will be sent to the old mail ID.

### Update Password

```dart
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
                        //Tries to update the user's password in Firebase.
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
                        //Navigates to the login page using
                        //After changing the password, the user is logged out and sent back to login.
                        //This prevents session hijacking with old credentials
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
```

> Usage is same as changing mail ID

### Deleting account

```dart
//The deleteAccount function displays a confirmation dialog asking the user if they really want to delete their account.
//If they confirm, it deletes their Firebase account and navigates them back to the login page.
//Users won't be able to sign in with deleted account
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
                        //Calls your Firebase Auth service to delete the user account.
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
```

> Usage is same as changing mail ID

> **Note:** make changes to the code according to your preference
