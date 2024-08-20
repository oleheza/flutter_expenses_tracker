import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class LogoutUseCase implements FutureUseCase<void, void> {
  final AuthRepository _authRepository;
  final FirebaseFirestore _firebaseFirestore;

  LogoutUseCase(
    this._authRepository,
    this._firebaseFirestore,
  );

  @override
  Future<Either<Failure, void>> execute(void param) async {
    await Future.wait(
      <Future>[
        _firebaseFirestore.clearPersistence(),
        _authRepository.signOut(),
      ],
    );

    return const Right(null);
  }
}
