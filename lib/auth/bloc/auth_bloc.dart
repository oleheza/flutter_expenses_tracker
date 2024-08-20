import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/domain/failure/failure.dart';
import '../../core/domain/model/profile_model.dart';
import '../../core/domain/model/user_model.dart';
import '../../core/domain/validator/validator.dart';
import '../domain/use_case/create_profile_use_case.dart';
import '../domain/use_case/get_facebook_auth_credentials_use_case.dart';
import '../domain/use_case/get_google_auth_credentials_use_case.dart';
import '../domain/use_case/params/auth_use_case_params.dart';
import '../domain/use_case/sign_in_use_case.dart';
import '../domain/use_case/sign_in_with_credentials_use_case.dart';
import '../domain/use_case/sign_up_use_case.dart';

part 'auth_bloc.freezed.dart';
part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetGoogleAuthCredentialsUseCase getGoogleAuthCredentialsUseCase;
  final GetFacebookAuthCredentialsUseCase getFacebookAuthCredentialsUseCase;
  final SignInWithCredentialsUseCase signInWithCredentialsUseCase;
  final CreateProfileUseCase createProfileUseCase;
  final Validator validator;

  AuthBloc({
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getGoogleAuthCredentialsUseCase,
    required this.getFacebookAuthCredentialsUseCase,
    required this.signInWithCredentialsUseCase,
    required this.createProfileUseCase,
    required this.validator,
  }) : super(const AuthState()) {
    on<AuthEvent>(
      (event, emit) async {
        await event.when(
          emailChanged: (email) async {
            _onEmailChanged(email ?? '', emit);
          },
          passwordChanged: (password) async {
            _onPasswordChanged(password ?? '', emit);
          },
          signInModeChanged: () async {
            _onSignInModeChanged(emit);
          },
          authorize: () async {
            await _authorize(emit);
          },
          failureChecked: () async {
            emit(state.copyWith(failure: null));
          },
          signInWithGoogle: () async {
            await _onSignInWithGoogle(emit);
          },
          signInWithFacebook: () async {
            await _onSignInWithFacebook(emit);
          },
        );
      },
    );
  }

  void _onEmailChanged(
    String email,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        email: email,
        isValid: _isValid(email, state.password),
      ),
    );
  }

  void _onPasswordChanged(
    String password,
    Emitter<AuthState> emit,
  ) {
    emit(
      state.copyWith(
        password: password,
        isValid: _isValid(state.email, password),
      ),
    );
  }

  void _onSignInModeChanged(Emitter<AuthState> emit) {
    emit(
      state.copyWith(
        isSignIn: !state.isSignIn,
      ),
    );
  }

  Future<void> _authorize(Emitter<AuthState> emit) async {
    if (state.isSignIn) {
      await _performSignIn(emit);
    } else {
      await _performSignUp(emit);
    }
  }

  Future<void> _performSignIn(Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final params = AuthUseCaseParams(
      email: state.email,
      password: state.password,
    );
    final result = await signInUseCase.execute(params);
    result.fold(
      (failure) {
        emit(state.copyWith(
          isLoading: false,
          failure: failure,
        ));
      },
      (result) {
        emit(state.copyWith(isLoading: false, authenticated: true));
      },
    );
  }

  Future<void> _performSignUp(Emitter<AuthState> emit) async {
    emit(state.copyWith(isLoading: true));
    final params = AuthUseCaseParams(
      email: state.email,
      password: state.password,
    );
    final result = await signUpUseCase.execute(params);
    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, failure: failure));
      },
      (result) async {
        await _createProfile(result);
        emit(state.copyWith(isLoading: false, authenticated: true));
      },
    );
  }

  Future<void> _onSignInWithGoogle(Emitter<AuthState> emit) async {
    final authCredentials =
        (await getGoogleAuthCredentialsUseCase.execute(null)).toNullable();

    if (authCredentials == null) {
      return;
    }

    return _signInWithCredentials(emit, authCredentials);
  }

  Future<void> _onSignInWithFacebook(Emitter<AuthState> emit) async {
    final authCredentials =
        (await getFacebookAuthCredentialsUseCase.execute(null)).toNullable();

    if (authCredentials == null) {
      return;
    }

    return _signInWithCredentials(emit, authCredentials);
  }

  Future<void> _signInWithCredentials(
    Emitter<AuthState> emit,
    AuthCredential authCredential,
  ) async {
    emit(state.copyWith(isLoading: true));

    final result = await signInWithCredentialsUseCase.execute(authCredential);

    await result.fold(
      (failure) async {
        emit(state.copyWith(isLoading: false, failure: failure));
      },
      (result) async {
        await _createProfile(result);
        emit(state.copyWith(isLoading: false, authenticated: true));
      },
    );
  }

  Future<void> _createProfile(UserModel? userModel) async {
    if (userModel == null) {
      return;
    }
    final profileModel = ProfileModel(
      userId: userModel.uid ?? '',
      email: userModel.email ?? '',
      userName: _getUserNameFromEmail(userModel.email),
    );

    createProfileUseCase.execute(profileModel);
  }

  String _getUserNameFromEmail(String? email) {
    if (email == null || email.isEmpty) {
      return '';
    }

    return email.substring(0, email.indexOf('@'));
  }

  bool _isValid(String email, String password) {
    return validator.isEmailValid(email) && validator.isPasswordValid(password);
  }
}
