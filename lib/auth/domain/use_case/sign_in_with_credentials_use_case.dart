import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/data/extensions/firebase_auth_extensions.dart';
import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/user_model.dart';
import '../../../core/domain/use_case/future_use_case.dart';
import '../exception_handler/firebase_auth_exception_handler.dart';

@injectable
class SignInWithCredentialsUseCase
    with FirebaseAuthExceptionHandler
    implements FutureUseCase<AuthCredential, UserModel?> {
  final FirebaseAuth _firebaseAuth;

  SignInWithCredentialsUseCase(this._firebaseAuth);

  @override
  Future<Either<Failure, UserModel?>> execute(AuthCredential param) async {
    try {
      final userCredential = await _firebaseAuth.signInWithCredential(param);

      return Right(userCredential.user?.toUserModel());
    } on FirebaseAuthException catch (e) {
      return Left(handleSignInException(e));
    }
  }
}
