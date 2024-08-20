import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../app/config/app_svgs.dart';
import '../../core/domain/failure/auth_failure_reason.dart';
import '../../core/presentation/adaptive_dialog_action_data.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widget_extensions.dart';
import '../../core/presentation/widget_keys.dart';
import '../../core/presentation/widgets/adaptive/adaptive_filled_button.dart';
import '../../core/presentation/widgets/adaptive/adaptive_outlined_text_field.dart';
import '../../core/presentation/widgets/adaptive/adaptive_text.dart';
import '../../core/presentation/widgets/adaptive/adaptive_text_button.dart';
import '../../core/presentation/widgets/vertical_spacer.dart';
import '../../forgot_password/presentation/forgot_password_screen.dart';
import '../../home/home_screen.dart';
import '../bloc/auth_bloc.dart';
import 'widgets/social_sign_in_button.dart';

class AuthScreenContent extends StatelessWidget {
  const AuthScreenContent({super.key});

  void _showAuthFailure(
    BuildContext context,
    AuthFailureReason reason,
  ) {
    final message = reason.when(
      unknown: () => context.tr.unknownFailure,
      passwordTooWeak: () => context.tr.passwordTooWeak,
      wrongPassword: () => context.tr.wrongPassword,
      userNotFound: () => context.tr.userNotFound,
      emailInUse: () => context.tr.emailInUse,
      invalidCredential: () => context.tr.wrongCredentials,
      accountAlreadyExistsWithDifferentCredentials: () =>
          context.tr.accountInUseWithDifferentCredentials,
    );

    showSimpleAdaptiveDialog(
      context: context,
      text: message,
      actions: <AdaptiveDialogActionData>[
        AdaptiveDialogActionData(
          key: WidgetKeys.dialogOkButton,
          text: context.tr.ok,
          onPress: (ctx) {
            context.read<AuthBloc>().add(const AuthEvent.failureChecked());
            context.pop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: <BlocListener>[
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previousState, state) {
            return state.isLoading != previousState.isLoading;
          },
          listener: (ctx, state) {
            if (state.isLoading) {
              showLoader(
                context,
                ctx.tr.loading,
              );
            }
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (previousState, state) {
            return state.failure != null;
          },
          listener: (ctx, state) {
            context.pop();
            state.failure?.maybeWhen(
              signInFailed: (reason) => _showAuthFailure(ctx, reason),
              signUpFailed: (reason) => _showAuthFailure(ctx, reason),
              orElse: () {},
            );
          },
        ),
        BlocListener<AuthBloc, AuthState>(
          listenWhen: (_, state) => state.authenticated ?? false,
          listener: (ctx, _) {
            ctx.pushReplacementNamed(HomeScreen.screenName);
          },
        ),
      ],
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: 250,
              alignment: Alignment.bottomCenter,
              child: const _WelcomeText(),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: _AuthForm(),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthForm extends StatelessWidget {
  const _AuthForm({super.key});

  void _addEvent(BuildContext context, AuthEvent event) {
    context.read<AuthBloc>().add(event);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          AdaptiveOutlinedTextField(
            key: WidgetKeys.authEmailKey,
            hint: context.tr.email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            onChanged: (email) {
              _addEvent(context, AuthEvent.emailChanged(email: email));
            },
            material: (_) => MaterialOutlinedTextFieldData(
              prefixIcon: const Icon(Icons.person),
            ),
            cupertino: (_) => CupertinoOutlinedTextFieldData(
              prefix: const Icon(CupertinoIcons.person),
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          const VerticalSpacer(),
          AdaptiveOutlinedTextField(
            key: WidgetKeys.authPasswordKey,
            hint: context.tr.password,
            keyboardType: TextInputType.text,
            textInputAction: TextInputAction.done,
            obscureText: true,
            onChanged: (password) {
              _addEvent(
                context,
                AuthEvent.passwordChanged(password: password),
              );
            },
            material: (_) => MaterialOutlinedTextFieldData(
              prefixIcon: const Icon(Icons.lock),
            ),
            cupertino: (_) => CupertinoOutlinedTextFieldData(
              prefix: const Icon(CupertinoIcons.lock),
              clearButtonMode: OverlayVisibilityMode.editing,
            ),
          ),
          const VerticalSpacer(),
          _SignInButton(
            key: WidgetKeys.authSignInKey,
            onClick: () => _addEvent(
              context,
              const AuthEvent.authorize(),
            ),
          ),
          _SwitchSignInModeButton(
            key: WidgetKeys.authSwitchModeKey,
            onClick: () => _addEvent(
              context,
              const AuthEvent.signInModeChanged(),
            ),
          ),
          AdaptiveTextButton(
            key: WidgetKeys.authForgotPasswordKey,
            onClick: () {
              context.pushNamed(ForgotPasswordScreen.screenName);
            },
            child: Text(context.tr.forgotPasswordQ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AdaptiveText(
              text: '-${context.tr.loginUsingSocialNetworks}-',
              textStyle: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
              material: (_) => MaterialTextData(
                textColor: context.materialTheme.colorScheme.primary,
              ),
              cupertino: (_) => CupertinoTextData(
                textColor: context.cupertinoTheme.primaryColor,
              ),
            ),
          ),
          _SocialSignInButtons(
            onAddEvent: _addEvent,
          ),
        ],
      ),
    );
  }
}

class _WelcomeText extends StatelessWidget {
  const _WelcomeText({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 36.0,
        vertical: 8,
      ),
      child: AdaptiveText(
        text: context.tr.welcomeMessage,
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
        ),
        material: (_) => MaterialTextData(
          textColor: context.materialTheme.colorScheme.primary,
        ),
        cupertino: (_) => CupertinoTextData(
          textColor: context.cupertinoTheme.primaryColor,
        ),
      ),
    );
  }
}

class _SignInButton extends StatelessWidget {
  final VoidCallback onClick;

  const _SignInButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return BlocSelector<AuthBloc, AuthState, bool>(
      selector: (state) => state.isValid,
      builder: (_, isValid) {
        return AdaptiveFilledButton(
          onClick: () {
            FocusManager.instance.primaryFocus?.unfocus();
            onClick.call();
          },
          enabled: isValid,
          child: BlocSelector<AuthBloc, AuthState, bool>(
            selector: (state) => state.isSignIn,
            builder: (_, isSignIn) {
              return Text(
                isSignIn ? context.tr.signIn : context.tr.signUp,
              );
            },
          ),
        );
      },
    );
  }
}

class _SwitchSignInModeButton extends StatelessWidget {
  final VoidCallback onClick;

  const _SwitchSignInModeButton({
    super.key,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveTextButton(
      onClick: onClick,
      child: BlocSelector<AuthBloc, AuthState, bool>(
        selector: (state) => state.isSignIn,
        builder: (_, isSignIn) {
          return Text(
            isSignIn
                ? context.tr.dontHaveAccount
                : context.tr.alreadyHaveAccount,
          );
        },
      ),
    );
  }
}

class _SocialSignInButtons extends StatelessWidget {
  final Function(BuildContext, AuthEvent) onAddEvent;

  const _SocialSignInButtons({
    super.key,
    required this.onAddEvent,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialSignInButton(
          key: WidgetKeys.authSignInWithGoogleKey,
          onPressed: () {
            onAddEvent.call(context, const AuthEvent.signInWithGoogle());
          },
          svgIcon: AppSvgs.googleLogo,
        ),
        SocialSignInButton(
          key: WidgetKeys.authSignInWithFbKey,
          onPressed: () {
            onAddEvent.call(context, const AuthEvent.signInWithFacebook());
          },
          svgIcon: AppSvgs.facebookLogo,
        ),
      ],
    );
  }
}
