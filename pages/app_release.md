# Releasing an application

## Table of contents

1. [Flutter Release Build Guide](#flutter-release-build-guide)
   1.1. [Android](#-android-build-release-apk--app-bundle)
   1.2. [iOS](#-ios-build-release-app-macos-only)
   1.3. [Web](#-web-build-release-web-app)
   1.4. [Windows](#-windows-build-release-exe)
   1.5. [macOS](#-macos-build-release-app-macos-only)
   1.6. [Linux](#-linux-build-release-app)
2. [Changing App Icon (Done before building, if needed)](#how-to-change-app-icon-in-flutter-manual--package-methods)
   2.1. [Method 1: Package](#method-1-using-a-package-flutter_launcher_icons)
   2.2. [Method 2: Manually](#method-2-manual-icon-replacement-all-platforms)
   - [Android](#-android)
   - [iOS](#-ios)
   - [Web](#-web)
   - [Windows](#-windows)
   - [macOS](#-macos)
   - [Linux](#-linux)

## Flutter Release Build Guide

This guide helps you build a **release version** of your Flutter app for each platform: **Android, iOS, Web, Windows, macOS, and Linux**.

### Common Preparation Steps (All Platforms)

1. **Run Tests & Fix Issues**

   ```bash
   flutter analyze
   flutter test
   ```

2. **Minimize Debug Prints**

   - Remove or wrap `print()` statements with `kDebugMode`.

3. **Switch to Release Mode**
   - Always use `--release` for optimized builds.

---

### 📱 Android: Build Release APK / App Bundle

#### Set Version in `pubspec.yaml`

```yaml
version: 1.0.0+1
```

#### Build APK or AAB

- APK (for testing)::
  ```bash
  flutter build apk --release
  ```
- AAB (for Play Store):
  ```bash
  flutter build appbundle --release
  ```

### 🔹 4. Output Location

- APK: `build/app/outputs/flutter-apk/app-release.apk`
- AAB: `build/app/outputs/bundle/release/app-release.aab`

---

### 🍏 iOS: Build Release App (macOS only)

#### Open iOS project in Xcode

```bash
open ios/Runner.xcworkspace
```

#### Configure Signing

- Set **Team**, **Bundle ID**, and enable **automatic signing** in Xcode.

#### Archive and Upload

- Select _Any iOS Device (arm64)_ → `Product > Archive` in Xcode.
- Upload via Xcode Organizer.

Or:

```bash
flutter build ios --release
```

---

### 🌐 Web: Build Release Web App

```bash
flutter build web --release
```

#### Output

`build/web/` — HTML, CSS, and JS files ready for hosting.

Deploy on:

- Firebase Hosting
- GitHub Pages
- Netlify / Vercel

---

### 💻 Windows: Build Release EXE

```bash
flutter build windows --release
```

#### Output

`build/windows/runner/Release/`

> ⚠️ Must be run on Windows.

---

### 🍎 macOS: Build Release App (macOS only)

```bash
flutter build macos --release
```

#### Output

`build/macos/Build/Products/Release/Runner.app`

> You can zip this `.app` or convert to `.dmg`.

---

### 🐧 Linux: Build Release App

```bash
flutter build linux --release
```

#### Output

`build/linux/x64/release/bundle/`

> Contains binary and all dependencies.

---

### 🧹 Clean Build (Optional)

```bash
flutter clean
flutter pub get
```

---

## How to Change App Icon in Flutter (Manual + Package Methods)

Flutter allows you to change app icons for each platform either **manually** or using a **helper package** like `flutter_launcher_icons`. This guide covers both.

---

### Method 1: Using a Package (flutter_launcher_icons)

#### Step-by-Step

1. **Add Dependency** in `pubspec.yaml`:

   ```yaml
   dev_dependencies:
     flutter_launcher_icons: ^0.14.3

   flutter_icons:
     android: true
     ios: true
     image_path: "assets/icon/app_icon.png"
   ```

2. **Run Command**:

   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons:main
   ```

3. Your app icon is now generated for Android and iOS.

---

### Method 2: Manual Icon Replacement (All Platforms)

#### 🟢 Android

1. **Prepare Sizes** or use [appicon.co](https://appicon.co)

   - mdpi: 48×48
   - hdpi: 72×72
   - xhdpi: 96×96
   - xxhdpi: 144×144
   - xxxhdpi: 192×192

2. **Replace Files** in:

   ```
   android/app/src/main/res/mipmap-*/ic_launcher.png
   ```

3. **Optional**: Replace adaptive icons (`ic_launcher_foreground.png` and `background.xml`).

---

### 🍏 iOS

1. **Prepare** multiple sizes or use [appicon.co](https://appicon.co)
2. Replace files in:
   ```
   ios/Runner/Assets.xcassets/AppIcon.appiconset/
   ```
3. Update `Contents.json` if needed.

---

### 🌐 Web

1. Replace files in `web/`:

   - `favicon.png`
   - `icons/Icon-192.png`
   - `icons/Icon-512.png`

2. Update `manifest.json` if needed.

---

### 💻 Windows

1. Convert PNG to `.ico` (use [convertico](https://convertico.com))
2. Replace:
   ```
   windows/runner/resources/app_icon.ico
   ```
3. In `windows/CMakeLists.txt`:
   ```cmake
   set(WINDOWS_ICON_PATH "runner/resources/app_icon.ico")
   ```

---

### 🍎 macOS

1. Convert PNG to `.icns` using:
   ```bash
   iconutil -c icns AppIcon.iconset
   ```
2. Replace in:
   ```
   macos/Runner/Assets.xcassets/AppIcon.appiconset/
   ```

---

### 🐧 Linux

1. Place icon (e.g., `icon.png`) in:
   ```
   linux/icons/
   ```
2. Update in `linux/CMakeLists.txt`:
   ```cmake
   set(FLUTTER_APP_ICON "icons/icon.png")
   ```

---

## 📦 Summary

| Platform | Manual Icon Path           | Automatic via Package |
| -------- | -------------------------- | --------------------- |
| Android  | `res/mipmap-*`             | ✅ Yes                |
| iOS      | `AppIcon.appiconset`       | ✅ Yes                |
| Web      | `web/icons/`               | ❌ Manual only        |
| Windows  | `.ico in runner/`          | ❌ Manual only        |
| macOS    | `.icns in Assets.xcassets` | ❌ Manual only        |
| Linux    | `linux/icons/`             | ❌ Manual only        |

---

**Tip**: Use high-resolution (1024×1024) PNG with transparent background for best results.
