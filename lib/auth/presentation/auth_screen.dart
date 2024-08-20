import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/domain/validator/validator.dart';
import '../../core/presentation/widgets/adaptive/adaptive_scaffold.dart';
import '../bloc/auth_bloc.dart';
import '../domain/use_case/create_profile_use_case.dart';
import '../domain/use_case/get_facebook_auth_credentials_use_case.dart';
import '../domain/use_case/get_google_auth_credentials_use_case.dart';
import '../domain/use_case/sign_in_use_case.dart';
import '../domain/use_case/sign_in_with_credentials_use_case.dart';
import '../domain/use_case/sign_up_use_case.dart';
import 'auth_screen_content.dart';

class AuthScreen extends StatelessWidget {
  static String route = '/auth';
  static String screenName = 'auth';

  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final GetGoogleAuthCredentialsUseCase getGoogleAuthCredentialsUseCase;
  final GetFacebookAuthCredentialsUseCase getFacebookAuthCredentialsUseCase;
  final SignInWithCredentialsUseCase signInWithCredentialsUseCase;
  final CreateProfileUseCase createProfileUseCase;
  final Validator validator;

  const AuthScreen({
    super.key,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.getGoogleAuthCredentialsUseCase,
    required this.getFacebookAuthCredentialsUseCase,
    required this.signInWithCredentialsUseCase,
    required this.createProfileUseCase,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return AdaptiveScaffold(
      child: SafeArea(
        child: BlocProvider(
          create: (context) => AuthBloc(
            signInUseCase: signInUseCase,
            signUpUseCase: signUpUseCase,
            getGoogleAuthCredentialsUseCase: getGoogleAuthCredentialsUseCase,
            getFacebookAuthCredentialsUseCase:
                getFacebookAuthCredentialsUseCase,
            signInWithCredentialsUseCase: signInWithCredentialsUseCase,
            createProfileUseCase: createProfileUseCase,
            validator: validator,
          ),
          child: const AuthScreenContent(),
        ),
      ),
    );
  }
}
