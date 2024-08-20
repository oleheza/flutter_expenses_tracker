part of 'auth_bloc.dart';

@freezed
class AuthEvent with _$AuthEvent {
  const factory AuthEvent.emailChanged({
    String? email,
  }) = _EmailChanged;

  const factory AuthEvent.passwordChanged({
    String? password,
  }) = _PasswordChanged;

  const factory AuthEvent.signInModeChanged() = _SignInModeChanged;

  const factory AuthEvent.authorize() = _Authorize;

  const factory AuthEvent.signInWithGoogle() = _SignInWithGoogle;

  const factory AuthEvent.signInWithFacebook() = _SignInWithFacebook;

  const factory AuthEvent.failureChecked() = _FailureChecked;
}
