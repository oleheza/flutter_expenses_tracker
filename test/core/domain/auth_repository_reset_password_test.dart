import 'package:expenses_tracker/core/data/repository/firebase_auth_repository.dart';
import 'package:expenses_tracker/core/domain/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../fake_data/fake_data.dart';
import 'auth_repository_reset_password_test.mocks.dart';

@GenerateMocks([FirebaseAuth])
void main() {
  late AuthRepository authRepository;
  late FirebaseAuth firebaseAuth;

  setUp(() {
    firebaseAuth = MockFirebaseAuth();
    authRepository = FirebaseAuthRepository(firebaseAuth);
  });

  test(
    'test reset password is correct',
    () async {
      await authRepository.resetPassword(fakeEmail);

      verify(firebaseAuth.sendPasswordResetEmail(email: fakeEmail)).called(1);
    },
  );
}
