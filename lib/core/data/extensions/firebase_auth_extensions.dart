import 'package:firebase_auth/firebase_auth.dart';

import '../../domain/model/user_model.dart';

extension UserExtension on User {
  UserModel toUserModel() {
    return UserModel(
      uid: uid,
      email: email,
      displayName: displayName,
      photoUrl: photoURL,
    );
  }
}
