import 'package:expenses_tracker/auth/domain/use_case/create_profile_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_facebook_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/get_google_auth_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_in_with_credentials_use_case.dart';
import 'package:expenses_tracker/auth/domain/use_case/sign_up_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/add_expenses_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/get_expenses_by_id_use_case.dart';
import 'package:expenses_tracker/create_or_update_expenses/domain/use_case/update_expenses_use_case.dart';
import 'package:expenses_tracker/forgot_password/domain/use_case/request_forgot_password_use_case.dart';
import 'package:expenses_tracker/profile/edit/domain/edit_profile_use_case.dart';
import 'package:expenses_tracker/profile/edit/domain/get_profile_by_user_id_use_case.dart';
import 'package:expenses_tracker/settings/domain/use_case/delete_account_use_case.dart';
import 'package:expenses_tracker/settings/domain/use_case/logout_use_case.dart';
import 'package:mockito/annotations.dart';

@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<LogoutUseCase>(),
    MockSpec<DeleteAccountUseCase>(),
    MockSpec<SignInUseCase>(),
    MockSpec<SignUpUseCase>(),
    MockSpec<GetGoogleAuthCredentialsUseCase>(),
    MockSpec<GetFacebookAuthCredentialsUseCase>(),
    MockSpec<SignInWithCredentialsUseCase>(),
    MockSpec<CreateProfileUseCase>(),
    MockSpec<AddExpensesUseCase>(),
    MockSpec<UpdateExpensesUseCase>(),
    MockSpec<GetExpensesByIdUseCase>(),
    MockSpec<GetProfileByUserIdUseCase>(),
    MockSpec<EditProfileUseCase>(),
    MockSpec<RequestForgotPasswordUseCase>(),
  ],
)
class Mocks {}
