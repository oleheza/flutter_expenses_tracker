import 'package:expenses_tracker/core/data/repository/firebase_auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fake_data/fake_data.dart';

void main() {
  late FirebaseAuth firebaseAuth;
  late FirebaseAuthRepository authRepository;

  final mockUser = MockUser(
    uid: fakeUser.uid,
    email: fakeUser.email,
    displayName: fakeUser.displayName,
    photoURL: fakeUser.photoUrl,
  );

  setUp(() {
    firebaseAuth = MockFirebaseAuth(mockUser: mockUser);
    authRepository = FirebaseAuthRepository(firebaseAuth);
  });

  test('test authenticate with email and password is correct', () async {
    final result = await authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    );

    expect(result, fakeUser);

    final user = await authRepository.getCurrentUserAsync();
    expect(user, fakeUser);
  });

  test('test create user with email and password is correct', () async {
    final result = await authRepository.createUserWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    );

    expect(result?.email, fakeEmail);
  });

  test('test sign out is correct', () async {
    authRepository.signOut();
    expect(firebaseAuth.currentUser, null);
  });

  test('test delete account is correct', () async {
    final result = await authRepository.authenticateWithEmailAndPassword(
      fakeEmail,
      fakePassword,
    );

    expect(result, fakeUser);

    await authRepository.deleteAccount();
  });

  test(
    'test observe user status is correct',
    () async {
      final stream = authRepository.observeUserStatus();

      expectLater(stream, emitsInOrder([null, fakeUser, null]));

      await authRepository.authenticateWithEmailAndPassword(
        fakeEmail,
        fakePassword,
      );

      await authRepository.signOut();
    },
  );
}
