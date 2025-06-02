# Firebase Connection

## Table of contents

1. [What is Firebase?](#what-is-firebase)
2. [Firebase Authentication](#firebase-authentication-)
3. [Firebase Database](#firebase-databases-)
4. [Creating Firebase Project](#creating-firebase-project)
5. [Firebase Initialization](#firebase-initialization)

### What is Firebase?

Firebase is a comprehensive app development platform backed by Google. It provides a suite of tools and services to help developers build, improve, and grow their apps with ease. Think of it as a backend-as-a-service (BaaS) that handles many of the complexities of app infrastructure, allowing you to focus on the user experience.

### Firebase Authentication 🔑

Firebase Authentication offers a complete identity solution, making it simple to manage users in your application.

- **Easy Sign-In:** It supports authentication using email/password, phone numbers, and popular federated identity providers like Google, Facebook, Twitter, Apple, and GitHub. This means users can sign in using accounts they already have.
- **Security:** Built by the Google team responsible for Google Sign-in and Chrome Password Manager, it leverages Google's expertise in managing one of the world's largest account databases.
- **Customization & Management:** It provides SDKs and UI libraries to customize the sign-in experience and tools for user management, including password resets and email verification.
- **Integration:** Seamlessly integrates with other Firebase services, allowing you to control access to your data based on user identity.

### Firebase Databases 💾

Firebase offers two main NoSQL cloud-hosted database solutions: Cloud Firestore and the Realtime Database. Both provide realtime data synchronization, meaning data updates are pushed to connected clients automatically. We'll be using the Realtime Database in this project.

**Realtime Database**

- **Structure:** Stores data as one large JSON tree. This makes it very simple for basic data but can become harder to organize and query as data complexity grows.
- **Querying:** Offers simpler querying capabilities. Queries are deep by default (retrieving entire subtrees) and have more limited filtering and sorting options compared to Firestore.
- **Scalability:** Scales by sharding your data across multiple database instances. It's a regional solution.
  Offline Support: Provides offline support for Android and iOS.
- **Use Cases:** Well-suited for applications with simpler data models where extremely low latency and frequent state-syncing are critical.

### Creating Firebase project

This guide will walk you through the steps to create a new Firebase project using the Firebase console.

**1. Go to the Firebase Console:**

Open your web browser and navigate to the [Firebase console](https://console.firebase.google.com/). Sign in with your Google account if prompted.

**2. Add a New Project:**

On the Firebase console landing page, you'll see a list of your existing projects (if any). Click on the "Create a Firebase project".

![console](https://aswin-asokan.github.io/iste_bootcamp/images/firebase_console.png)

**3. Create the Project:**

- Type in a descriptive name for your project.
- Press continue
- on Configure Google Analytics choose **Default account for Firebase**
- The project is now created.

### Firebase Initialization

Before integrating Firebase, it's important to rename your app properly to avoid configuration conflicts.

To change the app name shown on the Android launcher:

1. Open `android/app/src/main/AndroidManifest.xml`
2. Modify the `android:label` property:

```xml
<application
    android:label="ToDos"  <!-- Change this to your app name -->
    android:name="${applicationName}"
    android:icon="@mipmap/ic_launcher">
```

To rename your app's package (also known as application ID), do the following:
**A. Update build.gradle.kts**  
Open `android/app/build.gradle.kts`

```kt
android {
    namespace = "com.example.todo_app" // Change this to your new package name

    defaultConfig {
        applicationId = "com.example.todo_app" // Change this too
        minSdk = 23
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }
}
```

> ⚠️ Keep the namespace and applicationId values the same to avoid confusion unless you have a reason to separate them.

**B. Update MainActivity Package Declaration**

- Go to: `android/app/src/main/kotlin/.../MainActivity.kt`
- Change the package line at the top to match your new package name:

```kt
package com.example.todo_app // Change this to match your new package name
```

**Change the App Title (Optional)**

- To change the app title displayed in the system task switcher:
- Open lib/main.dart
- Update the MaterialApp title:

```dart
MaterialApp(
  title: 'ToDos', // Change this
  ...
)
```

Then follow the steps,

- Open your project in VS Code (or other IDEs)
- In the terminal type the following commands

**1. Install Firebase CLI (Globally)**

Install Firebase Tools using npm:

```bash
npm i -g firebase-tools
```

**2. Login to your firebase account**

Authenticate your Firebase account.This will open a browser window for you to sign in with your Google account.

```bash
firebase login
```

**3. Activate flutterfire CLI**

FlutterFire CLI helps configure Firebase in Flutter projects. This only needs to be done once per system.

```bash
dart pub global activate flutterfire_cli
```

**4. Configure your project**

Run the following command inside your Flutter project directory:

```bash
flutterfire configure
```

![configure](https://aswin-asokan.github.io/iste_bootcamp/images/configure.png)

This will:

- Let you choose your Firebase project from the list
- Allow you to select platforms (Android, iOS, Web, macOS)
- Generate a firebase_options.dart file in your lib/ directory. This file contains public API keys (safe to commit) and is used to initialize Firebase in your app.

**5. Adding required dependencies**

Sometimes, your Flutter project may need external packages that are **not available by default**. To include these packages, you need to update your `pubspec.yaml` file.

**Method 1: Using VS Code (Recommended)**

1. Press `Ctrl + Shift + P` (or `Cmd + Shift + P` on macOS)
2. Select `Dart: Add Dependency`
3. Type the package name and hit Enter
4. VS Code automatically adds it to your `pubspec.yaml` and installs it

> For this project, add:

- `firebase_core`
- `firebase_auth`
- `firebase_database`

---

**Method 2: Using the CLI**

You can add dependencies directly from the terminal using:

```bash
flutter pub add <package_name>
```

Example:

```bash
flutter pub add firebase_core
```

**Method 3: Manually via pub.dev**

- Go to [Pub.dev](https://pub.dev/)
- Search for the package you want
- Copy the latest version or desired version
- Open `pubspec.yaml` and add under the **dependencies** section:

```yaml
dependencies:
  flutter:
    sdk: flutter
  #package_name: ^version
  firebase_core: ^3.13.1
  firebase_auth: ^5.5.4
  firebase_database: ^11.3.6
```

After saving the file, run:

```bash
flutter pub get
```

> ⚠️ Always make sure the version you use is compatible with your Flutter SDK.

**6. Initializing Firebase in your app**

To properly initialize Firebase before your Flutter app starts, you need to make your `main()` function `async`. This allows you to `await` the Firebase setup before running the app.

**Why make `main()` async?**

The `main()` function is the entry point of your app. Some initialization tasks — like setting up Firebase — require waiting for asynchronous operations to complete **before** the UI is built. By marking `main()` as `async`, you can ensure that Firebase is fully initialized **before** calling `runApp()`.
If you skip this, Firebase services (like auth or database) may throw errors because they're not fully initialized when the app starts.

```dart
//impor the dependencies
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/core/firebase_options.dart'; //change path according to your project
void main() async {//make main function as async
  // Ensure Flutter widgets are initialized before Firebase setup
  WidgetsFlutterBinding.ensureInitialized();

  // Wait for Firebase to initialize before running the app
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}
```

> 🛠️ Don't forget to import firebase_core.dart and your generated firebase_options.dart file.

This ensures Firebase is ready before your app UI starts rendering.

Also in your project page you can see the apps connected:

![apps_connected](https://aswin-asokan.github.io/iste_bootcamp/images/added_apps.png)
