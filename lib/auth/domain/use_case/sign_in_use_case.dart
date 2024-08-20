import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/model/user_model.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';
import '../exception_handler/firebase_auth_exception_handler.dart';
import 'params/auth_use_case_params.dart';

@injectable
class SignInUseCase
    with FirebaseAuthExceptionHandler
    implements FutureUseCase<AuthUseCaseParams, UserModel?> {
  final AuthRepository _authRepository;

  SignInUseCase(this._authRepository);

  @override
  Future<Either<Failure, UserModel?>> execute(AuthUseCaseParams param) async {
    try {
      final userModel = await _authRepository.authenticateWithEmailAndPassword(
        param.email,
        param.password,
      );
      return Right(userModel);
    } on FirebaseAuthException catch (e) {
      return Left(handleSignInException(e));
    }
  }
}
