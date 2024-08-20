import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../../domain/model/user_model.dart';
import '../../domain/repository/auth_repository.dart';
import '../extensions/firebase_auth_extensions.dart';

@Injectable(as: AuthRepository)
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  FirebaseAuthRepository(this._firebaseAuth);

  @override
  Future<UserModel?> authenticateWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user?.toUserModel();
  }

  @override
  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user?.toUserModel();
  }

  @override
  Future<void> signOut() {
    return _firebaseAuth.signOut();
  }

  @override
  Stream<UserModel?> observeUserStatus() {
    return _firebaseAuth.authStateChanges().map((user) => user?.toUserModel());
  }

  @override
  Future<UserModel?> getCurrentUserAsync() async {
    return getCurrentUser();
  }

  @override
  UserModel? getCurrentUser() {
    return _firebaseAuth.currentUser?.toUserModel();
  }

  @override
  Future<void> deleteAccount() async {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      await currentUser.delete();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
