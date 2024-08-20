import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/expenses_repository.dart';
import 'package:expenses_tracker/core/domain/repository/profile_repository.dart';
import 'package:expenses_tracker/settings/domain/use_case/delete_account_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../fake_data/fake_data.dart';
import '../../../mocks/firebase_mocks.mocks.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late DeleteAccountUseCase deleteAccountUseCase;
  late FirebaseFirestore firebaseFirestore;
  late AuthRepository authRepository;
  late ExpensesRepository expensesRepository;
  late ProfileRepository profileRepository;

  setUp(() {
    firebaseFirestore = MockFirebaseFirestore();
    authRepository = MockAuthRepository();
    expensesRepository = MockExpensesRepository();
    profileRepository = MockProfileRepository();
    deleteAccountUseCase = DeleteAccountUseCase(
      firebaseFirestore,
      authRepository,
      expensesRepository,
      profileRepository,
    );
  });

  test('test delete account is correct', () async {
    final userId = fakeUser.uid!;

    await deleteAccountUseCase.execute(userId);

    verify(firebaseFirestore.terminate()).called(1);
    verify(firebaseFirestore.clearPersistence()).called(1);
    verify(profileRepository.deleteProfile(userId)).called(1);
    verify(expensesRepository.deleteAll(userId)).called(1);
    verify(authRepository.deleteAccount()).called(1);
  });
}
