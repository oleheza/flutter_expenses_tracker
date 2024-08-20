import 'package:expenses_tracker/auth/domain/use_case/create_profile_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_facebook_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_google_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_with_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_up_use_case.dart';
import 'package:expenses_tracker/auth/presentation/auth_screen.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/user_model.dart';
import 'package:expenses_tracker/core/domain/validator/validator.dart';
import 'package:expenses_tracker/core/presentation/build_context_extensions.dart';
import 'package:expenses_tracker/core/presentation/widget_keys.dart';
import 'package:expenses_tracker/forgot_password/presentation/forgot_password_screen.dart';
import 'package:expenses_tracker/home/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';

import '../../core/presentation/testable_widget.dart';
import '../../fake_data/fake_data.dart';
import '../../mocks/firebase_mocks.mocks.dart';
import '../../mocks/third_party_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';
import 'auth_robot.dart';

void main() {
  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late GetGoogleAuthCredentialsUseCase getGoogleAuthCredentialsUseCase;
  late GetFacebookAuthCredentialsUseCase getFacebookAuthCredentialsUseCase;
  late SignInWithCredentialsUseCase signInWithCredentialsUseCase;
  late CreateProfileUseCase createProfileUseCase;
  late GoRouter goRouter;
  final Validator validator = Validator();

  setUp(() {
    goRouter = MockGoRouter();
    signInUseCase = MockSignInUseCase();
    signUpUseCase = MockSignUpUseCase();
    getGoogleAuthCredentialsUseCase = MockGetGoogleAuthCredentialsUseCase();
    getFacebookAuthCredentialsUseCase = MockGetFacebookAuthCredentialsUseCase();
    signInWithCredentialsUseCase = MockSignInWithCredentialsUseCase();
    createProfileUseCase = MockCreateProfileUseCase();

    provideDummy<Either<Failure, UserModel?>>(Right(fakeUser));
  });

  Widget createTestableWidget() {
    return TestableWidget(
      mockGoRouter: goRouter,
      child: AuthScreen(
        signInUseCase: signInUseCase,
        signUpUseCase: signUpUseCase,
        getGoogleAuthCredentialsUseCase: getGoogleAuthCredentialsUseCase,
        getFacebookAuthCredentialsUseCase: getFacebookAuthCredentialsUseCase,
        signInWithCredentialsUseCase: signInWithCredentialsUseCase,
        createProfileUseCase: createProfileUseCase,
        validator: validator,
      ),
    );
  }

  testWidgets('test auth screen has correct widgets', (tester) async {
    await tester.pumpWidget(createTestableWidget());

    final context = tester.element(find.byType(Scaffold));

    final authRobot = AuthRobot(tester: tester);

    expect(find.text(context.tr.welcomeMessage), findsOneWidget);
    expect(
      find.text('-${context.tr.loginUsingSocialNetworks}-'),
      findsOneWidget,
    );
    expect(find.byKey(WidgetKeys.authEmailKey), findsOneWidget);
    expect(find.byKey(WidgetKeys.authPasswordKey), findsOneWidget);
    expect(find.text(context.tr.signIn), findsOneWidget);
    expect(find.text(context.tr.dontHaveAccount), findsOneWidget);
    expect(find.byKey(WidgetKeys.authForgotPasswordKey), findsOneWidget);

    await authRobot.clickSwitchSignInModeButton();

    expect(find.text(context.tr.signUp), findsOneWidget);
    expect(find.text(context.tr.alreadyHaveAccount), findsOneWidget);
  });

  Future<void> testSignInFailure(
    WidgetTester tester,
    AuthFailureReason reason,
    String expectedMessage,
  ) async {
    final failure = Failure.signInFailed(reason: reason);

    provideDummy<Either<Failure, UserModel?>>(Left(failure));

    when(signInUseCase.execute(fakeAuthUseCaseParams))
        .thenAnswer((_) async => Left(failure));

    final authRobot = AuthRobot(tester: tester);

    await authRobot.enterEmail(fakeEmail);
    await authRobot.enterPassword(fakePassword);
    await authRobot.clickSignInButton();

    verify(signInUseCase.execute(fakeAuthUseCaseParams)).called(1);

    expect(find.text(expectedMessage), findsOneWidget);

    verify(goRouter.pop()).called(1);
  }

  Future<void> testSignUpFailure(
    WidgetTester tester,
    AuthFailureReason reason,
    String expectedMessage,
  ) async {
    final failure = Failure.signUpFailed(reason: reason);

    provideDummy<Either<Failure, UserModel?>>(Left(failure));

    when(signUpUseCase.execute(fakeAuthUseCaseParams))
        .thenAnswer((_) async => Left(failure));

    final authRobot = AuthRobot(tester: tester);

    await authRobot.enterEmail(fakeEmail);
    await authRobot.enterPassword(fakePassword);
    await authRobot.clickSwitchSignInModeButton();
    await authRobot.clickSignInButton();

    verify(signUpUseCase.execute(fakeAuthUseCaseParams)).called(1);

    expect(find.text(expectedMessage), findsOneWidget);

    await authRobot.clickOkInDialog();
  }

  testWidgets(
    'test sign in with wrong credentials returns correct error',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());
      final context = tester.element(find.byType(Scaffold));

      await testSignInFailure(
        tester,
        const AuthFailureReason.invalidCredential(),
        context.tr.wrongCredentials,
      );
    },
  );

  testWidgets(
    'test sign in user not found returns correct error',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());
      final context = tester.element(find.byType(Scaffold));

      await testSignInFailure(
        tester,
        const AuthFailureReason.userNotFound(),
        context.tr.userNotFound,
      );
    },
  );

  testWidgets(
    'test sign wrong password returns correct error',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());
      final context = tester.element(find.byType(Scaffold));

      await testSignInFailure(
        tester,
        const AuthFailureReason.wrongPassword(),
        context.tr.wrongPassword,
      );
    },
  );

  testWidgets(
      'test sign in accounts exists with different credentials returns correct error',
      (tester) async {
    await tester.pumpWidget(createTestableWidget());
    final context = tester.element(find.byType(Scaffold));

    await testSignInFailure(
      tester,
      const AuthFailureReason.accountAlreadyExistsWithDifferentCredentials(),
      context.tr.accountInUseWithDifferentCredentials,
    );
  });

  testWidgets('test sign in unknown failure returns correct error',
      (tester) async {
    await tester.pumpWidget(createTestableWidget());
    final context = tester.element(find.byType(Scaffold));

    await testSignInFailure(
      tester,
      const AuthFailureReason.unknown(),
      context.tr.unknownFailure,
    );
  });

  testWidgets(
    'test successful sign in navigates to home screen',
    (tester) async {
      when(signInUseCase.execute(fakeAuthUseCaseParams))
          .thenAnswer((_) async => Right(fakeUser));

      await tester.pumpWidget(createTestableWidget());

      final authRobot = AuthRobot(tester: tester);

      await authRobot.enterEmail(fakeEmail);
      await authRobot.enterPassword(fakePassword);
      await authRobot.clickSignInButton();

      verify(signInUseCase.execute(fakeAuthUseCaseParams)).called(1);
      verify(goRouter.pushReplacementNamed(HomeScreen.screenName)).called(1);
    },
  );

  testWidgets(
    'test successful sign in with facebook navigates to home screen',
    (tester) async {
      final authCredential = MockAuthCredential();

      provideDummy<Either<Failure, AuthCredential?>>(Right(authCredential));
      provideDummy<Either<Failure, void>>(const Right(null));

      when(getFacebookAuthCredentialsUseCase.execute(null))
          .thenAnswer((_) async => Right(MockAuthCredential()));
      when(signInWithCredentialsUseCase.execute(authCredential)).thenAnswer(
        (_) async => Right(fakeUser),
      );

      await tester.pumpWidget(createTestableWidget());

      final authRobot = AuthRobot(tester: tester);

      await authRobot.clickSignInWithFacebookButton();

      verify(goRouter.pushReplacementNamed(HomeScreen.screenName)).called(1);
    },
  );

  testWidgets(
    'test successful sign in with google navigates to home screen',
    (tester) async {
      final authCredential = MockAuthCredential();

      provideDummy<Either<Failure, AuthCredential?>>(Right(authCredential));
      provideDummy<Either<Failure, void>>(const Right(null));

      when(getGoogleAuthCredentialsUseCase.execute(null))
          .thenAnswer((_) async => Right(authCredential));
      when(signInWithCredentialsUseCase.execute(authCredential)).thenAnswer(
        (_) async => Right(fakeUser),
      );

      await tester.pumpWidget(createTestableWidget());

      final authRobot = AuthRobot(tester: tester);

      await authRobot.clickSignInWithGoogleButton();

      verify(goRouter.pushReplacementNamed(HomeScreen.screenName)).called(1);
    },
  );

  testWidgets(
    'test forgot password click navigates to proper screen',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final authRobot = AuthRobot(tester: tester);

      await authRobot.clickForgotPasswordButton();

      verify(goRouter.pushNamed(ForgotPasswordScreen.screenName)).called(1);
    },
  );

  testWidgets(
    'test failed sign up weak password returns correct failure',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(Scaffold));

      testSignUpFailure(
        tester,
        const AuthFailureReason.passwordTooWeak(),
        context.tr.passwordTooWeak,
      );
    },
  );

  testWidgets(
    'test failed sign up email in use returns correct failure',
    (tester) async {
      await tester.pumpWidget(createTestableWidget());

      final context = tester.element(find.byType(Scaffold));

      testSignUpFailure(
        tester,
        const AuthFailureReason.emailInUse(),
        context.tr.emailInUse,
      );
    },
  );
}
