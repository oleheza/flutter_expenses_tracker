part of 'auth_bloc.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    Failure? failure,
    bool? authenticated,
    @Default('') String email,
    @Default('') String password,
    @Default(false) bool isValid,
    @Default(true) bool isSignIn,
    @Default(false) bool isLoading,
  }) = _AuthState;
}
