class ProfileModel {
  static const fieldId = "id";
  static const fieldUserId = 'user_id';
  static const fieldEmail = 'email';
  static const fieldUserName = 'username';

  final String? id;
  final String userId;
  final String email;
  final String? userName;

  ProfileModel({
    this.id,
    required this.userId,
    required this.email,
    this.userName,
  });

  ProfileModel.fromMap(String? id, Map<String, dynamic> map)
      : this(
          id: id,
          userId: map[fieldUserId],
          email: map[fieldEmail],
          userName: map[fieldUserName],
        );

  Map<String, dynamic> asMap() {
    return {
      fieldUserId: userId,
      fieldEmail: email,
      fieldUserName: userName,
    };
  }

  copyWith({
    String? email,
    String? userName,
  }) {
    return ProfileModel(
      id: id,
      userId: userId,
      email: email ?? this.email,
      userName: userName ?? this.userName,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ProfileModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.email, email) || other.email == email) &&
            (identical(other.userName, userName) ||
                other.userName == userName) &&
            (identical(other.userId, userId) && other.userId == userId));
  }

  @override
  int get hashCode => Object.hash(id, email, userName, userId);
}
