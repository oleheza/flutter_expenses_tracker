Expenses tracker app

## Getting Started

1. Navigate to root folder of the project and run `flutter pub get` to get all required
   dependencies.
2. Run `flutter gen-l10n` to generate required localization files.
3. Run `flutter pub run build_runner build`. This command will generate required files for
   Injectable and Flutter BLoC.
4. Setup Firebase for the project.

## Tech Stack

1. `Flutter BLoC` and `freezed` for state management.
2. `GoRouter` for navigation.
3. `GetIt` and `Injectable` for dependency injection.
4. `Firebase Auth` and `Firebase Firestore`.
5. `Flutter localizations` and `intl` for localization.
6. `FlChart` for building charts.
7. `bloc_test` and `Mockito` for testing.
8. `Github Actions` and `Fastlane` for CI/CD.

## Features of the app

- [x] Native look and feel for Android (Material style) and iOS (Cupertino).
- [x] Integration with Firebase (Auth, Firestore, Crashlytics).
- [x] Sign in with Google.
- [x] Sign in with Facebook.
- [x] CRUD operations for user's expenses.
- [x] Displaying all the expenses in the list view.
- [x] Displaying all the expenses in Pie chart and daily expenses in Bar chart.
- [x] Light/Dark/System themes support with ability to change at runtime.
- [x] Bi-lingual support (English and Ukrainian) with ability to change the language at runtime.
- [x] Ability to delete user's data and account.
- [x] User profile management.
- [ ] CI/CD and Fastlane.

## Testing report

Run `run_test_with_report.sh` to run tests and generate the report.