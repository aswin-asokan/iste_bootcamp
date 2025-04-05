# Setting up the Project

## Table of contents

1. [Setting up a Flutter project](#setting-up-a-flutter-project)
2. [Creating first project](#creating-first-project)
3. [Making changes to the default app](#making-changes-to-the-default-app)
4. [Creating a new page](#creating-a-new-page)

---

### Setting up a Flutter project

**Required extensions in VS Code**

- **Open Extensions Panel**

  Click on the Extensions icon in the side panel **OR** use the shortcut: `Ctrl + Shift + X`

- **Install Flutter & Dart Extensions**

  - In the search bar, type **"Flutter"** and install the Flutter extension.

  ![extension-flutter](https://aswin-asokan.github.io/iste_bootcamp/images/extension-flutter.png)

  - This will also prompt the installation of the **Dart** extension—install it as well.

  ![extension-dart](https://aswin-asokan.github.io/iste_bootcamp/images/extension-dart.png)

---

### Creating first project

**1. Open your terminal or command prompt and run**

```dart
flutter create project_name
```

![new-project](https://aswin-asokan.github.io/iste_bootcamp/images/new-project.png)

**2. Open the Project in VS Code**

![vs-code](https://aswin-asokan.github.io/iste_bootcamp/images/vs-code.png)

**3. Understanding the Project Structure**

The lib/ directory contains the source code for your application.

![lib](https://aswin-asokan.github.io/iste_bootcamp/images/lib.png)

**4. Running the Auto-Generated App**

We can run the auto generated app by typing:

```dart
flutter run
```

- Choose a connected device to run the app.
  On a Linux-based system, select Linux.
- On Windows, if you haven’t set up the Android SDK, you can run it on a browser (preferably Microsoft Edge).

![first-app](https://aswin-asokan.github.io/iste_bootcamp/images/first-app.png)

---

### Making changes to the default app

Modify the title or text in <span style="color:green">lib/main.dart</span>. Save the file to apply the changes.

**Hot reload and Hot restart:**

In the terminal:

- Press **r** (Hot reload): Reloads only the changed parts without losing the app state. Ideal for minor UI updates.
- Press **R** (Hot restart): Restarts the entire app, resetting the state. Use this when Hot Reload fails or after major changes.

---

### Creating a new page

In <span style="color:green">lib/main.dart</span> the **home: property of MaterialApp()** directs us to the first page of the application which is set as <span style="color:deepskyblue">MyHomePage</span>. Remove the code for <span style="color:deepskyblue">MyHomePage</span> starting from line 38.

```dart
class MyHomePage extends StatefulWidget {
 const MyHomePage({super.key, required this.title});
 final String title;
 @override
 State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
 int _counter = 0;
 void _incrementCounter() {
   setState(() {
     _counter++;
.
.
.
floatingActionButton: FloatingActionButton(
       onPressed: _incrementCounter,
       tooltip: 'Increment',
       child: const Icon(Icons.add),
     ),
   );
 }
}
```

1. On <span style="color:green">lib/</span> folder create a new file that’ll be set as the new initial screen like, <span style="color:green">lib/home.dart</span>.
2. Open the new file and type st vs code will generate some recommendations, mainly: Flutter Stateful Widget and Flutter Stateless Widget

   **Stateless vs Stateful widgets:**

   - **Stateless widgets:** The widget’s state remains constant. Ideal for displaying static content like **text, images, and icons**.
   - **Stateful widgets:** The widget’s state can change over time. Used for interactive elements like **buttons, text fields, and animations**.

Choose Stateful widget for now, this will automatically generate a code block.Modify the class name to match the file name. Change

```dart
return const Placeholder();
```

to

```dart
return const Scaffold();
```

To update main.dart to use the new HomeScreen Class, in main.dart change

```dart
const MyHomePage(title: 'Flutter Demo Home Page')
```

to

```dart
Home()// give your class name
```

like this,

```dart
import 'package:bootcamp/home.dart';
import 'package:flutter/material.dart';
void main() {
 runApp(const MyApp());
}
class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
 Widget build(BuildContext context) {
   return MaterialApp(
     title: 'Flutter Demo',
     theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
     ),
     home: Home(), // give your class name
   );
 }
}
```

Reload the application to apply the changes.
