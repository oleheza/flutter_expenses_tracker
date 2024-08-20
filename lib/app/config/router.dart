import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../auth/presentation/auth_screen.dart';
import '../../core/di/injector.dart';
import '../../create_or_update_expenses/presentation/create_or_update_expenses_screen.dart';
import '../../forgot_password/presentation/forgot_password_screen.dart';
import '../../home/home_screen.dart';
import '../../profile/edit/presentation/edit_profile_screen.dart';
import '../bloc/app_bloc.dart';

final router = GoRouter(
  routes: <GoRoute>[
    GoRoute(
      path: HomeScreen.route,
      name: HomeScreen.screenName,
      builder: (_, __) => HomeScreen(
        authRepository: getIt(),
        settingsRepository: getIt(),
        expensesRepository: getIt(),
        profileRepository: getIt(),
        logoutUseCase: getIt(),
        deleteAccountUseCase: getIt(),
      ),
    ),
    GoRoute(
      path: AuthScreen.route,
      name: AuthScreen.screenName,
      builder: (_, __) => AuthScreen(
        signInUseCase: getIt(),
        signUpUseCase: getIt(),
        getGoogleAuthCredentialsUseCase: getIt(),
        getFacebookAuthCredentialsUseCase: getIt(),
        signInWithCredentialsUseCase: getIt(),
        createProfileUseCase: getIt(),
        validator: getIt(),
      ),
    ),
    GoRoute(
      path: CreateOrUpdateExpensesScreen.route,
      name: CreateOrUpdateExpensesScreen.screenName,
      builder: (_, state) {
        final originalExpensesId = state.extra as String?;
        return CreateOrUpdateExpensesScreen(
          authRepository: getIt(),
          settingsRepository: getIt(),
          addExpensesUseCase: getIt(),
          getExpensesByIdUseCase: getIt(),
          updateExpensesUseCase: getIt(),
          originalExpensesId: originalExpensesId,
        );
      },
    ),
    GoRoute(
      path: EditProfileScreen.route,
      name: EditProfileScreen.screenName,
      builder: (_, __) => EditProfileScreen(
        authRepository: getIt(),
        getProfileByUserIdUseCase: getIt(),
        editProfileUseCase: getIt(),
      ),
    ),
    GoRoute(
      path: ForgotPasswordScreen.route,
      name: ForgotPasswordScreen.screenName,
      builder: (_, __) => ForgotPasswordScreen(
        forgotPasswordUseCase: getIt(),
        validator: getIt(),
      ),
    )
  ],
  debugLogDiagnostics: true,
  redirect: (ctx, state) async {
    final isLoggedIn = ctx.read<AppBloc>().state.isLoggedIn;
    final route = state.fullPath;
    return isLoggedIn || route == ForgotPasswordScreen.route
        ? null
        : AuthScreen.route;
  },
);
