# Functions and Variables

## Table of contents

1. [Variables](#what-are-variables)
2. [Functions](#what-are-functions)
3. [Where to write Variables and functions](#where-do-you-write-variables-and-functions)
4. [Function calling](#how-to-call-a-function)
5. [Set state](#what-is-setstate)
6. [Summary](#summary-table)

> **Note**
> If you are new to programming please go through the code and make sure to read the comments.
> **Comments are non executable code blocks used for documentation**
> Use // for single line comments
> Use /_...._/ for multi line comments

### What are Variables?

A variable is like a container or box that stores information. You give it a name, and it holds a value.

```dart
String name = "Aswin";
```

| Type   | Meaning               | Example                  |
| ------ | --------------------- | ------------------------ |
| int    | whole numbers         | int age = 20;            |
| double | decimal numbers       | double pi = 3.14;        |
| String | text                  | String name = "Aswin";   |
| bool   | true or false         | bool isLoggedIn = false; |
| var    | auto-detects the type | var city = "Kochi";      |

---

### What are Functions?

A function is a block of code that does something when you call it.

```dart
//simple function
void sayHello() {
  print("Hello, Flutter!");
}
//function that has parameters returns a value
int add(int a, int b) {
  return a + b;
}

//To call the function

sayHello();

int result = add(3, 5);
```

---

### Where do you write variables and functions?

You usually write them inside the State class if you’re using a StatefulWidget, like this:

```dart
class _HomeState extends State<Home> {
  TextEditingController controller = TextEditingController();

  // Variables go here
  String name = "";
  int count = 0;

  // Functions go here
  void increment() {
    setState(() {
      count++;
    });
  }

  String greetUser(String userName) {
    //if the value passed is Aswin greet with name
    if (userName == "Aswin") {
      return "Hello $userName";
    }
    //else just return a greeting message
    else {
      return "Hello User";
    }
  }

  @override
  Widget build(BuildContext context) {
    .
    .
    .
    .
  }
}

```

---

### How to call a Function?

Functions can be called while doing an action, like pressing a button.

```dart
Column(
    spacing: 10,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
    TextField(controller: controller),
    Container(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
        onPressed: () {
            //update value of name to the text we have typed
            setState(() {
            name = controller.text;
            });
            ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                // calling greetUser() by passing the name value will return the string according to the condition
                //the returned string is show in a snackbar
                content: Text(greetUser(name)),
                duration: Duration(seconds: 2),
            ),
            );
        },
        child: Text("Press here"),
        ),
    ),
    ],
)
 floatingActionButton: FloatingActionButton(
    onPressed: () {
        //increments the value of count
        increment();
        //as count is in we need to convert it as string to use on a Text() widget
        // for that use int_value.toString()
        ScaffoldMessenger.of(
        context,
        ).showSnackBar(SnackBar(content: Text(count.toString())));
    },
    child: Icon(Icons.add),
),
```

---

### What is setState()?

setState() tells Flutter to refresh the UI after a variable changes.

```dart
setState(() {
  name = controller.text;
});
```

This saves the text input into the name variable. Then it rebuilds the screen to reflect the new value. Without setState, Flutter won’t know the value changed!

---

### Summary Table

| Concept       | Meaning                     | In the Code                 |
| ------------- | --------------------------- | --------------------------- |
| Variable      | Stores a value              | String name = "";           |
| Function      | A block of reusable logic   | increment(), greetUser()    |
| Function Call | Using the function          | increment();                |
| setState()    | Tells Flutter to rebuild UI | setState(() { name = ... }) |

https://github.com/user-attachments/assets/bcead20e-2b78-4852-b98e-52a46eaae27e



