class UserModel {
  final String? uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  UserModel({
    this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModel &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          email == other.email &&
          displayName == other.displayName &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => Object.hash(uid, email, displayName, photoUrl);
}
