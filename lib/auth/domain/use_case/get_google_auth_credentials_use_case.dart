import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/use_case/future_use_case.dart';
import '../exception_handler/firebase_auth_exception_handler.dart';

@injectable
class GetGoogleAuthCredentialsUseCase
    with FirebaseAuthExceptionHandler
    implements FutureUseCase<void, AuthCredential?> {
  final GoogleSignIn _googleSignIn;

  GetGoogleAuthCredentialsUseCase(
    this._googleSignIn,
  );

  @override
  Future<Either<Failure, AuthCredential?>> execute(void param) async {
    final googleUser = await _googleSignIn.signIn();

    final googleAuth = await googleUser?.authentication;

    if (googleAuth == null) {
      return const Left(Failure.genericFailure());
    }
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    return Right(credential);
  }
}
