import 'package:bloc_test/bloc_test.dart';
import 'package:expenses_tracker/auth/bloc/auth_bloc.dart';
import 'package:expenses_tracker/auth/domain/use_case/create_profile_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_facebook_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_google_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_with_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_up_use_case.dart';
import 'package:expenses_tracker/core/domain/failure/auth_failure_reason.dart';
import 'package:expenses_tracker/core/domain/failure/failure.dart';
import 'package:expenses_tracker/core/domain/model/user_model.dart';
import 'package:expenses_tracker/core/domain/validator/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import '../../mocks/firebase_mocks.mocks.dart';
import '../../mocks/use_case_mocks.mocks.dart';

void main() {
  late AuthBloc authBloc;
  late SignInUseCase signInUseCase;
  late SignUpUseCase signUpUseCase;
  late GetGoogleAuthCredentialsUseCase getGoogleAuthCredentialsUseCase;
  late GetFacebookAuthCredentialsUseCase getFacebookAuthCredentialsUseCase;
  late SignInWithCredentialsUseCase signInWithCredentialsUseCase;
  late CreateProfileUseCase createProfileUseCase;
  late Validator validator;

  const signUpFailure = Failure.signUpFailed(
    reason: AuthFailureReason.emailInUse(),
  );

  const signInFailure = Failure.signInFailed(
    reason: AuthFailureReason.userNotFound(),
  );

  final authCredential = MockAuthCredential();

  const email = fakeEmail;
  const password = fakePassword;
  const authUseCaseParams = fakeAuthUseCaseParams;

  setUp(() {
    provideDummy<Either<Failure, UserModel?>>(Right(fakeUser));
    provideDummy<Either<Failure, UserModel?>>(const Left(signUpFailure));
    provideDummy<Either<Failure, UserModel?>>(const Left(signInFailure));
    provideDummy<Either<Failure, AuthCredential?>>(Right(authCredential));
    provideDummy<Either<Failure, void>>(const Right(null));

    signInUseCase = MockSignInUseCase();
    signUpUseCase = MockSignUpUseCase();
    getGoogleAuthCredentialsUseCase = MockGetGoogleAuthCredentialsUseCase();
    getFacebookAuthCredentialsUseCase = MockGetFacebookAuthCredentialsUseCase();
    signInWithCredentialsUseCase = MockSignInWithCredentialsUseCase();
    createProfileUseCase = MockCreateProfileUseCase();
    validator = Validator();

    authBloc = AuthBloc(
      signInUseCase: signInUseCase,
      signUpUseCase: signUpUseCase,
      getGoogleAuthCredentialsUseCase: getGoogleAuthCredentialsUseCase,
      getFacebookAuthCredentialsUseCase: getFacebookAuthCredentialsUseCase,
      signInWithCredentialsUseCase: signInWithCredentialsUseCase,
      createProfileUseCase: createProfileUseCase,
      validator: validator,
    );
  });

  blocTest(
    'verify inputs validation is correct',
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
      ];
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign in/sign up switch is correct',
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.signInModeChanged());
      bloc.add(const AuthEvent.signInModeChanged());
    },
    expect: () {
      return <AuthState>[
        const AuthState(isSignIn: false),
        const AuthState(isSignIn: true),
      ];
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign in is correct',
    setUp: () {
      when(signInUseCase.execute(authUseCaseParams))
          .thenAnswer((_) async => Right(fakeUser));
    },
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
      bloc.add(const AuthEvent.authorize());
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: true,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
          authenticated: true,
        ),
      ];
    },
    verify: (bloc) {
      verify(signInUseCase.execute(authUseCaseParams)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign in failure handled correct in state',
    setUp: () {
      when(signInUseCase.execute(authUseCaseParams)).thenAnswer(
        (_) async => const Left(signInFailure),
      );
    },
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
      bloc.add(const AuthEvent.authorize());
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: true,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
          failure: signInFailure,
        ),
      ];
    },
    verify: (bloc) {
      verify(signInUseCase.execute(authUseCaseParams)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign up is correct',
    setUp: () {
      when(signUpUseCase.execute(authUseCaseParams))
          .thenAnswer((_) async => Right(fakeUser));
    },
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
      bloc.add(const AuthEvent.signInModeChanged());
      bloc.add(const AuthEvent.authorize());
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isSignIn: false,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isSignIn: false,
          isLoading: true,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
          isSignIn: false,
          authenticated: true,
        ),
      ];
    },
    verify: (bloc) {
      verify(signUpUseCase.execute(authUseCaseParams)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign up failure handled correct in state',
    setUp: () {
      when(signUpUseCase.execute(authUseCaseParams)).thenAnswer(
        (_) async => const Left(signUpFailure),
      );
    },
    build: () => authBloc,
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
      bloc.add(const AuthEvent.signInModeChanged());
      bloc.add(const AuthEvent.authorize());
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isSignIn: false,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: true,
          isSignIn: false,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
          isSignIn: false,
          failure: signUpFailure,
        ),
      ];
    },
    verify: (bloc) {
      verify(signUpUseCase.execute(authUseCaseParams)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign in with Google is correct',
    build: () => authBloc,
    setUp: () {
      when(getGoogleAuthCredentialsUseCase.execute(null)).thenAnswer(
        (_) async => Right(authCredential),
      );
      when(signInWithCredentialsUseCase.execute(authCredential)).thenAnswer(
        (_) async => Right(fakeUser),
      );
    },
    act: (bloc) {
      bloc.add(const AuthEvent.signInWithGoogle());
    },
    expect: () {
      return <AuthState>[
        const AuthState(isLoading: true),
        const AuthState(authenticated: true, isLoading: false),
      ];
    },
    verify: (bloc) {
      verify(getGoogleAuthCredentialsUseCase.execute(null)).called(1);
      verify(signInWithCredentialsUseCase.execute(authCredential)).called(1);
      verify(createProfileUseCase.execute(fakeProfile)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify sign in with Facebook is correct',
    build: () => authBloc,
    setUp: () {
      when(getFacebookAuthCredentialsUseCase.execute(null)).thenAnswer(
        (_) async => Right(authCredential),
      );
      when(signInWithCredentialsUseCase.execute(authCredential)).thenAnswer(
        (_) async => Right(fakeUser),
      );
    },
    act: (bloc) {
      bloc.add(const AuthEvent.signInWithFacebook());
    },
    expect: () {
      return <AuthState>[
        const AuthState(isLoading: true),
        const AuthState(authenticated: true, isLoading: false),
      ];
    },
    verify: (bloc) {
      verify(getFacebookAuthCredentialsUseCase.execute(null)).called(1);
      verify(signInWithCredentialsUseCase.execute(authCredential)).called(1);
      verify(createProfileUseCase.execute(fakeProfile)).called(1);
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify failed sign in with credentials provides correct state',
    build: () => authBloc,
    setUp: () {
      when(getFacebookAuthCredentialsUseCase.execute(null)).thenAnswer(
        (_) async => Right(authCredential),
      );
      when(signInWithCredentialsUseCase.execute(authCredential)).thenAnswer(
        (_) async => const Left(signInFailure),
      );
    },
    act: (bloc) {
      bloc.add(const AuthEvent.signInWithFacebook());
    },
    expect: () {
      return <AuthState>[
        const AuthState(isLoading: true),
        const AuthState(
          isLoading: false,
          failure: signInFailure,
        ),
      ];
    },
    verify: (bloc) {
      verify(getFacebookAuthCredentialsUseCase.execute(null)).called(1);
      verify(signInWithCredentialsUseCase.execute(authCredential)).called(1);
      verifyNever(createProfileUseCase.execute(fakeProfile));
    },
    tearDown: () => authBloc.close(),
  );

  blocTest(
    'verify failure checked provides correct state',
    build: () => authBloc,
    setUp: () {
      when(signInUseCase.execute(authUseCaseParams)).thenAnswer(
        (_) async => const Left(signInFailure),
      );
    },
    act: (bloc) {
      bloc.add(const AuthEvent.emailChanged(email: email));
      bloc.add(const AuthEvent.passwordChanged(password: password));
      bloc.add(const AuthEvent.authorize());
      bloc.add(const AuthEvent.failureChecked());
    },
    expect: () {
      return <AuthState>[
        const AuthState(email: email, isValid: false),
        const AuthState(email: email, password: password, isValid: true),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: true,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
          failure: signInFailure,
        ),
        const AuthState(
          email: email,
          password: password,
          isValid: true,
          isLoading: false,
        ),
      ];
    },
  );
}
