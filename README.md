# ISTE Flutter Bootcamp

This repository contains the source code and documentation for the Flutter bootcamp project hosted by ISTE. The bootcamp covers the fundamental concepts of Flutter development and provides hands-on experience through tasks and examples. The final project is designed to integrate a login page, multi-page navigation, and online database connectivity.

## 📌 Description

This project is a part of the ISTE Flutter Bootcamp, focusing on building a simple Flutter application with basic user authentication, multi-page navigation, and an online database connection to manage user data and to-do tasks.

## 💬 Tasks Breakdown

1. Login Page

- The login page allows users to enter their credentials and authenticate their identity.

2. Multi-Page App

- Register: A page for new users to create an account.
- Home: The home page displays a list of to-dos with the ability to add new tasks. Users can manage their to-dos here.

3. Online Database Connection

- Connect the app to an online database to store user information and to-do data.
- Implement database read/write operations for tasks and user data.

## 🧾 Documentation

Complete documentation for the project is available [here](https://aswin-asokan.github.io/iste_bootcamp/).

## 📁 Project Structure - [todo_app Project](https://github.com/aswin-asokan/iste_bootcamp/tree/main/todo_app)

This outlines the structure of the `todo_app` Flutter project with Firebase integration and modular organization.

---

#### Root Folders

- **android/**, **ios/**, **linux/**, **macos/**, **windows/**, **web/**  
  Platform-specific folders containing native build configurations.

- **assets/**  
  Store images, fonts, and other static resources.

- **build/**  
  Auto-generated folder that contains the compiled app. Usually ignored in version control.

- **test/**  
  Contains unit and widget test files.

---

### Main Source Directory - `lib/`

#### `main.dart`

Entry point of the application. It initializes Firebase and sets up routing.

---

#### `core/`

Contains core configurations and constants.

- **firebase_options.dart**  
  Auto-generated Firebase initialization options file using `flutterfire configure`.

---

#### `features/`

Modular structure separating features for better maintainability.

#### `authentication/`

Handles all user authentication features.

- **screens/**
  - `login_page.dart` – UI for user login.
  - `register_page.dart` – UI for new user registration.
  - `forgot_password.dart` – Sends reset password email.

---

#### `home/`

Main task management screen.

- **screens/**

  - `home.dart` – Displays the list of tasks and navigation.

- **widgets/**
  - `task_bottom_sheet.dart` – Widget for adding/editing tasks via a modal bottom sheet.

---

#### `settings/`

Account and app settings screens.

- **screens/**

  - `change_mail.dart` – Change user email.
  - `update_password.dart` – Update password.
  - `delete_account.dart` – Delete user account.
  - `settings.dart` – Settings overview screen.

- **widgets/**
  - `account_card.dart` – Displays user account info.
  - `settings_tile.dart` – Reusable tile for settings options.

---

#### `shared/widgets/`

Reusable UI widgets shared across features.

- `bottomnavbar.dart` – Bottom navigation bar widget.
- `custom_button.dart` – Custom styled button.
- `custom_password_field.dart` – Password field with visibility toggle.
- `custom_text_field.dart` – Reusable text input field.

---

#### `services/`

Handles business logic and Firebase interactions.

- `auth_services.dart` – Firebase Authentication functions (sign in, register, logout, etc.).
- `authwrapper.dart` – Decides whether to show login or home based on auth state.
- `database_service.dart` – Handles CRUD operations for tasks in Realtime Database.

---

### Project Files

- **pubspec.yaml** – Project dependencies and asset declarations.
- **pubspec.lock** – Locked versions of dependencies.
- **firebase.json** – Firebase project config for web.
- **analysis_options.yaml** – Linting rules.
- **.metadata**, **.flutter-plugins-dependencies** – Flutter internal configs (should not be edited manually).

---
