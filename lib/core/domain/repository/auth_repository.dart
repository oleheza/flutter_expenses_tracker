import '../model/user_model.dart';

abstract interface class AuthRepository {
  Future<UserModel?> authenticateWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserModel?> createUserWithEmailAndPassword(
    String email,
    String password,
  );

  Future<UserModel?> getCurrentUserAsync();

  UserModel? getCurrentUser();

  Stream<UserModel?> observeUserStatus();

  Future<void> deleteAccount();

  Future<void> signOut();

  Future<void> resetPassword(String email);
}
