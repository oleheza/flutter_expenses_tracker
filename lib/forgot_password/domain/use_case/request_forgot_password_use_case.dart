import 'package:firebase_auth/firebase_auth.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../auth/domain/exception_handler/firebase_auth_exception_handler.dart';
import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class RequestForgotPasswordUseCase
    with FirebaseAuthExceptionHandler
    implements FutureUseCase<String, void> {
  final AuthRepository authRepository;

  RequestForgotPasswordUseCase({required this.authRepository});

  @override
  Future<Either<Failure, void>> execute(String param) async {
    try {
      authRepository.resetPassword(param);

      return const Right(null);
    } on FirebaseAuthException catch (e) {
      return Left(handleResetPasswordException(e));
    }
  }
}
