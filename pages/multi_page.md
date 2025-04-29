# Navigation and components

## Table of contents

1. [Page Navigation](#page-navigation)
2. [Components](#components)  
   2.1. [Stateless Custom Widgets](#stateless-custom-widgets)  
   2.2. [Statelful Custom Widgets](#stateful-custom-widgets)  
   2.3. [Custom Widgets with Functions](#custom-widgets-with-functions)

### Page navigation

This section describes how to create a basic page navigation in Flutter. Consider your app has multiple pages like, login, register, home, etc. you should have some method to navigate between them. For basic navigations we use the **Navigator** class.

Start from your previous code. From the login page we need to navigate to the registration page and register one account. And there should be an option to navigate back to login page. First of all develop a registration page with,

> - **Text fields:** Name, Email, Password, Password confirmation
> - **Buttons:** Register, Cancellation

#### Forward navigation

In your login page, when press the register button the registration window should be opened. For that, we need to access the **Navigator** class inside the **onPressed** part of the button.

```dart
onPressed: () {
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RegisterPage()),
    );
}
```

**Navigator.push**  
It pushes a new route (screen/page) onto the stack of routes managed by Flutter's navigation system.  
**Parameters:**

- context: The BuildContext from which the navigation happens.
- route: A Route object that defines what the next screen is and how the transition happens.

**MaterialPageRoute**  
A subclass of PageRoute that provides a material design style transition (slide animation on Android).

**builder: (context) => RegisterPage()**  
A function that builds the widget for the new screen. MaterialPageRoute needs to know which widget to display when the route is pushed. (context) => RegisterPage() is a closure that returns the widget you want to show (in this case, RegisterPage).

#### Backward navigation

If you want to return to Login page after registration or by pressing the cancel button, we need to use the **Navigator.pop**.

```dart
onPressed: () {
    Navigator.pop(context);
}
```

**Navigator.pop(context)**  
It removes (pops) the current screen from the navigation stack, taking you back to the previous screen. To go back from a screen you navigated to using Navigator.push (Here back to login page).

> **Notes**
> Flutter uses a stack to implement page navigation. So basic stack operation push and pop are used for this. When you push a page, it’s added to the top of the stack. When you pop, the top page is removed, and the app shows the page underneath it.

_These two are basic navigation functions in Flutter. There are many others for different purposes. Refer [official docs](https://docs.flutter.dev/cookbook/navigation/navigation-basics)_ to learn more.

### Components

When creating large application it is a bad practice to use same widgets (code) multiple times inside a row, column, etc as it increases the line of codes. Instead we create custom widgets and call them. You can use stateless, or stateful classes for creating custom widgets.

<img src="https://aswin-asokan.github.io/iste_bootcamp/images/register.png" height=500/>

In this screen the name and email fields are similar, password fields are similar, and buttons are similar. If we create them inside a single column with repeated coding the total lines goes upto 200. Instead we are creating them as custom widgets or components. Create a new folder _Widgets_ in _lib_ folder and create a file like, **custom_text_field.dart**,

#### Stateless custom widgets

```dart
import 'package:flutter/material.dart';
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    required this.nameController,
    required this.hint,
  });
  final TextEditingController nameController;
  final String hint;
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: nameController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
        fillColor: Colors.grey[100],
        filled: true,
        border: InputBorder.none,
      ),
    );
  }
}
```

- **super.key:** Passes an optional key to the parent class (StatelessWidget) for widget identification.
- **required this.nameController:** A required parameter of type TextEditingController, used to manage the text input.
- **required this.hint:** A required string used to display hint text inside the TextField.
- **final TextEditingController nameController:** It stores the TextEditingController that you pass from the parent widget.
- **final String hint:** Stores the hint text passed when creating the widget.

In order to use this newly created component, inside your column widget remove the current code for name and email fields and use the custom widget.

```dart
// TextField removed
// TextField(
//   controller: nameController,
//   decoration: InputDecoration(
//     contentPadding: EdgeInsets.all(20),
//     hintText: 'Enter your name',
//     hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
//     fillColor: Colors.grey[100],
//     filled: true,
//     border: InputBorder.none,
//   ),
// ),
// SizedBox(height: 15),
// TextField(
//   controller: emailController,
//   decoration: InputDecoration(
//     contentPadding: EdgeInsets.all(20),
//     hintText: 'Enter your email',
//     hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
//     fillColor: Colors.grey[100],
//     filled: true,
//     border: InputBorder.none,
//   ),
// ),
// Replaced with
CustomTextField(
    nameController: nameController,
    hint: "Enter your name",
),
SizedBox(height: 15),
CustomTextField(
    nameController: emailController,
    hint: "Enter your email",
),
```

As you can see the number of lines reduced drastically.

#### Stateful custom widgets

When it comes to the password field the state changes when we press the show password icon, so we should use the stateful widget to create custom widget.

```dart
import 'package:flutter/material.dart';
class CustomPasswordField extends StatefulWidget {
  const CustomPasswordField({
    super.key,
    required this.passwordController,
    required this.hint,
  });
  final TextEditingController passwordController;
  final String hint;
  @override
  State<CustomPasswordField> createState() => _CustomPasswordFieldState();
}
class _CustomPasswordFieldState extends State<CustomPasswordField> {
  bool hidePassword = true;
  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: hidePassword,
      controller: widget.passwordController,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(20),
        hintText: widget.hint,
        hintStyle: TextStyle(color: Colors.grey[250], fontSize: 13),
        fillColor: Colors.grey[100],
        filled: true,
        border: InputBorder.none,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              hidePassword = !hidePassword;
            });
          },
          icon: Icon(hidePassword ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
```

> **Why We Use widget.**
> In a StatefulWidget, you can't directly access the widget's constructor parameters (like hidePassword, passwordController) without using the widget prefix. The actual state class (\_CustomPasswordFieldState) does not own those variables. They belong to the parent widget class (CustomPasswordField). So, inside the state, you access them as widget.hidePassword, widget.passwordController, etc.

#### Custom widgets with functions

When we create custom widgets there may be times when we need to pass functions as parameters. Like, when we create a component for buttons we should pass action for onPressed. Consider a button,

```dart
// do not use this code as it is not complete, it's just a sample
class _RegisterPageState extends State<RegisterPage> {
    void registerPress() {
        // actions to be preformed like empty field checking, password verification etc.
    }
    @override
    Widget build(BuildContext context) {
    return Scaffold(
        .
        .
        .
        ElevatedButton(
            onPressed: registerPress,// onpress action
            style: ButtonStyle(
                elevation: WidgetStatePropertyAll(0),
                shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                ),
                ),
                backgroundColor: WidgetStatePropertyAll(Colors.black87),
            ),
            child: Text(
                "Register",
                style: TextStyle(color: Colors.white),
            ),
        )
        .
        .
        .
    )
    }
}
```

> **Notes**
> The **void registerPress()** function holds the actions to be performed when the button is pressed. The function is directly used in, **onPressed: registerPress** for calling.

**Custom button widget**

```dart
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.buttonLabel,
    required this.action,
    required this.color,
  });
  final String buttonLabel;
  final VoidCallback action;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: action,
        style: ButtonStyle(
          elevation: WidgetStatePropertyAll(0),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          backgroundColor: WidgetStatePropertyAll(color),
        ),
        child: Text(buttonLabel, style: TextStyle(color: Colors.white)),
      ),
    );
  }
}
```

**VoidCallback:** it is a built-in Dart type, represents a function that takes no parameters and returns nothing (void). action is a variable that stores a function. That function is passed in from outside the widget. This makes your button flexible and reusable, because it doesn't need to know what action it triggers — it just calls action() when pressed.

**Usage**

```dart
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
```

Now the code looks more structured and almost 70 line of codes was reduced.

**lib folder structure**

```c
lib
|- widgets
|   |- custom_button.dart
|   |- custom_password_field.dart
|   |- custom_text_field.dart
|- login_page.dart
|- main.dart
|- register_page.dart
```

> **Notes**
> You can use this custom widgets anywhere, like replace the ones you have used inside login page.
