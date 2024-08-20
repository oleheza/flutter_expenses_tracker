import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain/validator/validator.dart';
import '../../core/presentation/build_context_extensions.dart';
import '../../core/presentation/widgets/adaptive/adaptive_app_bar.dart';
import '../../core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import '../bloc/forgot_password_bloc.dart';
import '../domain/use_case/request_forgot_password_use_case.dart';
import 'forgot_password_screen_content.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const route = '/forgot-password';
  static const screenName = 'forgot-password';

  final RequestForgotPasswordUseCase forgotPasswordUseCase;
  final Validator validator;

  const ForgotPasswordScreen({
    super.key,
    required this.forgotPasswordUseCase,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final title = Text(context.tr.recoverPasswordTitle);

    return AdaptiveScaffold(
      appBar: AdaptiveAppBar(
        material: (_) => MaterialAppBarData(title: title),
        cupertino: (_) => CupertinoAppBarData(middle: title),
      ),
      child: BlocProvider(
        create: (context) => ForgotPasswordBloc(
          forgotPasswordUseCase: forgotPasswordUseCase,
          validator: validator,
        ),
        child: const ForgotPasswordScreenContent(),
      ),
    );
  }
}
