part of 'forgot_password_bloc.dart';

@freezed
class ForgotPasswordState with _$ForgotPasswordState {
  const factory ForgotPasswordState({
    Failure? failure,
    @Default('') String email,
    @Default(false) bool passwordReset,
    @Default(false) bool isLoading,
    @Default(false) bool isValid,
  }) = _ForgotPasswordState;
}
