import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../core/domain/failure/failure.dart';
import '../../core/domain/validator/validator.dart';
import '../domain/use_case/request_forgot_password_use_case.dart';

part 'forgot_password_bloc.freezed.dart';
part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  final RequestForgotPasswordUseCase forgotPasswordUseCase;
  final Validator validator;

  ForgotPasswordBloc({
    required this.forgotPasswordUseCase,
    required this.validator,
  }) : super(const ForgotPasswordState()) {
    on<ForgotPasswordEvent>((event, emit) async {
      await event.when(
        onEmailChanged: (email) async => _onEmailChanged(emit, email ?? ''),
        resetPassword: () async => _onResetPassword(emit),
        failureDismissed: () async => emit(state.copyWith(failure: null)),
      );
    });
  }

  Future<void> _onEmailChanged(
    Emitter<ForgotPasswordState> emit,
    String email,
  ) async {
    emit(
      state.copyWith(
        email: email,
        isValid: validator.isEmailValid(email),
      ),
    );
  }

  Future<void> _onResetPassword(Emitter<ForgotPasswordState> emit) async {
    emit(state.copyWith(isLoading: true, failure: null));

    final result = await forgotPasswordUseCase.execute(state.email);
    result.fold(
      (l) => emit(state.copyWith(failure: l, isLoading: false)),
      (r) => emit(state.copyWith(isLoading: false, passwordReset: true)),
    );
  }
}
