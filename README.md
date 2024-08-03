# Q-Slope Calculator

An application that calculates the Q-slope of a rock to express the quality of the rock mass for slope stability.

## Tools and Technologies Used

-   **Flutter** (version: >=3.18.0-18.0.pre.54)
-   **Dart** (version: >=3.4.3 <4.0.0)
-   **VS Code**

## Prerequisites

-   Ensure that **Flutter** and **Dart** are installed on your system.
-   Make sure your Flutter setup is working correctly by running `flutter doctor`.
-   Set up a device to run your project. For Android, ensure you have a debugging-enabled Android device attached to your system.

## Steps To Run The Project

1. **Setup Environment Variables:**

    - Create a `.env` file in the root directory of the project.
    - Copy the contents of `.env.sample` into the `.env` file and modify them according to your requirements.

2. **Setup Project & Install Dependencies:**

    - Run the command `flutter pub get` to install the necessary dependencies.
    - Run the command `dart run husky install` to setup husky (git hooks).

3. **Run the Application:**

    - For running the application in debug mode on Windows or Web, use:
        ```sh
        flutter run -t lib/main.dart
        ```
    - For running the application in debug mode on Android, use:
        ```sh
        flutter run -t lib/main.dart --flavor dev
        ```

4. **Build APK:**
    - To create a release APK for the development flavor, use:
        ```sh
        flutter build apk -t lib/main.dart --flavor dev
        ```
    - To create a release APK for the production flavor:
        1. Ensure you have the `release.keystore` and `release-key.properties` files present in the `android/keys` folder with the appropriate values.
        2. Run the command:
            ```sh
            flutter build apk -t lib/main.dart --flavor prod
            ```
