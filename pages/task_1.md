# Task 1: Login Page

Design a **Login Page** in Flutter with the following requirements:

1. Two TextFields:
   - Email
   - Password
2. A Login Button
3. Validate:

   > - If any field is empty, show a SnackBar with the message "Please fill all fields" in red
   > - If:  
   >   Email = abc@gmail.com  
   >   Password = 1234  
   >   Show a green SnackBar with "Login Successful"
   > - Else, show a red SnackBar with "Invalid credentials"

### Sample output

<video height=350 controls>
  <source src="https://aswin-asokan.github.io/iste_bootcamp/videos/task_1.mp4" type="video/mp4">
  Your browser does not support the video tag.
</video>

> You don’t have to make the same UI! Explore Flutter widgets and create something unique you like.

### 💡 Tips

1.  While customizing the button use **WidgetStatePropertyAll()** than **MaterialStatePropertyAll()** as it is deprecated. Most of the sites and chat gpt still shows the MaterialStatePropertyAll().

```dart
style: ButtonStyle(
  backgroundColor: WidgetStatePropertyAll(Colors.blue),
)
```

2.  To toggle password visibility, follow the steps:

```dart
// create a variable to hide the text
bool hidePassword = true;
```

```dart
//set obscureText as the variable created
TextField(
    //if hidePassword is true, hide password
    //if hidePassword is false, show password
    obscureText: hidePassword,
 )
```

```dart
//in the suffix icon of textfield
IconButton(
    onPressed: () {
    //pressing button will make the variable to toggle between true and false
    setState(() {
        hidePassword = !hidePassword;
    });
    },
    //to change icon according to variable value
    //hidePassword?visible:not visible
    //check hidePassword value
    //if true show visible icon
    //else show hidden icon
    icon:
        hidePassword
            ? Icon(Icons.visibility)
            : Icon(Icons.visibility_off),
)
```

3.  Use **string_variable.isEmpty** and **string_variable.isNotEmpty** for checking if a string is empty or not
