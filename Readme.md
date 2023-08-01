# Home_modules for Android

Android wrapper for Home_modules web app.

## "Dev" branch

We are working on integration with the device controls API intoduced in SDK 30 (Android 11)

## Pre-built APKs

APK files are available at the releases section and in the actions section as artifacts.

## Getting Started

You can follow the following steps to build this app for yourself.

### Prerequisites

- [Git](https://git-scm.com/)
- A text editor or IDE, like [VSCode](https://code.visualstudio.com/) or [Android Studio](https://developer.android.com/studio)
  
- Flutter extension

- [Flutter SDK](https://flutter.dev)

- **Optional**: A custom keystore file

### Building

> **Warning**
>
> As of newer versions, release build process requires a custom keystore. You have to create & add the keystore on your own, or delete the code related to keystore in `android/app/build.gradle`
>
> You can still build the app in debug mode

```sh
git clone https://github.com/Home-modules/webapp-android # clone the repo
cd webapp-android # change directory into cloned repo
flutter pub get # install plugins
flutter build apk # build in release mode, Can be used for production
flutter build apk --debug # build in debug mode, no keystore required. DON'T USE FOR PRODUCTION!
```

The APK file will be in `build/app/outputs/app/flutter-apk/`

### Contributing

All pull requests, forks and issues are welcomed here!

### iOS

We haven't tried iOS builds yet. We'll welcome any suggeations/reports on iOS builds
