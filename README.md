# Simple Blogging App
The Simple Blogging App is a mobile application that allows users to read, write, edit, and delete their own blog posts. The app is built using the Flutter framework, a popular open-source mobile app development SDK that enables developers to build high-performance, cross-platform apps for iOS and Android.


> **Note:** This project uses Firebase, A Node.js version of this project can be found on [**main**](https://github.com/shivanuj13/simple_blogger/tree/main) branch.

>**Release APK** for this version can be found [here(v0.0.2)](https://github.com/shivanuj13/simple_blogger/releases/tag/v0.0.2).

## Screenshots
<p align="center">
  <img src="./assets/screenshots/sign_in.png" width="200" alt="Login Screen">
    <img src="./assets/screenshots/sign_up.png" width="200" alt="Sign Up Screen">
    <img src="./assets/screenshots/home.png" width="200" alt="Home Screen">
    <img src="./assets/screenshots/profile.png" width="200" alt="Profile Screen">
    <img src="./assets/screenshots/post_editor.png" width="200" alt="Create Post Screen">
    <img src="./assets/screenshots/post.png" width="200" alt="Edit Post Screen">
    <img src="./assets/screenshots/search.png" width="200" alt="Edit Post Screen">
</p>

## Features
- User authentication with Firebase Authentication
- User profile management with Firebase Cloud Firestore
- Blog post management with Firebase Cloud Firestore
- Blog post image upload with Firebase Cloud Storage
- Simple and minimal UI design
- Fluid animations

## Requirements
- Android 5.0 (Lollipop) and above.
- Android SDK installed on the development environment. See the [Android SDK installation guide](https://developer.android.com/studio) for more details.
- Flutter framework installed. See the [Flutter installation guide](https://flutter.dev/docs/get-started/install) for more details.
- Firebase account with enabled Authentication, Cloud Firestore and Cloud Storage. See the [Firebase documentation](https://firebase.google.com/docs) for more details.
## Getting Started
- Clone the repository and open the project in your favorite IDE.
- Set up a Firebase project and enable Authentication, Cloud Firestore and Cloud Storage.
Add the Firebase configuration file to the android/app directory.
- Run the following command to install the required packages:
```bash
flutter pub get
```
- Run the app on an Android device or emulator. by running the following command:
```bash
flutter run
```

## Contributing
Contributions are welcome! If you find any bugs or have suggestions for new features, feel free to open an issue or submit a pull request.

## License
The Simple Blogging App is released under the MIT License. Feel free to use and modify the code for your own projects.