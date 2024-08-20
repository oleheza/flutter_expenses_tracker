import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/use_case/future_use_case.dart';
import '../exception_handler/firebase_auth_exception_handler.dart';

@injectable
class GetFacebookAuthCredentialsUseCase
    with FirebaseAuthExceptionHandler
    implements FutureUseCase<void, AuthCredential?> {
  final FacebookAuth _facebookAuth;

  GetFacebookAuthCredentialsUseCase(this._facebookAuth);

  @override
  Future<Either<Failure, AuthCredential?>> execute(void param) async {
    final loginResult = await _facebookAuth.login();

    final token = loginResult.accessToken?.token;

    return (token == null)
        ? const Left(Failure.genericFailure())
        : Right(FacebookAuthProvider.credential(token));
  }
}
