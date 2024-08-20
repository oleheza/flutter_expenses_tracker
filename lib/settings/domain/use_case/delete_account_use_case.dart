import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import '../../../core/domain/failure/failure.dart';
import '../../../core/domain/repository/auth_repository.dart';
import '../../../core/domain/repository/expenses_repository.dart';
import '../../../core/domain/repository/profile_repository.dart';
import '../../../core/domain/use_case/future_use_case.dart';

@injectable
class DeleteAccountUseCase implements FutureUseCase<String, void> {
  final FirebaseFirestore _firebaseFirestore;
  final ExpensesRepository _expensesRepository;
  final AuthRepository _authRepository;
  final ProfileRepository _profileRepository;

  DeleteAccountUseCase(
    this._firebaseFirestore,
    this._authRepository,
    this._expensesRepository,
    this._profileRepository,
  );

  @override
  Future<Either<Failure, void>> execute(String param) async {
    await _firebaseFirestore.terminate();
    await Future.wait([
      _firebaseFirestore.clearPersistence(),
      _profileRepository.deleteProfile(param),
      _expensesRepository.deleteAll(param),
      _authRepository.deleteAccount(),
    ]);

    return const Right(null);
  }
}
