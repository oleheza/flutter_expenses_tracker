import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/domain/failure/reset_password_failure_reason.dart';
import '../../core/presentation/adaptive_dialog_action_data.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widget_extensions.dart';
import '../../core/presentation/widget_keys.dart';
import '../../core/presentation/widgets/adaptive/adaptive_filled_button.dart';
import '../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';
import '../../core/presentation/widgets/vertical_spacer.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordScreenContent extends StatelessWidget {
  const ForgotPasswordScreenContent({super.key});

  void _showResetPasswordFailure(
    BuildContext context,
    ResetPasswordFailureReason reason,
    Function(BuildContext) onDialogOk,
  ) {
    final message = reason.when(
      invalidEmail: () => context.tr.resetPasswordFailureInvalidEmail,
      userNotFound: () => context.tr.resetPasswordFailureUserNotFound,
      unknown: () => context.tr.resetPasswordFailureUnknown,
    );

    showSimpleAdaptiveDialog(
      context: context,
      text: message,
      actions: <AdaptiveDialogActionData>[
        AdaptiveDialogActionData(
          key: WidgetKeys.dialogOkButton,
          text: context.tr.ok,
          onPress: onDialogOk,
        )
      ],
    );
  }

  void _showResetPasswordSuccess(BuildContext context) {
    showSimpleAdaptiveDialog(
      context: context,
      text: context.tr.resetPasswordSuccess,
      actions: <AdaptiveDialogActionData>[
        AdaptiveDialogActionData(
          key: WidgetKeys.dialogOkButton,
          text: context.tr.ok,
          onPress: (ctx) {
            ctx.pop();
            ctx.pop();
          },
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    void addEvent(BuildContext context, ForgotPasswordEvent event) =>
        context.read<ForgotPasswordBloc>().add(event);

    return MultiBlocListener(
      listeners: [
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (previous, state) =>
              state.isLoading != previous.isLoading,
          listener: (ctx, state) {
            if (state.isLoading) {
              showLoader(ctx, ctx.tr.loading);
            } else {
              ctx.pop();
            }
          },
        ),
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (_, state) => state.failure != null,
          listener: (ctx, state) {
            state.failure?.maybeWhen(
              resetPasswordFailure: (reason) => _showResetPasswordFailure(
                ctx,
                reason,
                (_) {
                  addEvent(ctx, const ForgotPasswordEvent.failureDismissed());
                },
              ),
              orElse: () {},
            );
          },
        ),
        BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listenWhen: (_, state) => state.passwordReset,
          listener: (ctx, _) => _showResetPasswordSuccess(ctx),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            AdaptiveOutlinedTextField(
              key: WidgetKeys.forgotPasswordEmailKey,
              hint: context.tr.email,
              onChanged: (text) => addEvent(
                context,
                ForgotPasswordEvent.onEmailChanged(email: text),
              ),
            ),
            const VerticalSpacer(),
            BlocSelector<ForgotPasswordBloc, ForgotPasswordState, bool>(
              selector: (state) => state.isValid,
              builder: (context, state) {
                return AdaptiveFilledButton(
                  key: WidgetKeys.forgotPasswordResetKey,
                  enabled: state,
                  onClick: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    addEvent(
                        context, const ForgotPasswordEvent.resetPassword());
                  },
                  child: Text(context.tr.resetPassword),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
