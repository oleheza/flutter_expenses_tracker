import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:expenses_tracker/settings/domain/use_case/logout_use_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../mocks/firebase_mocks.mocks.dart';
import '../../../mocks/repository_mocks.mocks.dart';

void main() {
  late LogoutUseCase logoutUseCase;
  late AuthRepository authRepository;
  late FirebaseFirestore firebaseFirestore;

  setUp(() {
    authRepository = MockAuthRepository();
    firebaseFirestore = MockFirebaseFirestore();
    logoutUseCase = LogoutUseCase(authRepository, firebaseFirestore);
  });

  test('test logout is correct', () async {
    logoutUseCase.execute(null);

    verify(firebaseFirestore.clearPersistence()).called(1);
    verify(authRepository.signOut()).called(1);
  });
}
